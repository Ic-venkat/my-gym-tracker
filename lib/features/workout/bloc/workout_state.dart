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
    this.remainingRestSeconds = 0,
    this.isRestTimerActive = false,
    this.lastVoiceFeedback,
    this.lastRecognizedText,
  });

  final Workout workout;
  final List<WorkoutSet> sets;
  final Map<String, Exercise> exercises;
  final int remainingRestSeconds;
  final bool isRestTimerActive;
  final String? lastVoiceFeedback;
  final String? lastRecognizedText;

  /// Copies state with optional updated fields.
  ActiveWorkoutState copyWith({
    Workout? workout,
    List<WorkoutSet>? sets,
    Map<String, Exercise>? exercises,
    int? remainingRestSeconds,
    bool? isRestTimerActive,
    String? lastVoiceFeedback,
    String? lastRecognizedText,
  }) {
    return ActiveWorkoutState(
      workout: workout ?? this.workout,
      sets: sets ?? this.sets,
      exercises: exercises ?? this.exercises,
      remainingRestSeconds: remainingRestSeconds ?? this.remainingRestSeconds,
      isRestTimerActive: isRestTimerActive ?? this.isRestTimerActive,
      lastVoiceFeedback: lastVoiceFeedback ?? this.lastVoiceFeedback,
      lastRecognizedText: lastRecognizedText ?? this.lastRecognizedText,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    workout,
    sets,
    exercises,
    remainingRestSeconds,
    isRestTimerActive,
    lastVoiceFeedback,
    lastRecognizedText,
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
