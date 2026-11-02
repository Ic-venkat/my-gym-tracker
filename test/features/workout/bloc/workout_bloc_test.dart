import 'package:bloc_test/bloc_test.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/data/database/app_database.dart';
import 'package:gym_tracker/data/repositories/exercise_repository.dart';
import 'package:gym_tracker/data/repositories/workout_repository.dart';
import 'package:gym_tracker/features/workout/bloc/workout_bloc.dart';
import 'package:gym_tracker/features/workout/bloc/workout_event.dart';
import 'package:gym_tracker/features/workout/bloc/workout_state.dart';
import 'package:gym_tracker/voice/tts_service.dart';
import 'package:mocktail/mocktail.dart';

class MockTtsService extends Mock implements TtsService {}

void main() {
  late AppDatabase db;
  late ExerciseRepository exerciseRepo;
  late WorkoutRepository workoutRepo;
  late MockTtsService mockTts;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    exerciseRepo = ExerciseRepository(database: db);
    workoutRepo = WorkoutRepository(database: db);
    mockTts = MockTtsService();
    when(() => mockTts.speak(any())).thenAnswer((_) async {});
  });

  tearDown(() async {
    await db.close();
  });

  group('WorkoutBloc', () {
    blocTest<WorkoutBloc, WorkoutState>(
      'emits [WorkoutLoading, NoActiveWorkout] when no active workout exists',
      build: () => WorkoutBloc(
        workoutRepository: workoutRepo,
        exerciseRepository: exerciseRepo,
        ttsService: mockTts,
      ),
      act: (WorkoutBloc bloc) => bloc.add(const CheckActiveWorkout()),
      expect: () => <Matcher>[isA<WorkoutLoading>(), isA<NoActiveWorkout>()],
    );

    blocTest<WorkoutBloc, WorkoutState>(
      'starts a new workout and emits [WorkoutLoading, ActiveWorkoutState]',
      build: () => WorkoutBloc(
        workoutRepository: workoutRepo,
        exerciseRepository: exerciseRepo,
        ttsService: mockTts,
      ),
      act: (WorkoutBloc bloc) =>
          bloc.add(const StartWorkoutEvent(title: 'Chest & Arms')),
      expect: () => <Matcher>[
        isA<WorkoutLoading>(),
        isA<ActiveWorkoutState>().having(
          (ActiveWorkoutState s) => s.workout.title,
          'title',
          'Chest & Arms',
        ),
      ],
    );

    blocTest<WorkoutBloc, WorkoutState>(
      'handles voice command to start workout',
      build: () => WorkoutBloc(
        workoutRepository: workoutRepo,
        exerciseRepository: exerciseRepo,
        ttsService: mockTts,
      ),
      act: (WorkoutBloc bloc) =>
          bloc.add(const VoiceCommandReceived('start workout legs')),
      expect: () => <Matcher>[
        isA<WorkoutLoading>(),
        isA<ActiveWorkoutState>().having(
          (ActiveWorkoutState s) => s.workout.title,
          'title',
          'Legs',
        ),
      ],
      verify: (_) {
        verify(() => mockTts.speak('Starting Legs')).called(1);
      },
    );
  });
}
