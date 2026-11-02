import 'package:drift/drift.dart';

/// Database table for exercises with scientific biomechanical classifications.
class Exercises extends Table {
  /// Unique exercise ID (UUID).
  TextColumn get id => text()();

  /// Exercise name (e.g. "Barbell Bench Press").
  TextColumn get name => text()();

  /// Primary muscle group (e.g. "Chest", "Back", "Quads").
  TextColumn get muscleGroup => text()();

  /// Secondary/synergist muscles (e.g. "Triceps, Front Delts").
  TextColumn get secondaryMuscles => text().nullable()();

  /// Equipment/category (e.g. "Barbell", "Dumbbell", "Cable", "Bodyweight").
  TextColumn get category => text()();

  /// Biomechanical movement pattern (e.g. "horizontal_push", "hip_dominant").
  TextColumn get movementPattern =>
      text().withDefault(const Constant('compound'))();

  /// Movement mechanics ("compound", "isolation", "stretch", "cardio").
  TextColumn get mechanics => text().withDefault(const Constant('compound'))();

  /// Equipment required ("barbell", "dumbbell", "bodyweight", "machine", etc.).
  TextColumn get equipment => text().withDefault(const Constant('barbell'))();

  /// Difficulty level ("beginner", "intermediate", "advanced").
  TextColumn get difficulty => text().withDefault(const Constant('beginner'))();

  /// YouTube Shorts or video ID for form demonstration.
  TextColumn get youtubeVideoId => text().nullable()();

  /// Key posture and execution cues.
  TextColumn get formCues => text().nullable()();

  /// Common mistakes to avoid injury.
  TextColumn get commonMistakes => text().nullable()();

  /// Recommended rest interval in seconds.
  IntColumn get defaultRestSeconds =>
      integer().withDefault(const Constant(90))();

  /// Target hypertrophy / strength rep range.
  TextColumn get targetRepRange => text().withDefault(const Constant('8-12'))();

  /// Minimum incremental load in kg.
  RealColumn get minIncrementKg => real().withDefault(const Constant(2.5))();

  /// Optional instructions or cues.
  TextColumn get instructions => text().nullable()();

  /// Whether this is a user-created exercise.
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();

  /// Timestamp when exercise was created.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}
