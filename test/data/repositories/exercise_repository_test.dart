import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/core/utils/result.dart';
import 'package:gym_tracker/data/database/app_database.dart';
import 'package:gym_tracker/data/repositories/exercise_repository.dart';

void main() {
  late AppDatabase db;
  late ExerciseRepository repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = ExerciseRepository(database: db);
  });

  tearDown(() async {
    await db.close();
  });

  group('ExerciseRepository', () {
    test('getAllExercises returns pre-seeded exercises', () async {
      final Result<List<Exercise>> result = await repository.getAllExercises();
      expect(result, isA<Success<List<Exercise>>>());
      final List<Exercise> list = (result as Success<List<Exercise>>).data;
      expect(list, isNotEmpty);
      expect(list.any((Exercise e) => e.name.contains('Bench Press')), isTrue);
    });

    test('searchExercises finds exercises by name or muscle group', () async {
      final Result<List<Exercise>> result = await repository.searchExercises(
        'squat',
      );
      expect(result, isA<Success<List<Exercise>>>());
      final List<Exercise> list = (result as Success<List<Exercise>>).data;
      expect(list, isNotEmpty);
      expect(
        list.every((Exercise e) => e.name.toLowerCase().contains('squat')),
        isTrue,
      );
    });

    test(
      'findExerciseByName finds exact and case-insensitive matches',
      () async {
        final Result<Exercise?> result = await repository.findExerciseByName(
          'barbell bench press',
        );
        expect(result, isA<Success<Exercise?>>());
        final Exercise? ex = (result as Success<Exercise?>).data;
        expect(ex, isNotNull);
        expect(ex?.name, 'Barbell Bench Press');
      },
    );

    test('createCustomExercise saves user-defined exercise', () async {
      final Result<Exercise> result = await repository.createCustomExercise(
        name: 'Cable Lateral Raise',
        muscleGroup: 'Shoulders',
        category: 'Cable',
        instructions: 'Lean slightly away from cable column',
      );

      expect(result, isA<Success<Exercise>>());
      final Exercise custom = (result as Success<Exercise>).data;
      expect(custom.name, 'Cable Lateral Raise');
      expect(custom.isCustom, isTrue);
      expect(custom.id.startsWith('custom_'), isTrue);

      final Result<Exercise?> lookup = await repository.findExerciseByName(
        'Cable Lateral Raise',
      );
      expect((lookup as Success<Exercise?>).data?.id, custom.id);
    });
  });
}
