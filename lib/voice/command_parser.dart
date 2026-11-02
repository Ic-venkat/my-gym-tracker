import 'exercise_aliases.dart' as aliases;
import 'number_word_converter.dart';
import 'voice_command.dart';

/// Pure NLP parser for converting natural speech strings into [VoiceCommand]s.
class CommandParser {
  CommandParser._();

  /// Parses raw speech input into a strongly-typed [VoiceCommand].
  static VoiceCommand parse(String input) {
    if (input.trim().isEmpty) {
      return const UnknownCommand('');
    }

    // 1. Sanitize input: strip punctuation, normalize decimals and spaces
    String clean = input.trim().toLowerCase();
    clean = clean.replaceAll(RegExp(r'^[^\w\s]+|[^\w\s]+$'), '');
    clean = clean.replaceAllMapped(
      RegExp(r'(\d+),(\d+)'),
      (Match m) => '${m.group(1)}.${m.group(2)}',
    );
    clean = NumberWordConverter.convert(clean);
    clean = clean.replaceAll(RegExp(r'\s+'), ' ');

    // 2. Session control: Start Workout
    if (_isStartWorkout(clean)) {
      return _parseStartWorkout(clean);
    }

    // 3. Session control: End Workout
    if (_isEndWorkout(clean)) {
      return const EndWorkoutCommand();
    }

    // 4. Rest timer commands
    final RestTimerCommand? restCmd = _parseRestTimer(clean);
    if (restCmd != null) {
      return restCmd;
    }

    // 5. Add exercise
    final AddExerciseCommand? addCmd = _parseAddExercise(clean);
    if (addCmd != null) {
      return addCmd;
    }

    // 6. Log set command (most common gym action)
    final LogSetCommand? logCmd = _parseLogSet(clean);
    if (logCmd != null) {
      return logCmd;
    }

    return UnknownCommand(input);
  }

  /// Maps common lifter aliases and abbreviations to canonical names.
  static String normalizeExerciseName(String raw) =>
      aliases.normalizeExerciseName(raw);

  static bool _isStartWorkout(String clean) {
    return clean.startsWith('start workout') ||
        clean.startsWith('begin workout') ||
        clean.startsWith('new workout');
  }

  static StartWorkoutCommand _parseStartWorkout(String clean) {
    final RegExp regex = RegExp(
      r'^(?:start|begin|new)\s+workout(?:\s+(?:called|named)?\s*(.+))?$',
    );
    final RegExpMatch? match = regex.firstMatch(clean);
    final String? title = match?.group(1);
    if (title != null && title.trim().isNotEmpty) {
      final String formatted = title.trim();
      return StartWorkoutCommand(
        title: formatted[0].toUpperCase() + formatted.substring(1),
      );
    }
    return const StartWorkoutCommand();
  }

  static bool _isEndWorkout(String clean) {
    return clean == 'end workout' ||
        clean == 'finish workout' ||
        clean == 'complete workout' ||
        clean == 'stop workout';
  }

  static RestTimerCommand? _parseRestTimer(String clean) {
    // 1. Compound: "rest 1 minute 30 seconds" or "rest 1 min 30"
    final RegExp compound = RegExp(
      r'^(?:rest|timer|break)(?:\s+for)?\s+(\d+)\s*(?:minutes?|mins?|m)\s*(?:and)?\s*(\d+)?\s*(?:seconds?|secs?|s)?$',
    );
    final RegExpMatch? compMatch = compound.firstMatch(clean);
    if (compMatch != null) {
      final int minutes = int.parse(compMatch.group(1)!);
      final int seconds = compMatch.group(2) != null
          ? int.parse(compMatch.group(2)!)
          : 0;
      return RestTimerCommand(seconds: (minutes * 60) + seconds);
    }

    // 2. Simple: "rest 90 seconds", "timer 2 minutes", "rest 60s"
    final RegExp regex = RegExp(
      r'^(?:rest|timer|break)(?:\s+for)?\s+(\d+)\s*(seconds?|secs?|s|minutes?|mins?|m)?$',
    );
    final RegExpMatch? match = regex.firstMatch(clean);
    if (match != null) {
      final int value = int.parse(match.group(1)!);
      final String? unit = match.group(2);
      if (unit != null && (unit.startsWith('min') || unit == 'm')) {
        return RestTimerCommand(seconds: value * 60);
      }
      return RestTimerCommand(seconds: value);
    }
    return null;
  }

