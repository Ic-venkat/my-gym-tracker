import 'package:drift/drift.dart';

import 'connection/connection.dart' as impl;
import 'seed_exercises.dart';
import 'tables/exercises_table.dart';
import 'tables/workout_sets_table.dart';
import 'tables/workouts_table.dart';

part 'app_database.g.dart';

/// Core SQLite Drift Database for GymTracker.
@DriftDatabase(tables: <Type>[Exercises, Workouts, WorkoutSets])
class AppDatabase extends _$AppDatabase {
  /// Default constructor opening platform-specific connection.
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? impl.openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      // Seed default exercises
      for (final Map<String, String> item in SeedExercises.initialExercises) {
        await into(exercises).insert(
          ExercisesCompanion.insert(
            id: item['id']!,
            name: item['name']!,
            muscleGroup: item['muscleGroup']!,
            category: item['category']!,
          ),
        );
      }
    },
  );

  // Exercise Queries

  /// Returns all exercises ordered by muscle group and name.
  Future<List<Exercise>> getAllExercises() {
    return (select(exercises)..orderBy(<OrderingTerm Function($ExercisesTable)>[
          ($ExercisesTable t) => OrderingTerm.asc(t.muscleGroup),
          ($ExercisesTable t) => OrderingTerm.asc(t.name),
        ]))
        .get();
  }

  /// Watch all exercises as a reactive stream.
  Stream<List<Exercise>> watchAllExercises() {
    return (select(exercises)..orderBy(<OrderingTerm Function($ExercisesTable)>[
          ($ExercisesTable t) => OrderingTerm.asc(t.muscleGroup),
          ($ExercisesTable t) => OrderingTerm.asc(t.name),
        ]))
        .watch();
  }

  /// Search exercises by name.
  Future<List<Exercise>> searchExercises(String query) {
    return (select(exercises)
          ..where(($ExercisesTable t) => t.name.like('%$query%'))
          ..orderBy(<OrderingTerm Function($ExercisesTable)>[
            ($ExercisesTable t) => OrderingTerm.asc(t.name),
          ]))
        .get();
  }

  /// Find exercise by exact or fuzzy name match.
  Future<Exercise?> findExerciseByName(String name) async {
    final String clean = name.trim().toLowerCase();
    final List<Exercise> all = await getAllExercises();
    for (final Exercise ex in all) {
      if (ex.name.toLowerCase() == clean ||
          ex.name.toLowerCase().contains(clean)) {
        return ex;
      }
    }
    return null;
  }

  // Workout Queries

  /// Insert or replace workout.
  Future<int> insertWorkout(Insertable<Workout> workout) {
    return into(workouts).insert(workout, mode: InsertMode.insertOrReplace);
  }

  /// Update workout.
  Future<bool> updateWorkout(Insertable<Workout> workout) {
    return update(workouts).replace(workout);
  }

  /// Get active (uncompleted) workout if any.
  Future<Workout?> getActiveWorkout() {
    return (select(workouts)
          ..where(($WorkoutsTable t) => t.completedAt.isNull())
          ..orderBy(<OrderingTerm Function($WorkoutsTable)>[
            ($WorkoutsTable t) => OrderingTerm.desc(t.startedAt),
          ])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Get all completed workouts ordered by date.
  Future<List<Workout>> getCompletedWorkouts() {
    return (select(workouts)
          ..where(($WorkoutsTable t) => t.completedAt.isNotNull())
          ..orderBy(<OrderingTerm Function($WorkoutsTable)>[
            ($WorkoutsTable t) => OrderingTerm.desc(t.startedAt),
          ]))
        .get();
  }

  /// Watch completed workouts as reactive stream.
  Stream<List<Workout>> watchCompletedWorkouts() {
    return (select(workouts)
          ..where(($WorkoutsTable t) => t.completedAt.isNotNull())
          ..orderBy(<OrderingTerm Function($WorkoutsTable)>[
            ($WorkoutsTable t) => OrderingTerm.desc(t.startedAt),
          ]))
        .watch();
  }

  // Workout Set Queries

  /// Insert workout set.
  Future<int> insertWorkoutSet(Insertable<WorkoutSet> set) {
    return into(workoutSets).insert(set, mode: InsertMode.insertOrReplace);
  }

  /// Get all sets for a specific workout.
  Future<List<WorkoutSet>> getSetsForWorkout(String workoutId) {
    return (select(workoutSets)
          ..where(($WorkoutSetsTable t) => t.workoutId.equals(workoutId))
          ..orderBy(<OrderingTerm Function($WorkoutSetsTable)>[
            ($WorkoutSetsTable t) => OrderingTerm.asc(t.createdAt),
          ]))
        .get();
  }

  /// Watch sets for a specific workout.
  Stream<List<WorkoutSet>> watchSetsForWorkout(String workoutId) {
    return (select(workoutSets)
          ..where(($WorkoutSetsTable t) => t.workoutId.equals(workoutId))
          ..orderBy(<OrderingTerm Function($WorkoutSetsTable)>[
            ($WorkoutSetsTable t) => OrderingTerm.asc(t.createdAt),
          ]))
        .watch();
  }

  /// Delete set by ID.
  Future<int> deleteWorkoutSet(String id) {
    return (delete(
      workoutSets,
    )..where(($WorkoutSetsTable t) => t.id.equals(id))).go();
  }
}
