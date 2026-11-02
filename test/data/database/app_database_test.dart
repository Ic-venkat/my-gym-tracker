import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/data/database/app_database.dart';

void main() {
  late AppDatabase db;

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
        exerciseId: 'ex_barbell_squat',
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
  });
}
