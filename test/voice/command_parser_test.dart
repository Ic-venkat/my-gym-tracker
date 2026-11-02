import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/voice/command_parser.dart';
import 'package:gym_tracker/voice/voice_command.dart';

void main() {
  group('CommandParser', () {
    test('parses StartWorkoutCommand with default title', () {
      final VoiceCommand result = CommandParser.parse('start workout');
      expect(result, isA<StartWorkoutCommand>());
      if (result is StartWorkoutCommand) {
        expect(result.title, 'Workout');
      }
    });

    test('parses StartWorkoutCommand with trailing punctuation', () {
      final VoiceCommand result = CommandParser.parse(
        'start workout chest day.',
      );
      expect(result, isA<StartWorkoutCommand>());
      if (result is StartWorkoutCommand) {
        expect(result.title, 'Chest day');
      }
    });

    test('parses EndWorkoutCommand with trailing period', () {
      expect(CommandParser.parse('end workout.'), isA<EndWorkoutCommand>());
      expect(CommandParser.parse('finish workout'), isA<EndWorkoutCommand>());
      expect(
        CommandParser.parse('complete workout!'),
        isA<EndWorkoutCommand>(),
      );
    });

    test('parses compound RestTimerCommand with minutes and seconds', () {
      final VoiceCommand result = CommandParser.parse(
        'rest 1 minute 30 seconds',
      );
      expect(result, isA<RestTimerCommand>());
      if (result is RestTimerCommand) {
        expect(result.seconds, 90);
      }
    });

    test('parses simple RestTimerCommand with seconds', () {
      final VoiceCommand result = CommandParser.parse('rest 60s');
      expect(result, isA<RestTimerCommand>());
      if (result is RestTimerCommand) {
        expect(result.seconds, 60);
      }
    });

    test('parses AddExerciseCommand with alias normalization', () {
      final VoiceCommand result = CommandParser.parse('add exercise squats');
      expect(result, isA<AddExerciseCommand>());
      if (result is AddExerciseCommand) {
        expect(result.exerciseName, 'barbell back squat');
      }
    });

    test('parses multi-set LogSetCommand (3 sets 10 reps 80 kilos)', () {
      final VoiceCommand result = CommandParser.parse(
        'log bench 3 sets 10 reps 80 kilos',
      );
      expect(result, isA<LogSetCommand>());
      if (result is LogSetCommand) {
        expect(result.exerciseName, 'barbell bench press');
        expect(result.sets, 3);
        expect(result.reps, 10);
        expect(result.weight, 80.0);
      }
    });

    test('parses comma decimal weights (22,5 kg)', () {
      final VoiceCommand result = CommandParser.parse(
        'dumbbell curl 10 reps at 22,5 kg',
      );
      expect(result, isA<LogSetCommand>());
      if (result is LogSetCommand) {
        expect(result.reps, 10);
        expect(result.weight, 22.5);
      }
    });

    test('parses bodyweight exercise without weight', () {
      final VoiceCommand result = CommandParser.parse('log pull-ups 12 reps');
      expect(result, isA<LogSetCommand>());
      if (result is LogSetCommand) {
        expect(result.exerciseName, 'pull-ups');
        expect(result.reps, 12);
        expect(result.weight, 0.0);
      }
    });

    test('returns UnknownCommand for gibberish', () {
      final VoiceCommand result = CommandParser.parse('tell me a gym joke');
      expect(result, isA<UnknownCommand>());
    });
  });
}
