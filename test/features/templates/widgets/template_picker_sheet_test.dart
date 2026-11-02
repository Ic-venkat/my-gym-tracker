import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/features/templates/models/workout_template.dart';
import 'package:gym_tracker/features/templates/widgets/template_picker_sheet.dart';

void main() {
  group('TemplatePickerSheet', () {
    testWidgets('renders templates and invokes onSelect callback', (
      WidgetTester tester,
    ) async {
      WorkoutTemplate? selected;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TemplatePickerSheet(
              onSelect: (WorkoutTemplate t) => selected = t,
            ),
          ),
        ),
      );

      expect(find.text('Choose a Workout Split'), findsOneWidget);
      expect(find.textContaining('Push Day'), findsOneWidget);
      expect(find.textContaining('Pull Day'), findsOneWidget);

      await tester.tap(find.textContaining('Push Day').first);
      await tester.pumpAndSettle();

      expect(selected, isNotNull);
      expect(selected!.category, 'PPL');
    });
  });
}
