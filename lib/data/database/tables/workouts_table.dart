import 'package:drift/drift.dart';

/// Database table for workouts sessions.
class Workouts extends Table {
  /// Unique workout session ID (UUID).
  TextColumn get id => text()();

  /// User-friendly workout title (e.g. "Chest & Triceps Day").
  TextColumn get title => text()();

  /// Session start timestamp.
  DateTimeColumn get startedAt => dateTime()();

  /// Session completion timestamp (null if active).
  DateTimeColumn get completedAt => dateTime().nullable()();

  /// Optional workout notes.
  TextColumn get notes => text().nullable()();

  /// Total volume lifted in kg.
  RealColumn get totalVolume => real().withDefault(const Constant(0.0))();

  /// Total workout duration in seconds.
  IntColumn get durationSeconds => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}
