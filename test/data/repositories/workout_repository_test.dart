import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/core/utils/result.dart';
import 'package:gym_tracker/data/database/app_database.dart';
import 'package:gym_tracker/data/repositories/workout_repository.dart';

void main() {
  late AppDatabase db;
  late WorkoutRepository repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = WorkoutRepository(database: db);
  });

  tearDown(() async {
    await db.close();
  });

  group('WorkoutRepository', () {
    test('startWorkout creates and saves a new active workout', () async {
      final Result<Workout> result = await repository.startWorkout(
        title: 'Upper Body',
      );

      expect(result, isA<Success<Workout>>());
      final Workout workout = (result as Success<Workout>).data;
      expect(workout.title, 'Upper Body');
      expect(workout.completedAt, isNull);
      expect(workout.totalVolume, 0.0);

      final Result<Workout?> active = await repository.getActiveWorkout();
      expect(active, isA<Success<Workout?>>());
      expect((active as Success<Workout?>).data?.id, workout.id);
    });

    test('logSet increments set number and records volume', () async {
      final Result<Workout> wResult = await repository.startWorkout();
      final String workoutId = (wResult as Success<Workout>).data.id;

      final Result<WorkoutSet> set1 = await repository.logSet(
        workoutId: workoutId,
        exerciseId: 'ex_bench_press',
        reps: 10,
        weight: 80.0,
      );
      expect(set1, isA<Success<WorkoutSet>>());
      expect((set1 as Success<WorkoutSet>).data.setNumber, 1);

      final Result<WorkoutSet> set2 = await repository.logSet(
        workoutId: workoutId,
        exerciseId: 'ex_bench_press',
        reps: 8,
        weight: 85.0,
      );
      expect(set2, isA<Success<WorkoutSet>>());
      expect((set2 as Success<WorkoutSet>).data.setNumber, 2);

      final Result<List<WorkoutSet>> sets = await repository.getSetsForWorkout(
        workoutId,
      );
      expect(sets, isA<Success<List<WorkoutSet>>>());
      expect((sets as Success<List<WorkoutSet>>).data.length, 2);
    });

    test(
      'finishWorkout calculates total volume and duration accurately',
      () async {
        final Result<Workout> wResult = await repository.startWorkout(
          title: 'Chest Day',
        );
        final String workoutId = (wResult as Success<Workout>).data.id;

        // 10 reps * 80 kg = 800 kg
        await repository.logSet(
          workoutId: workoutId,
          exerciseId: 'ex_bench_press',
          reps: 10,
          weight: 80.0,
        );
        // 8 reps * 90 kg = 720 kg
        await repository.logSet(
          workoutId: workoutId,
          exerciseId: 'ex_bench_press',
          reps: 8,
          weight: 90.0,
        );

        final Result<Workout> finishResult = await repository.finishWorkout(
          workoutId: workoutId,
          notes: 'Great pump',
        );

        expect(finishResult, isA<Success<Workout>>());
        final Workout finished = (finishResult as Success<Workout>).data;
        expect(finished.totalVolume, 1520.0);
        expect(finished.completedAt, isNotNull);
        expect(finished.notes, 'Great pump');
        expect(finished.durationSeconds, greaterThanOrEqualTo(0));
      },
    );

    test(
      'finishWorkout returns Failure when workout ID does not exist',
      () async {
        final Result<Workout> result = await repository.finishWorkout(
          workoutId: 'non_existent_id',
        );
        expect(result, isA<Failure<Workout>>());
      },
    );

    test('deleteWorkoutSet removes the set from database', () async {
      final Result<Workout> wResult = await repository.startWorkout();
      final String workoutId = (wResult as Success<Workout>).data.id;

      final Result<WorkoutSet> setResult = await repository.logSet(
        workoutId: workoutId,
        exerciseId: 'ex_bench_press',
        reps: 10,
        weight: 80.0,
      );
      final String setId = (setResult as Success<WorkoutSet>).data.id;

      final Result<bool> delResult = await repository.deleteWorkoutSet(setId);
      expect(delResult, isA<Success<bool>>());

      final Result<List<WorkoutSet>> remaining = await repository
          .getSetsForWorkout(workoutId);
      expect((remaining as Success<List<WorkoutSet>>).data, isEmpty);
    });
  });
}
