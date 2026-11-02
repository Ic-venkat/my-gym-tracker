import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/data/database/app_database.dart';

void main() {
  late AppDatabase db;

  setUpAll(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  });

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('AppDatabase', () {
    test('seeds default exercises on creation', () async {
      final List<Exercise> exercises = await db.getAllExercises();
      expect(exercises, isNotEmpty);
      expect(
        exercises.any((Exercise e) => e.name == 'Barbell Bench Press'),
        isTrue,
      );
    });

    test(
      'can insert and retrieve a workout session by ID and active state',
      () async {
        final Workout workout = Workout(
          id: 'w_test_1',
          title: 'Push Day',
          startedAt: DateTime.now(),
          totalVolume: 0,
          durationSeconds: 0,
        );

        await db.insertWorkout(workout);
        final Workout? active = await db.getActiveWorkout();

        expect(active, isNotNull);
        expect(active!.id, 'w_test_1');
        expect(active.title, 'Push Day');

        final Workout? byId = await db.getWorkoutById('w_test_1');
        expect(byId?.id, 'w_test_1');
      },
    );

    test('can insert workout set, fetch for workout, and delete set', () async {
      final Workout workout = Workout(
        id: 'w_test_sets',
        title: 'Leg Day',
        startedAt: DateTime.now(),
        totalVolume: 0,
        durationSeconds: 0,
      );
      await db.insertWorkout(workout);

      final WorkoutSet set = WorkoutSet(
        id: 's_test_1',
        workoutId: 'w_test_sets',
        exerciseId: 'ex_squat',
        setNumber: 1,
        reps: 8,
        weight: 120.0,
        isCompleted: true,
        restSeconds: 90,
        createdAt: DateTime.now(),
      );
      await db.insertWorkoutSet(set);

      final List<WorkoutSet> sets = await db.getSetsForWorkout('w_test_sets');
      expect(sets.length, 1);
      expect(sets.first.reps, 8);
      expect(sets.first.weight, 120.0);

      await db.deleteWorkoutSet('s_test_1');
      final List<WorkoutSet> remaining = await db.getSetsForWorkout(
        'w_test_sets',
      );
      expect(remaining, isEmpty);
    });

    test('findExerciseByName matches exact and fuzzy SQL search', () async {
      final Exercise? exact = await db.findExerciseByName(
        'barbell bench press',
      );
      expect(exact, isNotNull);
      expect(exact?.id, 'ex_bench_press');

      final Exercise? partial = await db.findExerciseByName('deadlift');
      expect(partial, isNotNull);
      expect(partial?.id, 'ex_deadlift');
    });

    test(
      'migration from v1 to v2 adds columns and upserts enriched seeds',
      () async {
        final NativeDatabase connection = NativeDatabase.memory(
          setup: (rawDb) {
            rawDb.execute('''
            CREATE TABLE exercises (
              id TEXT NOT NULL PRIMARY KEY,
              name TEXT NOT NULL,
              muscle_group TEXT NOT NULL,
              category TEXT NOT NULL,
              instructions TEXT,
              is_custom INTEGER NOT NULL DEFAULT 0,
              created_at INTEGER NOT NULL DEFAULT (strftime('%s', 'now'))
            );
            CREATE TABLE workouts (
              id TEXT NOT NULL PRIMARY KEY,
              title TEXT NOT NULL,
              started_at INTEGER NOT NULL,
              completed_at INTEGER,
              notes TEXT,
              total_volume REAL NOT NULL DEFAULT 0.0,
              duration_seconds INTEGER NOT NULL DEFAULT 0
            );
            CREATE TABLE workout_sets (
              id TEXT NOT NULL PRIMARY KEY,
              workout_id TEXT NOT NULL REFERENCES workouts(id) ON DELETE CASCADE,
              exercise_id TEXT NOT NULL REFERENCES exercises(id),
              set_number INTEGER NOT NULL,
              reps INTEGER NOT NULL,
              weight REAL NOT NULL,
              rpe REAL,
              rest_seconds INTEGER NOT NULL DEFAULT 90,
              is_completed INTEGER NOT NULL DEFAULT 0,
              created_at INTEGER NOT NULL DEFAULT (strftime('%s', 'now'))
            );
            PRAGMA user_version = 1;
            INSERT INTO exercises (id, name, muscle_group, category)
            VALUES ('ex_bench_press', 'Barbell Bench Press', 'Chest', 'Barbell');
          ''');
          },
        );

        final AppDatabase upgradeDb = AppDatabase(connection);
        final List<Exercise> all = await upgradeDb.getAllExercises();
        expect(all, isNotEmpty);

        final Exercise bench = all.firstWhere(
          (Exercise e) => e.id == 'ex_bench_press',
        );
        expect(bench.movementPattern, 'horizontal_push');
        expect(bench.mechanics, 'compound');
        expect(bench.secondaryMuscles, contains('Triceps'));
        expect(bench.formCues, isNotNull);

        expect(all.any((Exercise e) => e.id == 'ex_chin_ups'), isTrue);
        expect(all.any((Exercise e) => e.id == 'ex_squat'), isTrue);

        await upgradeDb.close();
      },
    );
  });
}
