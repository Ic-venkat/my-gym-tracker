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

/// Helper handling natural language speech commands for [WorkoutBloc].
class WorkoutVoiceHandler {
  const WorkoutVoiceHandler({
    required ExerciseRepository exerciseRepository,
    required WorkoutRepository workoutRepository,
    required TtsService ttsService,
    RestTimerCubit? restTimerCubit,
  }) : _exerciseRepo = exerciseRepository,
       _workoutRepo = workoutRepository,
       _tts = ttsService,
       _restTimer = restTimerCubit;

  final ExerciseRepository _exerciseRepo;
  final WorkoutRepository _workoutRepo;
  final TtsService _tts;
  final RestTimerCubit? _restTimer;

  /// Processes transcribed voice text and triggers appropriate workout actions.
  Future<void> handleVoiceCommand({
    required String rawText,
    required WorkoutState currentState,
    required void Function(WorkoutEvent event) addEvent,
    required void Function(WorkoutState newState) emitState,
  }) async {
    final VoiceCommand command = CommandParser.parse(rawText);

    switch (command) {
      case StartWorkoutCommand(title: final String title):
        addEvent(StartWorkoutEvent(title: title));
        await _tts.speak('Starting $title');

      case EndWorkoutCommand():
        addEvent(const FinishWorkoutEvent());

      case RestTimerCommand(seconds: final int sec):
        _restTimer?.startTimer(sec);
        await _tts.speak('Rest timer set for $sec seconds');

      case LogSetCommand(
        exerciseName: final String name,
        sets: final int sets,
        reps: final int reps,
        weight: final double weight,
      ):
        await _handleLogSet(
          name: name,
          sets: sets,
          reps: reps,
          weight: weight,
          currentState: currentState,
          addEvent: addEvent,
          emitState: emitState,
          rawText: rawText,
        );

      case AddExerciseCommand(exerciseName: final String name):
        await _handleAddExercise(name, currentState, emitState, rawText);

      case UnknownCommand(rawInput: final String raw):
        if (currentState is ActiveWorkoutState) {
          emitState(
            currentState.copyWith(
              lastRecognizedText: raw,
              lastVoiceFeedback: 'Could not understand command',
            ),
          );
        }
        await _tts.speak('Sorry, could not understand: $raw');
    }
  }

  Future<void> _handleLogSet({
    required String name,
    required int sets,
    required int reps,
    required double weight,
    required WorkoutState currentState,
    required void Function(WorkoutEvent event) addEvent,
    required void Function(WorkoutState newState) emitState,
    required String rawText,
  }) async {
    final Result<Exercise?> exResult = await _exerciseRepo.findExerciseByName(
      name,
    );
    final Exercise? exercise = exResult.dataOrNull;

    if (exercise == null) {
      if (currentState is ActiveWorkoutState) {
        emitState(
          currentState.copyWith(
            lastRecognizedText: rawText,
            lastVoiceFeedback: 'Exercise "$name" not found',
          ),
        );
      }
      await _tts.speak('Could not find exercise $name');
      return;
    }

    if (currentState is! ActiveWorkoutState) {
      final Result<Workout> startRes = await _workoutRepo.startWorkout(
        title: exercise.muscleGroup,
      );
      if (startRes is Success<Workout>) {
        final Result<List<Exercise>> allEx = await _exerciseRepo
            .getAllExercises();
        final Map<String, Exercise> exMap = <String, Exercise>{};
        if (allEx is Success<List<Exercise>>) {
          for (final Exercise e in allEx.data) {
            exMap[e.id] = e;
          }
        }
        emitState(
          ActiveWorkoutState(
            workout: startRes.data,
            sets: const <WorkoutSet>[],
            exercises: exMap,
          ),
        );
      } else {
        await _tts.speak('Failed to start workout');
        return;
      }
    }

    for (int i = 0; i < sets; i++) {
      addEvent(
        LogSetEvent(exerciseId: exercise.id, reps: reps, weight: weight),
      );
    }

    final String feedback = sets > 1
        ? 'Logged $sets sets of ${exercise.name}: $reps reps at $weight kilos'
        : 'Logged ${exercise.name}: $reps reps at $weight kilos';

    if (currentState is ActiveWorkoutState) {
      emitState(
        currentState.copyWith(
          lastRecognizedText: rawText,
          lastVoiceFeedback: feedback,
        ),
      );
    }
    await _tts.speak(feedback);
  }

  Future<void> _handleAddExercise(
    String name,
    WorkoutState currentState,
    void Function(WorkoutState newState) emitState,
    String rawText,
  ) async {
    final Result<Exercise?> exResult = await _exerciseRepo.findExerciseByName(
      name,
    );
    final Exercise? exercise = exResult.dataOrNull;
    if (exercise != null) {
      if (currentState is ActiveWorkoutState) {
        emitState(
          currentState.copyWith(
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
}
