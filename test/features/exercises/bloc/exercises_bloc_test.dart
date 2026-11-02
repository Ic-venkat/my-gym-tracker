import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/core/utils/result.dart';
import 'package:gym_tracker/data/models/models.dart';
import 'package:gym_tracker/data/repositories/exercise_repository.dart';
import 'package:gym_tracker/features/exercises/bloc/exercises_bloc.dart';
import 'package:gym_tracker/features/exercises/bloc/exercises_event.dart';
import 'package:gym_tracker/features/exercises/bloc/exercises_state.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/test_factories.dart';

class MockExerciseRepository extends Mock implements ExerciseRepository {}

void main() {
  late MockExerciseRepository mockRepo;

  final List<Exercise> sampleExercises = <Exercise>[
    createTestExercise(id: 'ex_1'),
    createTestExercise(
      id: 'ex_2',
      name: 'Barbell Back Squat',
      muscleGroup: 'Legs',
    ),
  ];

  setUp(() {
    mockRepo = MockExerciseRepository();
  });

  group('ExercisesBloc', () {
    blocTest<ExercisesBloc, ExercisesState>(
      'emits [ExercisesLoading, ExercisesLoaded] on LoadExercises',
      build: () {
        when(() => mockRepo.getAllExercises())
            .thenAnswer((_) async => Success<List<Exercise>>(sampleExercises));
        return ExercisesBloc(exerciseRepository: mockRepo);
      },
      act: (ExercisesBloc bloc) => bloc.add(const LoadExercises()),
      expect: () => <Matcher>[
        isA<ExercisesLoading>(),
        isA<ExercisesLoaded>().having(
          (ExercisesLoaded s) => s.exercises.length,
          'length',
          2,
        ),
      ],
    );

    blocTest<ExercisesBloc, ExercisesState>(
      'filters by category when specified',
      build: () {
        when(() => mockRepo.getAllExercises())
            .thenAnswer((_) async => Success<List<Exercise>>(sampleExercises));
        return ExercisesBloc(exerciseRepository: mockRepo);
      },
      act: (ExercisesBloc bloc) =>
          bloc.add(const LoadExercises(category: 'Chest')),
      expect: () => <Matcher>[
        isA<ExercisesLoading>(),
        isA<ExercisesLoaded>().having(
          (ExercisesLoaded s) =>
              s.exercises.every((Exercise e) => e.muscleGroup == 'Chest'),
          'all chest',
          isTrue,
        ),
      ],
    );

    blocTest<ExercisesBloc, ExercisesState>(
      'emits ExercisesError when repository fails',
      build: () {
        when(() => mockRepo.getAllExercises()).thenAnswer(
          (_) async => const Failure<List<Exercise>>('Database corrupt'),
        );
        return ExercisesBloc(exerciseRepository: mockRepo);
      },
      act: (ExercisesBloc bloc) => bloc.add(const LoadExercises()),
      expect: () => <Matcher>[
        isA<ExercisesLoading>(),
        isA<ExercisesError>().having(
          (ExercisesError s) => s.message,
          'message',
          'Database corrupt',
        ),
      ],
    );
  });
}