  static AddExerciseCommand? _parseAddExercise(String clean) {
    final RegExp regex = RegExp(r'^(?:add\s+exercise|add)\s+([a-z\s-]+)$');
    final RegExpMatch? match = regex.firstMatch(clean);
    if (match != null) {
      final String name = match.group(1)!.trim();
      if (!name.contains('reps') &&
          !name.contains('sets') &&
          !name.contains('kg')) {
        return AddExerciseCommand(exerciseName: normalizeExerciseName(name));
      }
    }
    return null;
  }

  static LogSetCommand? _parseLogSet(String clean) {
    final String text = clean
        .replaceAll('kilos', 'kg')
        .replaceAll('kilograms', 'kg')
        .replaceAll('pounds', 'lbs');

    // Pattern 1: "log bench press 3 sets 10 reps 80 kg"
    final RegExp regexFull = RegExp(
      r'^(?:log\s+)?(.+?)\s+(\d+)\s*sets?\s*(?:of\s*)?(\d+)\s*reps?\s*(?:at\s*)?(\d+(?:\.\d+)?)\s*(kg|lbs)?$',
    );
    final RegExpMatch? matchFull = regexFull.firstMatch(text);
    if (matchFull != null) {
      return LogSetCommand(
        exerciseName: normalizeExerciseName(matchFull.group(1)!),
        sets: int.parse(matchFull.group(2)!),
        reps: int.parse(matchFull.group(3)!),
        weight: double.parse(matchFull.group(4)!),
        unit: matchFull.group(5) ?? 'kg',
      );
    }

    // Pattern 2: "log bench press 10 reps 80 kg"
    final RegExp regexSingle = RegExp(
      r'^(?:log\s+)?(.+?)\s+(\d+)\s*reps?\s*(?:at\s*)?(\d+(?:\.\d+)?)\s*(kg|lbs)?$',
    );
    final RegExpMatch? matchSingle = regexSingle.firstMatch(text);
    if (matchSingle != null) {
      return LogSetCommand(
        exerciseName: normalizeExerciseName(matchSingle.group(1)!),
        reps: int.parse(matchSingle.group(2)!),
        weight: double.parse(matchSingle.group(3)!),
        unit: matchSingle.group(4) ?? 'kg',
      );
    }

    // Pattern 3: Weight-first (e.g. "bench 80 kg for 10 reps", "squat 100 x 5")
    final RegExp regexWeightFirst = RegExp(
      r'^(?:log\s+)?(.+?)\s+(\d+(?:\.\d+)?)\s*(kg|lbs)?\s*(?:for|x)\s*(\d+)(?:\s*(?:reps?|times?))?$',
    );
    final RegExpMatch? matchWf = regexWeightFirst.firstMatch(text);
    if (matchWf != null) {
      return LogSetCommand(
        exerciseName: normalizeExerciseName(matchWf.group(1)!),
        reps: int.parse(matchWf.group(4)!),
        weight: double.parse(matchWf.group(2)!),
        unit: matchWf.group(3) ?? 'kg',
      );
    }

    // Pattern 4: "bench press 10 at 80" or "bench press 10 by 80"
    final RegExp regexShort = RegExp(
      r'^(?:log\s+)?(.+?)\s+(\d+)\s*(?:at|by)\s*(\d+(?:\.\d+)?)\s*(kg|lbs)?$',
    );
    final RegExpMatch? matchShort = regexShort.firstMatch(text);
    if (matchShort != null) {
      return LogSetCommand(
        exerciseName: normalizeExerciseName(matchShort.group(1)!),
        reps: int.parse(matchShort.group(2)!),
        weight: double.parse(matchShort.group(3)!),
        unit: matchShort.group(4) ?? 'kg',
      );
    }

    // Pattern 5: Bodyweight (e.g. "log pull-ups 10 reps", "pushups 15 reps")
    final RegExp regexBodyweight = RegExp(
      r'^(?:log\s+)?(.+?)\s+(\d+)\s*reps?$',
    );
    final RegExpMatch? matchBw = regexBodyweight.firstMatch(text);
    if (matchBw != null) {
      return LogSetCommand(
        exerciseName: normalizeExerciseName(matchBw.group(1)!),
        reps: int.parse(matchBw.group(2)!),
        weight: 0.0,
      );
    }

    return null;
  }
}
