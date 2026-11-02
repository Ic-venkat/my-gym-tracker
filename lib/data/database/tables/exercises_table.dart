import 'package:drift/drift.dart';

/// Database table for exercises.
class Exercises extends Table {
  /// Unique exercise ID (UUID).
  TextColumn get id => text()();

  /// Exercise name (e.g. "Barbell Bench Press").
  TextColumn get name => text()();

  /// Primary muscle group (e.g. "Chest", "Legs").
  TextColumn get muscleGroup => text()();

  /// Equipment/category (e.g. "Barbell", "Dumbbell", "Cable", "Bodyweight").
  TextColumn get category => text()();

  /// Optional instructions or cues.
  TextColumn get instructions => text().nullable()();

  /// Whether this is a user-created exercise.
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();

  /// Timestamp when exercise was created.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}

