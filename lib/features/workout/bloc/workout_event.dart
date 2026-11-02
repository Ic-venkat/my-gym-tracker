import 'package:equatable/equatable.dart';

/// Base class for all workout events.
sealed class WorkoutEvent extends Equatable {
  const WorkoutEvent();

  @override
  List<Object?> get props => <Object?>[];
}

/// Event to check for existing uncompleted workout on app launch.
final class CheckActiveWorkout extends WorkoutEvent {
  const CheckActiveWorkout();
}

/// Event to start a new workout session.
final class StartWorkoutEvent extends WorkoutEvent {
  const StartWorkoutEvent({this.title = 'Workout'});

  final String title;

  @override
  List<Object?> get props => <Object?>[title];
}

/// Event to finish and save current workout.
final class FinishWorkoutEvent extends WorkoutEvent {
  const FinishWorkoutEvent({this.notes});

  final String? notes;

  @override
  List<Object?> get props => <Object?>[notes];
}

/// Event to log a single exercise set.
final class LogSetEvent extends WorkoutEvent {
  const LogSetEvent({
    required this.exerciseId,
    required this.reps,
    required this.weight,
    this.rpe,
    this.restSeconds = 90,
  });

  final String exerciseId;
  final int reps;
  final double weight;
  final double? rpe;
  final int restSeconds;

  @override
  List<Object?> get props => <Object?>[
    exerciseId,
    reps,
    weight,
    rpe,
    restSeconds,
  ];
}

/// Event to delete an existing set.
final class DeleteSetEvent extends WorkoutEvent {
  const DeleteSetEvent(this.setId);

  final String setId;

  @override
  List<Object?> get props => <Object?>[setId];
}

/// Event fired when a voice command is transcribed.
final class VoiceCommandReceived extends WorkoutEvent {
  const VoiceCommandReceived(this.rawText);

  final String rawText;

  @override
  List<Object?> get props => <Object?>[rawText];
}

/// Event to start or update a rest timer.
final class TriggerRestTimer extends WorkoutEvent {
  const TriggerRestTimer(this.seconds);

  final int seconds;

  @override
  List<Object?> get props => <Object?>[seconds];
}

/// Internal event triggered every second to tick rest timer.
final class RestTimerTicked extends WorkoutEvent {
  const RestTimerTicked(this.remainingSeconds);

  final int remainingSeconds;

  @override
  List<Object?> get props => <Object?>[remainingSeconds];
}
