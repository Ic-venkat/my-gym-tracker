import 'package:drift/drift.dart';

import '../app_database.dart';

/// Strongly-typed seed model holding comprehensive exercise metadata.
class SeedExerciseData {
  const SeedExerciseData({
    required this.id,
    required this.name,
    required this.muscleGroup,
    required this.category,
    required this.movementPattern,
    required this.mechanics,
    required this.equipment,
    required this.difficulty,
    required this.defaultRestSeconds,
    required this.targetRepRange,
    required this.minIncrementKg,
    this.secondaryMuscles,
    this.youtubeVideoId,
    this.formCues,
    this.commonMistakes,
    this.instructions,
  });

  final String id;
  final String name;
  final String muscleGroup;
  final String? secondaryMuscles;
  final String category;
  final String movementPattern;
  final String mechanics;
  final String equipment;
  final String difficulty;
  final String? youtubeVideoId;
  final String? formCues;
  final String? commonMistakes;
  final int defaultRestSeconds;
  final String targetRepRange;
  final double minIncrementKg;
  final String? instructions;

  /// Converts this seed item to a Drift [ExercisesCompanion] for insertion.
  ExercisesCompanion toCompanion() {
    return ExercisesCompanion.insert(
      id: id,
      name: name,
      muscleGroup: muscleGroup,
      secondaryMuscles: Value<String?>(secondaryMuscles),
      category: category,
      movementPattern: Value<String>(movementPattern),
      mechanics: Value<String>(mechanics),
      equipment: Value<String>(equipment),
      difficulty: Value<String>(difficulty),
      youtubeVideoId: Value<String?>(youtubeVideoId),
      formCues: Value<String?>(formCues),
      commonMistakes: Value<String?>(commonMistakes),
      defaultRestSeconds: Value<int>(defaultRestSeconds),
      targetRepRange: Value<String>(targetRepRange),
      minIncrementKg: Value<double>(minIncrementKg),
      instructions: Value<String?>(instructions),
    );
  }
}
