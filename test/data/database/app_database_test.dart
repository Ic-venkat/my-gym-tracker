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

    test('can insert and retrieve a workout session', () async {
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
    });

    test('can insert workout set and fetch for workout', () async {
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
    });
  });
}
