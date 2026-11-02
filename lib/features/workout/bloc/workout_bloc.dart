import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/result.dart';
import '../../../data/models/models.dart';
import '../../../data/repositories/exercise_repository.dart';
import '../../../data/repositories/workout_repository.dart';
import '../../../voice/tts_service.dart';
import 'workout_event.dart';
import 'workout_state.dart';
import 'workout_voice_handler.dart';

/// BLoC managing workout sessions, set logging, and voice control.
class WorkoutBloc extends Bloc<WorkoutEvent, WorkoutState> {
  WorkoutBloc({
    required WorkoutRepository workoutRepository,
    required ExerciseRepository exerciseRepository,
    required TtsService ttsService,
  }) : _workoutRepo = workoutRepository,
       _exerciseRepo = exerciseRepository,
       _tts = ttsService,
       _voiceHandler = WorkoutVoiceHandler(
         exerciseRepository: exerciseRepository,
         workoutRepository: workoutRepository,
         ttsService: ttsService,
       ),
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
  final WorkoutVoiceHandler _voiceHandler;

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

    final Result<Workout> result = await _workoutRepo.finishWorkout(
      workoutId: current.workout.id,
      notes: event.notes,
    );

    if (result is Success<Workout>) {
      await _tts.speak('Workout completed! Great effort today.');
      emit(WorkoutCompletedState(result.data));
    } else if (result is Failure<Workout>) {
      emit(current.copyWith(errorMessage: result.message));
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
      emit(
        current.copyWith(
          sets: updatedSets,
          restCountdownSeconds: event.restSeconds,
          restTriggerId: current.restTriggerId + 1,
          errorMessage: null,
        ),
      );
    } else if (result is Failure<WorkoutSet>) {
      emit(current.copyWith(errorMessage: result.message));
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
      emit(current.copyWith(sets: remaining, errorMessage: null));
    } else if (result is Failure<bool>) {
      emit(current.copyWith(errorMessage: result.message));
    }
  }

  Future<void> _onVoiceCommandReceived(
    VoiceCommandReceived event,
    Emitter<WorkoutState> emit,
  ) async {
    await _voiceHandler.handleVoiceCommand(
      rawText: event.rawText,
      currentState: state,
      addEvent: add,
      emitState: (WorkoutState s) => emit(s),
    );
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
