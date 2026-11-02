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

    test(
      'createCustomExercise saves user-defined exercise with enriched metadata',
      () async {
        final Result<Exercise> result = await repository.createCustomExercise(
          name: 'Cable Lateral Raise',
          muscleGroup: 'Shoulders',
          category: 'Cable',
          instructions: 'Lean slightly away from cable column',
          secondaryMuscles: 'Trapezius, Forearms',
          movementPattern: 'isolation',
          mechanics: 'isolation',
          equipment: 'cable',
          difficulty: 'intermediate',
          youtubeVideoId: 'dQw4w9WgXcQ',
          formCues: 'Keep elbows high',
          commonMistakes: 'Shrugging traps',
          defaultRestSeconds: 75,
          targetRepRange: '12-15',
          minIncrementKg: 1.25,
        );

        expect(result, isA<Success<Exercise>>());
        final Exercise custom = (result as Success<Exercise>).data;
        expect(custom.name, 'Cable Lateral Raise');
        expect(custom.isCustom, isTrue);
        expect(custom.id.startsWith('custom_'), isTrue);
        expect(custom.secondaryMuscles, 'Trapezius, Forearms');
        expect(custom.movementPattern, 'isolation');
        expect(custom.mechanics, 'isolation');
        expect(custom.equipment, 'cable');
        expect(custom.difficulty, 'intermediate');
        expect(custom.youtubeVideoId, 'dQw4w9WgXcQ');
        expect(custom.formCues, 'Keep elbows high');
        expect(custom.commonMistakes, 'Shrugging traps');
        expect(custom.defaultRestSeconds, 75);
        expect(custom.targetRepRange, '12-15');
        expect(custom.minIncrementKg, 1.25);

        final Result<Exercise?> lookup = await repository.findExerciseByName(
          'Cable Lateral Raise',
        );
        expect((lookup as Success<Exercise?>).data?.id, custom.id);
      },
    );
  });
}
