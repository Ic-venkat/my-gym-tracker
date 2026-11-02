/// Sealed hierarchy representing all voice commands understood by GymTracker.
sealed class VoiceCommand {
  const VoiceCommand();
}

/// Command to log an exercise set.
/// Example: "Log bench press 3 sets 10 reps 80 kilos"
final class LogSetCommand extends VoiceCommand {
  const LogSetCommand({
    required this.exerciseName,
    required this.reps,
    required this.weight,
    this.sets = 1,
    this.unit = 'kg',
  });

  final String exerciseName;
  final int reps;
  final double weight;
  final int sets;
  final String unit;

  @override
  String toString() =>
      'LogSetCommand($exerciseName, $sets sets of $reps reps @ $weight$unit)';
}

/// Command to start a workout session.
/// Example: "Start workout" or "Start chest day"
final class StartWorkoutCommand extends VoiceCommand {
  const StartWorkoutCommand({this.title = 'Workout'});

  final String title;
}

/// Command to end/finish the current workout.
/// Example: "End workout" or "Finish workout"
final class EndWorkoutCommand extends VoiceCommand {
  const EndWorkoutCommand();
}

/// Command to trigger a rest timer.
/// Example: "Rest 90 seconds" or "Timer 2 minutes"
final class RestTimerCommand extends VoiceCommand {
  const RestTimerCommand({required this.seconds});

  final int seconds;
}

/// Command to add an exercise to current workout.
/// Example: "Add exercise squat"
final class AddExerciseCommand extends VoiceCommand {
  const AddExerciseCommand({required this.exerciseName});

  final String exerciseName;
}

/// Fallback for unrecognized voice input.
final class UnknownCommand extends VoiceCommand {
  const UnknownCommand(this.rawInput);

  final String rawInput;
}

