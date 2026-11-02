import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/result.dart';
import '../../../data/models/models.dart';
import '../../../data/repositories/exercise_repository.dart';
import '../../../data/repositories/workout_repository.dart';
import '../../../voice/command_parser.dart';
import '../../../voice/tts_service.dart';
import '../../../voice/voice_command.dart';
import 'rest_timer_cubit.dart';
import 'workout_event.dart';
import 'workout_state.dart';

/// BLoC managing workout sessions, set logging, and voice control.
class WorkoutBloc extends Bloc<WorkoutEvent, WorkoutState> {
  WorkoutBloc({
    required WorkoutRepository workoutRepository,
    required ExerciseRepository exerciseRepository,
    required TtsService ttsService,
    RestTimerCubit? restTimerCubit,
  }) : _workoutRepo = workoutRepository,
       _exerciseRepo = exerciseRepository,
       _tts = ttsService,
       _restTimer = restTimerCubit,
       super(const WorkoutInitial()) {
    on<CheckActiveWorkout>(_onCheckActiveWorkout);
    on<StartWorkoutEvent>(_onStartWorkout);
    on<FinishWorkoutEvent>(_onFinishWorkout);
    on<LogSetEvent>(_onLogSet);
    on<DeleteSetEvent>(_onDeleteSet);
    on<VoiceCommandReceived>(_onVoiceCommandReceived);
  }

  final WorkoutRepository _workoutRepo;
  final ExerciseRepository _exerciseRepo;
  final TtsService _tts;
  final RestTimerCubit? _restTimer;

  Future<void> _onCheckActiveWorkout(
    CheckActiveWorkout event,
    Emitter<WorkoutState> emit,
  ) async {
    emit(const WorkoutLoading());
    final Result<Workout?> result = await _workoutRepo.getActiveWorkout();
    if (result is Success<Workout?> && result.data != null) {
      await _emitActiveWorkout(result.data!, emit);
    } else {
      emit(const NoActiveWorkout());
    }
  }

  Future<void> _onStartWorkout(
    StartWorkoutEvent event,
    Emitter<WorkoutState> emit,
  ) async {
    emit(const WorkoutLoading());
    final Result<Workout> result = await _workoutRepo.startWorkout(
      title: event.title,
    );
    if (result is Success<Workout>) {
      await _emitActiveWorkout(result.data, emit);
    } else if (result is Failure<Workout>) {
      emit(WorkoutError(result.message));
    }
  }

  Future<void> _onFinishWorkout(
    FinishWorkoutEvent event,
    Emitter<WorkoutState> emit,
  ) async {
    if (state is! ActiveWorkoutState) {
      return;
    }
    final ActiveWorkoutState current = state as ActiveWorkoutState;
    emit(const WorkoutLoading());
    _restTimer?.skipTimer();

    final Result<Workout> result = await _workoutRepo.finishWorkout(
      workoutId: current.workout.id,
      notes: event.notes,
    );

    if (result is Success<Workout>) {
      await _tts.speak('Workout completed! Great effort today.');
      emit(WorkoutCompletedState(result.data));
    } else if (result is Failure<Workout>) {
      emit(WorkoutError(result.message));
    }
  }

  Future<void> _onLogSet(LogSetEvent event, Emitter<WorkoutState> emit) async {
    if (state is! ActiveWorkoutState) {
      return;
    }
    final ActiveWorkoutState current = state as ActiveWorkoutState;

    final Result<WorkoutSet> result = await _workoutRepo.logSet(
      workoutId: current.workout.id,
      exerciseId: event.exerciseId,
      reps: event.reps,
      weight: event.weight,
      rpe: event.rpe,
      restSeconds: event.restSeconds,
    );

    if (result is Success<WorkoutSet>) {
      final List<WorkoutSet> updatedSets = <WorkoutSet>[
        ...current.sets,
        result.data,
      ];
      emit(current.copyWith(sets: updatedSets));
      _restTimer?.startTimer(event.restSeconds);
    } else if (result is Failure<WorkoutSet>) {
      emit(WorkoutError(result.message));
    }
  }

  Future<void> _onDeleteSet(
    DeleteSetEvent event,
    Emitter<WorkoutState> emit,
  ) async {
    if (state is! ActiveWorkoutState) {
      return;
    }
    final ActiveWorkoutState current = state as ActiveWorkoutState;
    final Result<bool> result = await _workoutRepo.deleteWorkoutSet(
      event.setId,
    );
    if (result is Success<bool>) {
      final List<WorkoutSet> remaining = current.sets
          .where((WorkoutSet s) => s.id != event.setId)
          .toList();
      emit(current.copyWith(sets: remaining));
    } else if (result is Failure<bool>) {
      emit(WorkoutError(result.message));
    }
  }

