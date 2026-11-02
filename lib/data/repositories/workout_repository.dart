import 'dart:math' as math;

import 'package:uuid/uuid.dart';

import '../../core/logger/app_logger.dart';
import '../../core/utils/result.dart';
import '../database/app_database.dart';

/// Repository handling workouts, active sessions, and set logging.
class WorkoutRepository {
  WorkoutRepository({required AppDatabase database}) : _db = database;

  final AppDatabase _db;
  static const Uuid _uuid = Uuid();

  /// Retrieves active workout if one is currently in progress.
  Future<Result<Workout?>> getActiveWorkout() async {
    try {
      final Workout? workout = await _db.getActiveWorkout();
      return Success<Workout?>(workout);
    } catch (e, st) {
      AppLogger.e('Failed to fetch active workout', error: e, stackTrace: st);
      return Failure<Workout?>('Failed to fetch active workout: $e', e);
    }
  }

  /// Starts a new active workout session.
  Future<Result<Workout>> startWorkout({String title = 'Workout'}) async {
    try {
      final Workout newWorkout = Workout(
        id: _uuid.v4(),
        title: title,
        startedAt: DateTime.now(),
        totalVolume: 0.0,
        durationSeconds: 0,
      );

      await _db.insertWorkout(newWorkout);
      return Success<Workout>(newWorkout);
    } catch (e, st) {
      AppLogger.e('Failed to start workout', error: e, stackTrace: st);
      return Failure<Workout>('Failed to start workout: $e', e);
    }
  }

  /// Finishes and saves a workout session.
  Future<Result<Workout>> finishWorkout({
    required String workoutId,
    String? notes,
  }) async {
    try {
      final Workout? current = await _db.getWorkoutById(workoutId);
      if (current == null) {
        return Failure<Workout>('Workout with ID $workoutId not found');
      }

      final List<WorkoutSet> sets = await _db.getSetsForWorkout(workoutId);
      double totalVolume = 0.0;
      for (final WorkoutSet s in sets) {
        if (s.isCompleted) {
          totalVolume += (s.reps * s.weight);
        }
      }

      final DateTime now = DateTime.now();
      final DateTime started = current.startedAt;
      final int duration = math.max(0, now.difference(started).inSeconds);

      final Workout updated = Workout(
        id: workoutId,
        title: current.title,
        startedAt: started,
        completedAt: now,
        notes: notes,
        totalVolume: totalVolume,
        durationSeconds: duration,
      );

      final bool updatedSuccess = await _db.updateWorkout(updated);
      if (!updatedSuccess) {
        return Failure<Workout>(
          'Failed to update workout $workoutId in database',
        );
      }
      return Success<Workout>(updated);
    } catch (e, st) {
      AppLogger.e(
        'Failed to finish workout: $workoutId',
        error: e,
        stackTrace: st,
      );
      return Failure<Workout>('Failed to finish workout: $e', e);
    }
  }

  /// Logs a set for an exercise in a workout session.
  Future<Result<WorkoutSet>> logSet({
    required String workoutId,
    required String exerciseId,
    required int reps,
    required double weight,
    double? rpe,
    int restSeconds = 90,
  }) async {
    try {
      final List<WorkoutSet> existing = await _db.getSetsForWorkout(workoutId);
      final int setNumber =
          existing.where((WorkoutSet s) => s.exerciseId == exerciseId).length +
          1;

      final WorkoutSet newSet = WorkoutSet(
        id: _uuid.v4(),
        workoutId: workoutId,
        exerciseId: exerciseId,
        setNumber: setNumber,
        reps: reps,
        weight: weight,
        rpe: rpe,
        isCompleted: true,
        restSeconds: restSeconds,
        createdAt: DateTime.now(),
      );

      await _db.insertWorkoutSet(newSet);
      return Success<WorkoutSet>(newSet);
    } catch (e, st) {
      AppLogger.e(
        'Failed to log set for exercise: $exerciseId',
        error: e,
        stackTrace: st,
      );
      return Failure<WorkoutSet>('Failed to log set: $e', e);
    }
  }

  /// Gets all sets for a workout session.
  Future<Result<List<WorkoutSet>>> getSetsForWorkout(String workoutId) async {
    try {
      final List<WorkoutSet> sets = await _db.getSetsForWorkout(workoutId);
      return Success<List<WorkoutSet>>(sets);
    } catch (e, st) {
      AppLogger.e(
        'Failed to get sets for workout: $workoutId',
        error: e,
        stackTrace: st,
      );
      return Failure<List<WorkoutSet>>('Failed to load sets: $e', e);
    }
  }

  /// Watches sets for an active workout.
  Stream<List<WorkoutSet>> watchSetsForWorkout(String workoutId) {
    return _db.watchSetsForWorkout(workoutId);
  }

  /// Gets list of completed past workouts.
  Future<Result<List<Workout>>> getCompletedWorkouts() async {
    try {
      final List<Workout> list = await _db.getCompletedWorkouts();
      return Success<List<Workout>>(list);
    } catch (e, st) {
      AppLogger.e(
        'Failed to load completed workouts',
        error: e,
        stackTrace: st,
      );
      return Failure<List<Workout>>('Failed to load workout history: $e', e);
    }
  }

  /// Watches completed workouts stream.
  Stream<List<Workout>> watchCompletedWorkouts() {
    return _db.watchCompletedWorkouts();
  }

  /// Deletes a set by its ID.
  Future<Result<bool>> deleteWorkoutSet(String id) async {
    try {
      await _db.deleteWorkoutSet(id);
      return const Success<bool>(true);
    } catch (e, st) {
      AppLogger.e('Failed to delete set: $id', error: e, stackTrace: st);
      return Failure<bool>('Failed to delete set: $e', e);
    }
  }
}
