import 'package:bloc_test/bloc_test.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/data/database/app_database.dart';
import 'package:gym_tracker/data/repositories/exercise_repository.dart';
import 'package:gym_tracker/features/exercises/bloc/exercises_bloc.dart';
import 'package:gym_tracker/features/exercises/bloc/exercises_event.dart';
import 'package:gym_tracker/features/exercises/bloc/exercises_state.dart';

void main() {
  late AppDatabase db;
  late ExerciseRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = ExerciseRepository(database: db);
  });

  tearDown(() async {
    await db.close();
  });

  group('ExercisesBloc', () {
    blocTest<ExercisesBloc, ExercisesState>(
      'emits [ExercisesLoading, ExercisesLoaded] on LoadExercises',
      build: () => ExercisesBloc(exerciseRepository: repo),
      act: (ExercisesBloc bloc) => bloc.add(const LoadExercises()),
      expect: () => <Matcher>[
        isA<ExercisesLoading>(),
        isA<ExercisesLoaded>().having(
          (ExercisesLoaded s) => s.exercises.isNotEmpty,
          'isNotEmpty',
          isTrue,
        ),
      ],
    );

    blocTest<ExercisesBloc, ExercisesState>(
      'filters by category when specified',
      build: () => ExercisesBloc(exerciseRepository: repo),
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
  });
}
