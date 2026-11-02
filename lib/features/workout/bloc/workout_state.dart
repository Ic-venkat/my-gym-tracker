import 'package:equatable/equatable.dart';

import '../../../data/models/models.dart';

/// Base class for all workout states.
sealed class WorkoutState extends Equatable {
  const WorkoutState();

  @override
  List<Object?> get props => <Object?>[];
}

/// Initial uninitialized state.
final class WorkoutInitial extends WorkoutState {
  const WorkoutInitial();
}

/// State when a workout operation is loading.
final class WorkoutLoading extends WorkoutState {
  const WorkoutLoading();
}

/// State when there is no active workout currently running.
final class NoActiveWorkout extends WorkoutState {
  const NoActiveWorkout();
}

/// State when a workout session is actively running.
final class ActiveWorkoutState extends WorkoutState {
  const ActiveWorkoutState({
    required this.workout,
    required this.sets,
    required this.exercises,
    this.lastVoiceFeedback,
    this.lastRecognizedText,
    this.restCountdownSeconds,
    this.restTriggerId = 0,
  });

  final Workout workout;
  final List<WorkoutSet> sets;
  final Map<String, Exercise> exercises;
  final String? lastVoiceFeedback;
  final String? lastRecognizedText;
  final int? restCountdownSeconds;
  final int restTriggerId;

  /// Copies state with optional updated fields.
  ActiveWorkoutState copyWith({
    Workout? workout,
    List<WorkoutSet>? sets,
    Map<String, Exercise>? exercises,
    String? lastVoiceFeedback,
    String? lastRecognizedText,
    int? restCountdownSeconds,
    int? restTriggerId,
  }) {
    return ActiveWorkoutState(
      workout: workout ?? this.workout,
      sets: sets ?? this.sets,
      exercises: exercises ?? this.exercises,
      lastVoiceFeedback: lastVoiceFeedback ?? this.lastVoiceFeedback,
      lastRecognizedText: lastRecognizedText ?? this.lastRecognizedText,
      restCountdownSeconds: restCountdownSeconds ?? this.restCountdownSeconds,
      restTriggerId: restTriggerId ?? this.restTriggerId,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    workout,
    sets,
    exercises,
    lastVoiceFeedback,
    lastRecognizedText,
    restCountdownSeconds,
    restTriggerId,
  ];
}

/// State when workout was just completed.
final class WorkoutCompletedState extends WorkoutState {
  const WorkoutCompletedState(this.workout);

  final Workout workout;

  @override
  List<Object?> get props => <Object?>[workout];
}

/// Error state for workout operations.
final class WorkoutError extends WorkoutState {
  const WorkoutError(this.message);

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