  Future<void> _onVoiceCommandReceived(
    VoiceCommandReceived event,
    Emitter<WorkoutState> emit,
  ) async {
    final VoiceCommand command = CommandParser.parse(event.rawText);

    switch (command) {
      case StartWorkoutCommand(title: final String title):
        add(StartWorkoutEvent(title: title));
        await _tts.speak('Starting $title');

      case EndWorkoutCommand():
        add(const FinishWorkoutEvent());

      case RestTimerCommand(seconds: final int sec):
        _restTimer?.startTimer(sec);
        await _tts.speak('Rest timer set for $sec seconds');

      case LogSetCommand(
        exerciseName: final String name,
        sets: final int sets,
        reps: final int reps,
        weight: final double weight,
      ):
        await _handleVoiceLogSet(name, sets, reps, weight, emit, event.rawText);

      case AddExerciseCommand(exerciseName: final String name):
        await _handleVoiceAddExercise(name, emit, event.rawText);

      case UnknownCommand(rawInput: final String raw):
        if (state is ActiveWorkoutState) {
          emit(
            (state as ActiveWorkoutState).copyWith(
              lastRecognizedText: raw,
              lastVoiceFeedback: 'Could not understand command',
            ),
          );
        }
        await _tts.speak('Sorry, could not understand: $raw');
    }
  }

  Future<void> _handleVoiceLogSet(
    String name,
    int sets,
    int reps,
    double weight,
    Emitter<WorkoutState> emit,
    String rawText,
  ) async {
    final Result<Exercise?> exResult = await _exerciseRepo.findExerciseByName(
      name,
    );
    final Exercise? exercise = exResult.dataOrNull;

    if (exercise == null) {
      if (state is ActiveWorkoutState) {
        emit(
          (state as ActiveWorkoutState).copyWith(
            lastRecognizedText: rawText,
            lastVoiceFeedback: 'Exercise "$name" not found',
          ),
        );
      }
      await _tts.speak('Could not find exercise $name');
      return;
    }

    if (state is! ActiveWorkoutState) {
      final Result<Workout> startRes = await _workoutRepo.startWorkout(
        title: exercise.muscleGroup,
      );
      if (startRes is Success<Workout>) {
        await _emitActiveWorkout(startRes.data, emit);
      } else {
        await _tts.speak('Failed to start workout');
        return;
      }
    }

    // Log the specified number of sets
    for (int i = 0; i < sets; i++) {
      add(LogSetEvent(exerciseId: exercise.id, reps: reps, weight: weight));
    }

    final String feedback = sets > 1
        ? 'Logged $sets sets of ${exercise.name}: $reps reps at $weight kilos'
        : 'Logged ${exercise.name}: $reps reps at $weight kilos';

    if (state is ActiveWorkoutState) {
      emit(
        (state as ActiveWorkoutState).copyWith(
          lastRecognizedText: rawText,
          lastVoiceFeedback: feedback,
        ),
      );
    }
    await _tts.speak(feedback);
  }

  Future<void> _handleVoiceAddExercise(
    String name,
    Emitter<WorkoutState> emit,
    String rawText,
  ) async {
    final Result<Exercise?> exResult = await _exerciseRepo.findExerciseByName(
      name,
    );
    final Exercise? exercise = exResult.dataOrNull;
    if (exercise != null) {
      if (state is ActiveWorkoutState) {
        emit(
          (state as ActiveWorkoutState).copyWith(
            lastRecognizedText: rawText,
            lastVoiceFeedback: 'Added ${exercise.name}',
          ),
        );
      }
      await _tts.speak('Added ${exercise.name} to workout');
    } else {
      await _tts.speak('Exercise $name not found');
    }
  }

  Future<void> _emitActiveWorkout(
    Workout workout,
    Emitter<WorkoutState> emit,
  ) async {
    final Result<List<WorkoutSet>> setsResult = await _workoutRepo
        .getSetsForWorkout(workout.id);
    final Result<List<Exercise>> exercisesResult = await _exerciseRepo
        .getAllExercises();

    final Map<String, Exercise> exerciseMap = <String, Exercise>{};
    if (exercisesResult is Success<List<Exercise>>) {
      for (final Exercise ex in exercisesResult.data) {
        exerciseMap[ex.id] = ex;
      }
    }

    emit(
      ActiveWorkoutState(
        workout: workout,
        sets: setsResult.dataOrNull ?? <WorkoutSet>[],
        exercises: exerciseMap,
      ),
    );
  }
}
