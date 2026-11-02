import '../../../core/logger/app_logger.dart';
import '../../../core/utils/result.dart';
import '../data/default_templates.dart';
import '../models/workout_template.dart';

/// Repository managing built-in and user-saved workout templates.
class TemplateRepository {
  const TemplateRepository();

  /// Retrieves all curated workout templates.
  Future<Result<List<WorkoutTemplate>>> getAllTemplates() async {
    try {
      return const Success<List<WorkoutTemplate>>(defaultWorkoutTemplates);
    } catch (e, st) {
      AppLogger.e('Failed to load templates', error: e, stackTrace: st);
      return const Failure<List<WorkoutTemplate>>(
        'Unable to load workout templates.',
      );
    }
  }

  /// Retrieves a specific template by its identifier.
  Future<Result<WorkoutTemplate?>> getTemplateById(String id) async {
    try {
      final WorkoutTemplate? found = defaultWorkoutTemplates
          .where((WorkoutTemplate t) => t.id == id)
          .firstOrNull;
      return Success<WorkoutTemplate?>(found);
    } catch (e, st) {
      AppLogger.e('Failed to find template: $id', error: e, stackTrace: st);
      return const Failure<WorkoutTemplate?>(
        'Unable to find requested template.',
      );
    }
  }

  /// Filters templates by category (e.g. 'PPL', 'Calisthenics', 'Mobility').
  Future<Result<List<WorkoutTemplate>>> getTemplatesByCategory(
    String category,
  ) async {
    try {
      if (category.toLowerCase() == 'all') {
        return const Success<List<WorkoutTemplate>>(defaultWorkoutTemplates);
      }
      final List<WorkoutTemplate> filtered = defaultWorkoutTemplates
          .where(
            (WorkoutTemplate t) =>
                t.category.toLowerCase() == category.toLowerCase(),
          )
          .toList();
      return Success<List<WorkoutTemplate>>(filtered);
    } catch (e, st) {
      AppLogger.e(
        'Failed to filter templates by $category',
        error: e,
        stackTrace: st,
      );
      return const Failure<List<WorkoutTemplate>>(
        'Unable to filter workout templates.',
      );
    }
  }
}
