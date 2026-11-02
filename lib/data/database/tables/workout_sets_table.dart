import 'package:drift/drift.dart';

import 'exercises_table.dart';
import 'workouts_table.dart';

/// Database table for individual workout exercise sets.
class WorkoutSets extends Table {
  /// Unique set ID (UUID).
  TextColumn get id => text()();

  /// Foreign key referencing the parent workout.
  TextColumn get workoutId =>
      text().references(Workouts, #id, onDelete: KeyAction.cascade)();

  /// Foreign key referencing the exercise.
  TextColumn get exerciseId => text().references(Exercises, #id)();

  /// Set order/number within this exercise (1, 2, 3...).
  IntColumn get setNumber => integer()();

  /// Target or achieved repetitions.
  IntColumn get reps => integer()();

  /// Weight lifted in kilograms.
  RealColumn get weight => real()();

  /// Rate of Perceived Exertion (1.0 to 10.0, optional).
  RealColumn get rpe => real().nullable()();

  /// Whether the set was marked completed.
  BoolColumn get isCompleted => boolean().withDefault(const Constant(true))();

  /// Rest time taken after set in seconds.
  IntColumn get restSeconds => integer().withDefault(const Constant(90))();

  /// Creation timestamp.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}

