import '../../../core/utils/result.dart';
import '../../../data/models/models.dart';
import '../../../data/repositories/exercise_repository.dart';
import '../../../data/repositories/workout_repository.dart';
import '../../../voice/command_parser.dart';
import '../../../voice/tts_service.dart';
import '../../../voice/voice_command.dart';
import 'workout_event.dart';
import 'workout_state.dart';

/// Helper handling natural language speech commands for [WorkoutBloc].
class WorkoutVoiceHandler {
  const WorkoutVoiceHandler({
    required ExerciseRepository exerciseRepository,
    required WorkoutRepository workoutRepository,
    required TtsService ttsService,
  }) : _exerciseRepo = exerciseRepository,
       _workoutRepo = workoutRepository,
       _tts = ttsService;

  final ExerciseRepository _exerciseRepo;
  final WorkoutRepository _workoutRepo;
  final TtsService _tts;

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
        if (currentState is ActiveWorkoutState) {
          emitState(
            currentState.copyWith(
              restCountdownSeconds: sec,
              restTriggerId: currentState.restTriggerId + 1,
              lastVoiceFeedback: 'Rest timer set for $sec seconds',
              lastRecognizedText: rawText,
            ),
          );
          await _tts.speak('Rest timer set for $sec seconds');
        } else {
          await _tts.speak('No active workout running');
        }

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

    final int safeSets = sets.clamp(1, 20);
    final int safeReps = reps.clamp(1, 500);
    final double safeWeight = weight.clamp(0.0, 1000.0);

    for (int i = 0; i < safeSets; i++) {
      addEvent(
        LogSetEvent(
          exerciseId: exercise.id,
          reps: safeReps,
          weight: safeWeight,
        ),
      );
    }

    final String feedback = safeSets > 1
        ? 'Logged $safeSets sets of ${exercise.name}: $safeReps reps at $safeWeight kilos'
        : 'Logged ${exercise.name}: $safeReps reps at $safeWeight kilos';

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
