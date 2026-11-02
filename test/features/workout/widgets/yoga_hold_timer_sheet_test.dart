import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/features/workout/models/asana_pose.dart';
import 'package:gym_tracker/features/workout/models/yoga_routine.dart';
import 'package:gym_tracker/features/workout/widgets/yoga_hold_timer_sheet.dart';

void main() {
  group('YogaHoldTimerSheet', () {
    const YogaRoutine testRoutine = YogaRoutine(
      id: 'test_quick',
      name: 'Quick Stretch',
      targetBenefit: 'Relaxation',
      recommendedAfterMuscles: <String>['Legs'],
      estimatedMinutes: 1,
      poses: <AsanaPose>[
        AsanaPose(
          name: 'Pigeon Pose',
          sanskritName: 'Eka Pada Rajakapotasana',
          holdSeconds: 60,
          isBilateral: true,
          targetMuscles: 'Piriformis, Glutes',
          cues: 'Fold forward over knee',
          breathingPattern: '4s in, 4s out',
        ),
      ],
    );

    testWidgets('renders active pose, seconds, and switches side on advance', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: YogaHoldTimerSheet(routine: testRoutine)),
        ),
      );

      expect(find.text('Pigeon Pose'), findsOneWidget);
      expect(find.text('Switch to Left Side'), findsOneWidget);

      await tester.tap(find.text('Switch to Left Side'));
      await tester.pump();

      expect(find.text('Next Pose'), findsOneWidget);

      await tester.tap(find.text('Next Pose'));
      await tester.pump();

      expect(find.text('Flow Complete! Namaste 🙏'), findsOneWidget);
    });
  });
}
