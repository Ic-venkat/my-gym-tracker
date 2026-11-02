import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/core/utils/result.dart';
import 'package:gym_tracker/data/models/models.dart';
import 'package:gym_tracker/data/repositories/exercise_repository.dart';
import 'package:gym_tracker/data/repositories/workout_repository.dart';
import 'package:gym_tracker/features/workout/bloc/workout_bloc.dart';
import 'package:gym_tracker/features/workout/bloc/workout_event.dart';
import 'package:gym_tracker/features/workout/bloc/workout_state.dart';
import 'package:gym_tracker/voice/tts_service.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/test_factories.dart';

class MockWorkoutRepository extends Mock implements WorkoutRepository {}

class MockExerciseRepository extends Mock implements ExerciseRepository {}

class MockTtsService extends Mock implements TtsService {}

void main() {
  late MockWorkoutRepository mockWorkoutRepo;
  late MockExerciseRepository mockExerciseRepo;
  late MockTtsService mockTts;

  final Workout sampleWorkout = Workout(
    id: 'w_1',
    title: 'Push Day',
    startedAt: DateTime.now(),
    totalVolume: 0,
    durationSeconds: 0,
  );

  final Exercise sampleExercise = createTestExercise();

  final WorkoutSet sampleSet = WorkoutSet(
    id: 's_1',
    workoutId: 'w_1',
    exerciseId: 'ex_bench',
    setNumber: 1,
    reps: 10,
    weight: 80.0,
    isCompleted: true,
    restSeconds: 90,
    createdAt: DateTime.now(),
  );

  setUp(() {
    mockWorkoutRepo = MockWorkoutRepository();
    mockExerciseRepo = MockExerciseRepository();
    mockTts = MockTtsService();

    when(() => mockTts.speak(any())).thenAnswer((_) async {});
  });

  group('WorkoutBloc', () {
    blocTest<WorkoutBloc, WorkoutState>(
      'emits [WorkoutLoading, NoActiveWorkout] when no active workout exists',
      build: () {
        when(() => mockWorkoutRepo.getActiveWorkout())
            .thenAnswer((_) async => const Success<Workout?>(null));
        return WorkoutBloc(
          workoutRepository: mockWorkoutRepo,
          exerciseRepository: mockExerciseRepo,
          ttsService: mockTts,
        );
      },
      act: (WorkoutBloc bloc) => bloc.add(const CheckActiveWorkout()),
      expect: () => <Matcher>[isA<WorkoutLoading>(), isA<NoActiveWorkout>()],
    );

    blocTest<WorkoutBloc, WorkoutState>(
      'starts a new workout and emits [WorkoutLoading, ActiveWorkoutState]',
      build: () {
        when(() => mockWorkoutRepo.startWorkout(title: any(named: 'title')))
            .thenAnswer((_) async => Success<Workout>(sampleWorkout));
        when(() => mockWorkoutRepo.getSetsForWorkout(sampleWorkout.id))
            .thenAnswer(
              (_) async => const Success<List<WorkoutSet>>(<WorkoutSet>[]),
            );
        when(() => mockExerciseRepo.getAllExercises()).thenAnswer(
          (_) async => Success<List<Exercise>>(<Exercise>[sampleExercise]),
        );
        return WorkoutBloc(
          workoutRepository: mockWorkoutRepo,
          exerciseRepository: mockExerciseRepo,
          ttsService: mockTts,
        );
      },
      act: (WorkoutBloc bloc) =>
          bloc.add(const StartWorkoutEvent(title: 'Push Day')),
      expect: () => <Matcher>[
        isA<WorkoutLoading>(),
        isA<ActiveWorkoutState>().having(
          (ActiveWorkoutState s) => s.workout.title,
          'title',
          'Push Day',
        ),
      ],
    );

    blocTest<WorkoutBloc, WorkoutState>(
      'emits WorkoutError when startWorkout fails',
      build: () {
        when(() => mockWorkoutRepo.startWorkout(title: any(named: 'title')))
            .thenAnswer((_) async => const Failure<Workout>('DB Disk Full'));
        return WorkoutBloc(
          workoutRepository: mockWorkoutRepo,
          exerciseRepository: mockExerciseRepo,
          ttsService: mockTts,
        );
      },
      act: (WorkoutBloc bloc) =>
          bloc.add(const StartWorkoutEvent(title: 'Push Day')),
      expect: () => <Matcher>[
        isA<WorkoutLoading>(),
        isA<WorkoutError>().having(
          (WorkoutError s) => s.message,
          'message',
          'DB Disk Full',
        ),
      ],
    );

    blocTest<WorkoutBloc, WorkoutState>(
      'logs set successfully into active workout',
      build: () {
        when(
          () => mockWorkoutRepo.logSet(
            workoutId: sampleWorkout.id,
            exerciseId: sampleExercise.id,
            reps: 10,
            weight: 80.0,
            rpe: any(named: 'rpe'),
          ),
        ).thenAnswer((_) async => Success<WorkoutSet>(sampleSet));
        return WorkoutBloc(
          workoutRepository: mockWorkoutRepo,
          exerciseRepository: mockExerciseRepo,
          ttsService: mockTts,
        );
      },
      seed: () => ActiveWorkoutState(
        workout: sampleWorkout,
        sets: const <WorkoutSet>[],
        exercises: <String, Exercise>{sampleExercise.id: sampleExercise},
      ),
      act: (WorkoutBloc bloc) => bloc.add(
        LogSetEvent(exerciseId: sampleExercise.id, reps: 10, weight: 80.0),
      ),
      expect: () => <Matcher>[
        isA<ActiveWorkoutState>().having(
          (ActiveWorkoutState s) => s.sets.length,
          'sets length',
          1,
        ),
      ],
    );

    blocTest<WorkoutBloc, WorkoutState>(
      'deletes set when DeleteSetEvent is triggered',
      build: () {
        when(() => mockWorkoutRepo.deleteWorkoutSet(sampleSet.id))
            .thenAnswer((_) async => const Success<bool>(true));
        return WorkoutBloc(
          workoutRepository: mockWorkoutRepo,
          exerciseRepository: mockExerciseRepo,
          ttsService: mockTts,
        );
      },
      seed: () => ActiveWorkoutState(
        workout: sampleWorkout,
        sets: <WorkoutSet>[sampleSet],
        exercises: <String, Exercise>{sampleExercise.id: sampleExercise},
      ),
      act: (WorkoutBloc bloc) => bloc.add(DeleteSetEvent(sampleSet.id)),
      expect: () => <Matcher>[
        isA<ActiveWorkoutState>().having(
          (ActiveWorkoutState s) => s.sets,
          'sets empty',
          isEmpty,
        ),
      ],
    );

    blocTest<WorkoutBloc, WorkoutState>(
      'retains ActiveWorkoutState with errorMessage when logSet fails',
      build: () {
        when(
          () => mockWorkoutRepo.logSet(
            workoutId: sampleWorkout.id,
            exerciseId: sampleExercise.id,
            reps: 10,
            weight: 80.0,
            rpe: any(named: 'rpe'),
          ),
        ).thenAnswer(
          (_) async => const Failure<WorkoutSet>('Database constraint failure'),
        );
        return WorkoutBloc(
          workoutRepository: mockWorkoutRepo,
          exerciseRepository: mockExerciseRepo,
          ttsService: mockTts,
        );
      },
      seed: () => ActiveWorkoutState(
        workout: sampleWorkout,
        sets: const <WorkoutSet>[],
        exercises: <String, Exercise>{sampleExercise.id: sampleExercise},
      ),
      act: (WorkoutBloc bloc) => bloc.add(
        LogSetEvent(exerciseId: sampleExercise.id, reps: 10, weight: 80.0),
      ),
      expect: () => <Matcher>[
        isA<ActiveWorkoutState>().having(
          (ActiveWorkoutState s) => s.errorMessage,
          'errorMessage',
          'Database constraint failure',
        ),
      ],
    );

    blocTest<WorkoutBloc, WorkoutState>(
      'finishes workout and emits WorkoutCompletedState',
      build: () {
        when(
          () => mockWorkoutRepo.finishWorkout(
            workoutId: sampleWorkout.id,
            notes: any(named: 'notes'),
          ),
        ).thenAnswer((_) async => Success<Workout>(sampleWorkout));
        return WorkoutBloc(
          workoutRepository: mockWorkoutRepo,
          exerciseRepository: mockExerciseRepo,
          ttsService: mockTts,
        );
      },
      seed: () => ActiveWorkoutState(
        workout: sampleWorkout,
        sets: <WorkoutSet>[sampleSet],
        exercises: <String, Exercise>{sampleExercise.id: sampleExercise},
      ),
      act: (WorkoutBloc bloc) => bloc.add(const FinishWorkoutEvent()),
      expect: () => <Matcher>[isA<WorkoutCompletedState>()],
    );
  });
}
