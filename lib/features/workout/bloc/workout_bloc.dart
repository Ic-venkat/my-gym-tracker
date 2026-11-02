import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/result.dart';
import '../../../data/database/app_database.dart';
import '../../../data/repositories/exercise_repository.dart';
import '../../../data/repositories/workout_repository.dart';
import '../../../voice/command_parser.dart';
import '../../../voice/tts_service.dart';
import '../../../voice/voice_command.dart';
import 'workout_event.dart';
import 'workout_state.dart';

/// BLoC managing workout sessions, set logging, voice control, and rest timer.
class WorkoutBloc extends Bloc<WorkoutEvent, WorkoutState> {
  WorkoutBloc({
    required WorkoutRepository workoutRepository,
    required ExerciseRepository exerciseRepository,
    required TtsService ttsService,
  }) : _workoutRepo = workoutRepository,
       _exerciseRepo = exerciseRepository,
       _tts = ttsService,
       super(const WorkoutInitial()) {
    on<CheckActiveWorkout>(_onCheckActiveWorkout);
    on<StartWorkoutEvent>(_onStartWorkout);
    on<FinishWorkoutEvent>(_onFinishWorkout);
    on<LogSetEvent>(_onLogSet);
    on<DeleteSetEvent>(_onDeleteSet);
    on<TriggerRestTimer>(_onTriggerRestTimer);
    on<RestTimerTicked>(_onRestTimerTicked);
    on<VoiceCommandReceived>(_onVoiceCommandReceived);
  }

  final WorkoutRepository _workoutRepo;
  final ExerciseRepository _exerciseRepo;
  final TtsService _tts;
  Timer? _restTimer;

  @override
  Future<void> close() {
    _restTimer?.cancel();
    return super.close();
  }

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
    _restTimer?.cancel();

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
      add(TriggerRestTimer(event.restSeconds));
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
    await _workoutRepo.deleteWorkoutSet(event.setId);
    final List<WorkoutSet> remaining = current.sets
        .where((WorkoutSet s) => s.id != event.setId)
        .toList();
    emit(current.copyWith(sets: remaining));
  }

  void _onTriggerRestTimer(TriggerRestTimer event, Emitter<WorkoutState> emit) {
    if (state is! ActiveWorkoutState) {
      return;
    }
    final ActiveWorkoutState current = state as ActiveWorkoutState;
    _restTimer?.cancel();

    emit(
      current.copyWith(
        remainingRestSeconds: event.seconds,
        isRestTimerActive: true,
      ),
    );

    int count = event.seconds;
    _restTimer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      count--;
      if (count <= 0) {
        t.cancel();
        _tts.speak('Rest time is up! Ready for next set.');
        add(const RestTimerTicked(0));
      } else {
        add(RestTimerTicked(count));
      }
    });
  }

  void _onRestTimerTicked(RestTimerTicked event, Emitter<WorkoutState> emit) {
    if (state is! ActiveWorkoutState) {
      return;
    }
    final ActiveWorkoutState current = state as ActiveWorkoutState;
    emit(
      current.copyWith(
        remainingRestSeconds: event.remainingSeconds,
        isRestTimerActive: event.remainingSeconds > 0,
      ),
    );
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
        add(TriggerRestTimer(sec));
        await _tts.speak('Rest timer set for $sec seconds');

      case LogSetCommand(
        exerciseName: final String name,
        reps: final int reps,
        weight: final double weight,
      ):
        await _handleVoiceLogSet(name, reps, weight, emit);

      case AddExerciseCommand(exerciseName: final String name):
        await _handleVoiceAddExercise(name);

      case UnknownCommand(rawInput: final String raw):
        await _tts.speak('Sorry, could not understand: $raw');
    }
  }

  Future<void> _handleVoiceLogSet(
    String name,
    int reps,
    double weight,
    Emitter<WorkoutState> emit,
  ) async {
    final Result<Exercise?> exResult = await _exerciseRepo.findExerciseByName(
      name,
    );
    final Exercise? exercise = exResult.dataOrNull;

    if (exercise != null) {
      if (state is! ActiveWorkoutState) {
        add(StartWorkoutEvent(title: exercise.muscleGroup));
        await Future<void>.delayed(const Duration(milliseconds: 300));
      }
      add(LogSetEvent(exerciseId: exercise.id, reps: reps, weight: weight));
      await _tts.speak('Logged ${exercise.name}: $reps reps at $weight kilos');
    } else {
      await _tts.speak('Could not find exercise $name');
    }
  }

  Future<void> _handleVoiceAddExercise(String name) async {
    final Result<Exercise?> exResult = await _exerciseRepo.findExerciseByName(
      name,
    );
    final Exercise? exercise = exResult.dataOrNull;
    if (exercise != null) {
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
