import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/features/templates/models/template_exercise.dart';
import 'package:gym_tracker/features/templates/models/workout_template.dart';
import 'package:gym_tracker/features/templates/widgets/template_card_item.dart';

void main() {
  group('TemplateCardItem', () {
    const WorkoutTemplate testTemplate = WorkoutTemplate(
      id: 'tpl_push',
      name: 'Push Hypertrophy',
      category: 'PPL',
      description: 'Focus on chest, delts, and triceps.',
      estimatedMinutes: 50,
      exercises: <TemplateExercise>[
        TemplateExercise(
          exerciseId: 'ex_bench',
          exerciseName: 'Barbell Bench Press',
          targetSets: 4,
          targetRepRange: '6-8',
          targetRestSeconds: 180,
        ),
      ],
    );

    testWidgets(
      'renders category, name, exercise count, duration, and description',
      (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TemplateCardItem(template: testTemplate, onTap: () {}),
            ),
          ),
        );

        // Assert
        expect(find.text('PPL'), findsOneWidget);
        expect(find.text('Push Hypertrophy'), findsOneWidget);
        expect(find.textContaining('1 exercises • ~50 mins'), findsOneWidget);
        expect(
          find.textContaining('Focus on chest, delts, and triceps.'),
          findsOneWidget,
        );
        expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);
      },
    );

    testWidgets('tapping card invokes onTap callback', (
      WidgetTester tester,
    ) async {
      // Arrange
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TemplateCardItem(
              template: testTemplate,
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.text('Push Hypertrophy'));
      await tester.pump();

      // Assert
      expect(tapped, isTrue);
    });
  });
}
