import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/core/utils/result.dart';
import 'package:gym_tracker/features/templates/models/workout_template.dart';
import 'package:gym_tracker/features/templates/repositories/template_repository.dart';

void main() {
  group('TemplateRepository', () {
    const TemplateRepository repo = TemplateRepository();

    test('getAllTemplates returns list of default curated splits', () async {
      final Result<List<WorkoutTemplate>> result = await repo.getAllTemplates();
      expect(result, isA<Success<List<WorkoutTemplate>>>());
      final List<WorkoutTemplate> templates =
          (result as Success<List<WorkoutTemplate>>).data;
      expect(templates, isNotEmpty);
      expect(templates.any((WorkoutTemplate t) => t.category == 'PPL'), isTrue);
    });

    test('getTemplateById returns matching template or null', () async {
      final Result<WorkoutTemplate?> found = await repo.getTemplateById(
        'template_ppl_push',
      );
      expect(found, isA<Success<WorkoutTemplate?>>());
      final WorkoutTemplate? template =
          (found as Success<WorkoutTemplate?>).data;
      expect(template, isNotNull);
      expect(template!.name, contains('Push Day'));

      final Result<WorkoutTemplate?> missing = await repo.getTemplateById(
        'non_existent',
      );
      expect((missing as Success<WorkoutTemplate?>).data, isNull);
    });

    test('getTemplatesByCategory filters correctly', () async {
      final Result<List<WorkoutTemplate>> cali = await repo
          .getTemplatesByCategory('Calisthenics');
      expect(cali, isA<Success<List<WorkoutTemplate>>>());
      final List<WorkoutTemplate> caliList =
          (cali as Success<List<WorkoutTemplate>>).data;
      expect(
        caliList.every((WorkoutTemplate t) => t.category == 'Calisthenics'),
        isTrue,
      );

      final Result<List<WorkoutTemplate>> all = await repo
          .getTemplatesByCategory('all');
      expect(
        (all as Success<List<WorkoutTemplate>>).data.length,
        greaterThanOrEqualTo(4),
      );
    });
  });
}
