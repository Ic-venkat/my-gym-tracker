import 'package:gym_tracker/data/database/app_database.dart';

/// Test factory providing default [Exercise] instances for unit and widget tests.
Exercise createTestExercise({
  String id = 'ex_bench',
  String name = 'Barbell Bench Press',
  String muscleGroup = 'Chest',
  String? secondaryMuscles,
  String category = 'Barbell',
  String movementPattern = 'horizontal_push',
  String mechanics = 'compound',
  String equipment = 'barbell',
  String difficulty = 'intermediate',
  String? youtubeVideoId,
  String? formCues,
  String? commonMistakes,
  int defaultRestSeconds = 180,
  String targetRepRange = '5-8',
  double minIncrementKg = 2.5,
  String? instructions,
  bool isCustom = false,
  DateTime? createdAt,
}) {
  return Exercise(
    id: id,
    name: name,
    muscleGroup: muscleGroup,
    secondaryMuscles: secondaryMuscles,
    category: category,
    movementPattern: movementPattern,
    mechanics: mechanics,
    equipment: equipment,
    difficulty: difficulty,
    youtubeVideoId: youtubeVideoId,
    formCues: formCues,
    commonMistakes: commonMistakes,
    defaultRestSeconds: defaultRestSeconds,
    targetRepRange: targetRepRange,
    minIncrementKg: minIncrementKg,
    instructions: instructions,
    isCustom: isCustom,
    createdAt: createdAt ?? DateTime.now(),
  );
}
