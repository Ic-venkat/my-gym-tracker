import 'package:drift/drift.dart';

import 'connection/connection.dart' as impl;
import 'seed_exercises.dart';
import 'seeds/seed_model.dart';
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
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (OpeningDetails details) async {
      await customStatement('PRAGMA foreign_keys = ON;');
      await customStatement('PRAGMA journal_mode = WAL;');
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.addColumn(exercises, exercises.secondaryMuscles);
        await m.addColumn(exercises, exercises.movementPattern);
        await m.addColumn(exercises, exercises.mechanics);
        await m.addColumn(exercises, exercises.equipment);
        await m.addColumn(exercises, exercises.difficulty);
        await m.addColumn(exercises, exercises.youtubeVideoId);
        await m.addColumn(exercises, exercises.formCues);
        await m.addColumn(exercises, exercises.commonMistakes);
        await m.addColumn(exercises, exercises.defaultRestSeconds);
        await m.addColumn(exercises, exercises.targetRepRange);
        await m.addColumn(exercises, exercises.minIncrementKg);

        await batch((Batch b) {
          b.insertAll(
            exercises,
            SeedExercises.allSeeds.map((SeedExerciseData s) => s.toCompanion()),
            mode: InsertMode.insertOrReplace,
          );
        });
      }
    },
    onCreate: (Migrator m) async {
      await m.createAll();
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_sets_wid ON workout_sets(workout_id, created_at);',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_sets_eid ON workout_sets(exercise_id);',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_workouts_status ON workouts(completed_at, started_at);',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_exercises_cat ON exercises(muscle_group, name);',
      );
      await batch((Batch b) {
        b.insertAll(
          exercises,
          SeedExercises.allSeeds.map(
            (SeedExerciseData item) => item.toCompanion(),
          ),
        );
      });
    },
  );

  // Exercise Queries

  /// Insert or replace an exercise.
  Future<int> insertExercise(Insertable<Exercise> exercise) {
    return into(exercises).insert(exercise, mode: InsertMode.insertOrReplace);
  }

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

  /// Search exercises by name keyword.
  Future<List<Exercise>> searchExercises(String query) {
    final String clean = query.trim().toLowerCase().replaceAll(
      RegExp(r'[%_]'),
      '',
    );
    return (select(exercises)
          ..where(($ExercisesTable t) => t.name.lower().like('%$clean%'))
          ..orderBy(<OrderingTerm Function($ExercisesTable)>[
            ($ExercisesTable t) => OrderingTerm.asc(t.name),
          ]))
        .get();
  }

  /// Find exercise by exact or fuzzy name match using direct SQL.
  Future<Exercise?> findExerciseByName(String name) async {
    final String trimmed = name.trim().toLowerCase();
    final Exercise? exact =
        await (select(exercises)
              ..where(($ExercisesTable t) => t.name.lower().equals(trimmed))
              ..limit(1))
            .getSingleOrNull();
    if (exact != null) {
      return exact;
    }

    final String clean = trimmed.replaceAll(RegExp(r'[%_]'), '');
    return (select(exercises)
          ..where(($ExercisesTable t) => t.name.lower().like('%$clean%'))
          ..limit(1))
        .getSingleOrNull();
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

  /// Get workout by unique ID.
  Future<Workout?> getWorkoutById(String id) {
    return (select(
      workouts,
    )..where(($WorkoutsTable t) => t.id.equals(id))).getSingleOrNull();
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

  /// Watch active (uncompleted) workout stream.
  Stream<Workout?> watchActiveWorkout() {
    return (select(workouts)
          ..where(($WorkoutsTable t) => t.completedAt.isNull())
          ..orderBy(<OrderingTerm Function($WorkoutsTable)>[
            ($WorkoutsTable t) => OrderingTerm.desc(t.startedAt),
          ])
          ..limit(1))
        .watchSingleOrNull();
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
