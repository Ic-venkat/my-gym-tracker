import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/data/models/models.dart';
import 'package:gym_tracker/features/workout/widgets/exercise_picker_sheet.dart';

import '../../../helpers/test_factories.dart';

void main() {
  final Exercise bench = createTestExercise();
  final Exercise squat = createTestExercise(
    id: 'ex_squat',
    name: 'Barbell Back Squat',
    muscleGroup: 'Legs',
  );
  final Exercise pullups = createTestExercise(
    id: 'ex_pullups',
    name: 'Pull-Ups',
    muscleGroup: 'Back',
  );

  final List<Exercise> sampleExercises = <Exercise>[bench, squat, pullups];

  Widget buildTestWidget({required ValueChanged<Exercise> onSelected}) {
    return MaterialApp(
      home: Scaffold(
        body: ExercisePickerSheet(
          availableExercises: sampleExercises,
          onSelected: onSelected,
        ),
      ),
    );
  }

  group('ExercisePickerSheet', () {
    testWidgets('renders list of available exercises', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(onSelected: (_) {}));
      await tester.pumpAndSettle();

      expect(find.text('Barbell Bench Press'), findsOneWidget);
      expect(find.text('Barbell Back Squat'), findsOneWidget);
      expect(find.text('Pull-Ups'), findsOneWidget);
    });

    testWidgets('filters exercises when typing in search input', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(onSelected: (_) {}));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'squat');
      await tester.pumpAndSettle();

      expect(find.text('Barbell Back Squat'), findsOneWidget);
      expect(find.text('Barbell Bench Press'), findsNothing);
      expect(find.text('Pull-Ups'), findsNothing);
    });

    testWidgets('filters exercises when selecting category chip', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(onSelected: (_) {}));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Chest'));
      await tester.pumpAndSettle();

      expect(find.text('Barbell Bench Press'), findsOneWidget);
      expect(find.text('Barbell Back Squat'), findsNothing);
      expect(find.text('Pull-Ups'), findsNothing);
    });

    testWidgets('triggers onSelected callback when exercise tapped', (
      WidgetTester tester,
    ) async {
      Exercise? chosen;
      await tester.pumpWidget(
        buildTestWidget(onSelected: (Exercise ex) => chosen = ex),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Pull-Ups'));
      await tester.pumpAndSettle();

      expect(chosen, isNotNull);
      expect(chosen?.id, 'ex_pullups');
    });
  });
}
