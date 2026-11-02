import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/features/workout/widgets/add_set_dialog.dart';

void main() {
  group('AddSetDialog', () {
    Widget createWidgetUnderTest({
      required String exerciseName,
      required void Function(int reps, double weight) onLog,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              return ElevatedButton(
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (_) =>
                        AddSetDialog(exerciseName: exerciseName, onLog: onLog),
                  );
                },
                child: const Text('Open Dialog'),
              );
            },
          ),
        ),
      );
    }

    testWidgets('renders title and default weight and rep values', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        createWidgetUnderTest(
          exerciseName: 'Barbell Bench Press',
          onLog: (_, _) {},
        ),
      );

      // Act
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Log Set: Barbell Bench Press'), findsOneWidget);
      expect(find.widgetWithText(TextField, '60'), findsOneWidget);
      expect(find.widgetWithText(TextField, '10'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Log Set'), findsOneWidget);
    });

    testWidgets(
      'submitting default values calls onLog with 10 reps and 60.0 kg',
      (WidgetTester tester) async {
        // Arrange
        int? loggedReps;
        double? loggedWeight;

        await tester.pumpWidget(
          createWidgetUnderTest(
            exerciseName: 'Squat',
            onLog: (int r, double w) {
              loggedReps = r;
              loggedWeight = w;
            },
          ),
        );
        await tester.tap(find.text('Open Dialog'));
        await tester.pumpAndSettle();

        // Act
        await tester.tap(find.text('Log Set'));
        await tester.pumpAndSettle();

        // Assert
        expect(loggedReps, equals(10));
        expect(loggedWeight, equals(60.0));
        expect(find.byType(AddSetDialog), findsNothing);
      },
    );

    testWidgets('submitting custom values calls onLog with updated values', (
      WidgetTester tester,
    ) async {
      // Arrange
      int? loggedReps;
      double? loggedWeight;

      await tester.pumpWidget(
        createWidgetUnderTest(
          exerciseName: 'Deadlift',
          onLog: (int r, double w) {
            loggedReps = r;
            loggedWeight = w;
          },
        ),
      );
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      // Act
      final Finder weightField = find.widgetWithText(TextField, '60');
      final Finder repsField = find.widgetWithText(TextField, '10');

      await tester.enterText(weightField, '105.5');
      await tester.enterText(repsField, '5');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Log Set'));
      await tester.pumpAndSettle();

      // Assert
      expect(loggedReps, equals(5));
      expect(loggedWeight, equals(105.5));
      expect(find.byType(AddSetDialog), findsNothing);
    });

    testWidgets('does not call onLog when reps are 0 or negative', (
      WidgetTester tester,
    ) async {
      // Arrange
      bool wasCalled = false;

      await tester.pumpWidget(
        createWidgetUnderTest(
          exerciseName: 'Overhead Press',
          onLog: (_, _) {
            wasCalled = true;
          },
        ),
      );
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      // Act
      final Finder repsField = find.widgetWithText(TextField, '10');
      await tester.enterText(repsField, '0');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Log Set'));
      await tester.pumpAndSettle();

      // Assert
      expect(wasCalled, isFalse);
      expect(find.byType(AddSetDialog), findsOneWidget);
    });

    testWidgets('tapping Cancel dismisses dialog without calling onLog', (
      WidgetTester tester,
    ) async {
      // Arrange
      bool wasCalled = false;

      await tester.pumpWidget(
        createWidgetUnderTest(
          exerciseName: 'Pull-Up',
          onLog: (_, _) {
            wasCalled = true;
          },
        ),
      );
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Assert
      expect(wasCalled, isFalse);
      expect(find.byType(AddSetDialog), findsNothing);
    });
  });
}
