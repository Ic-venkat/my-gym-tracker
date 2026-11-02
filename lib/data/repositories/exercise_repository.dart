import 'package:uuid/uuid.dart';

import '../../core/logger/app_logger.dart';
import '../../core/utils/result.dart';
import '../database/app_database.dart';

/// Repository handling exercise queries and custom exercise creation.
class ExerciseRepository {
  ExerciseRepository({required AppDatabase database}) : _db = database;

  final AppDatabase _db;
  static const Uuid _uuid = Uuid();

  /// Retrieves all exercises from database.
  Future<Result<List<Exercise>>> getAllExercises() async {
    try {
      final List<Exercise> list = await _db.getAllExercises();
      return Success<List<Exercise>>(list);
    } catch (e, st) {
      AppLogger.e('Failed to load exercises', error: e, stackTrace: st);
      return Failure<List<Exercise>>('Failed to load exercises: $e', e);
    }
  }

  /// Watches all exercises as a reactive stream.
  Stream<List<Exercise>> watchAllExercises() {
    return _db.watchAllExercises();
  }

  /// Searches exercises by keyword.
  Future<Result<List<Exercise>>> searchExercises(String query) async {
    try {
      final List<Exercise> list = await _db.searchExercises(query);
      return Success<List<Exercise>>(list);
    } catch (e, st) {
      AppLogger.e(
        'Failed to search exercises: $query',
        error: e,
        stackTrace: st,
      );
      return Failure<List<Exercise>>('Search failed: $e', e);
    }
  }

  /// Finds exercise matching name (fuzzy/case-insensitive).
  Future<Result<Exercise?>> findExerciseByName(String name) async {
    try {
      final Exercise? ex = await _db.findExerciseByName(name);
      return Success<Exercise?>(ex);
    } catch (e, st) {
      AppLogger.e('Failed to find exercise: $name', error: e, stackTrace: st);
      return Failure<Exercise?>('Failed to find exercise: $e', e);
    }
  }

  /// Creates a custom user exercise.
  Future<Result<Exercise>> createCustomExercise({
    required String name,
    required String muscleGroup,
    required String category,
    String? instructions,
    String? secondaryMuscles,
    String movementPattern = 'compound',
    String mechanics = 'compound',
    String? equipment,
    String difficulty = 'beginner',
    String? youtubeVideoId,
    String? formCues,
    String? commonMistakes,
    int defaultRestSeconds = 90,
    String targetRepRange = '8-12',
    double minIncrementKg = 2.5,
  }) async {
    try {
      final String id = 'custom_${_uuid.v4()}';
      final Exercise newExercise = Exercise(
        id: id,
        name: name.trim(),
        muscleGroup: muscleGroup,
        secondaryMuscles: secondaryMuscles,
        category: category,
        movementPattern: movementPattern,
        mechanics: mechanics,
        equipment: equipment ?? category.toLowerCase(),
        difficulty: difficulty,
        youtubeVideoId: youtubeVideoId,
        formCues: formCues,
        commonMistakes: commonMistakes,
        defaultRestSeconds: defaultRestSeconds,
        targetRepRange: targetRepRange,
        minIncrementKg: minIncrementKg,
        instructions: instructions,
        isCustom: true,
        createdAt: DateTime.now(),
      );

      await _db.insertExercise(newExercise);
      return Success<Exercise>(newExercise);
    } catch (e, st) {
      AppLogger.e(
        'Failed to create custom exercise: $name',
        error: e,
        stackTrace: st,
      );
      return Failure<Exercise>('Failed to create exercise: $e', e);
    }
  }
}
