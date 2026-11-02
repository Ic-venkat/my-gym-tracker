import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/features/workout/models/asana_pose.dart';
import 'package:gym_tracker/features/workout/models/yoga_routine.dart';
import 'package:gym_tracker/features/workout/services/yoga_timer_controller.dart';

void main() {
  group('YogaTimerController', () {
    const YogaRoutine testRoutine = YogaRoutine(
      id: 'test_routine',
      name: 'Test Flow',
      targetBenefit: 'Mobility',
      recommendedAfterMuscles: <String>['Legs'],
      estimatedMinutes: 2,
      poses: <AsanaPose>[
        AsanaPose(
          name: 'Bilateral Stretch',
          sanskritName: 'Bilateral Asana',
          holdSeconds: 30,
          isBilateral: true,
          targetMuscles: 'Hamstrings',
          cues: 'Keep spine flat',
          breathingPattern: 'Inhale 4s, exhale 4s',
        ),
        AsanaPose(
          name: 'Single Pose',
          sanskritName: 'Single Asana',
          holdSeconds: 45,
          targetMuscles: 'Back',
          cues: 'Deep breathing',
          breathingPattern: '4-4 breath',
        ),
      ],
    );

    test('initializes with first pose duration and uncompleted state', () {
      final YogaTimerController ctrl = YogaTimerController(
        routine: testRoutine,
      );

      expect(ctrl.poseIndex, 0);
      expect(ctrl.isLeftActive, isFalse);
      expect(ctrl.secondsRemaining, 30);
      expect(ctrl.isCompleted, isFalse);
      ctrl.dispose();
    });

    test(
      'advancePose transitions bilateral pose to left side before advancing',
      () {
        final YogaTimerController ctrl = YogaTimerController(
          routine: testRoutine,
        );

        // First advance switches to left side
        ctrl.advancePose();
        expect(ctrl.poseIndex, 0);
        expect(ctrl.isLeftActive, isTrue);
        expect(ctrl.secondsRemaining, 30);

        // Second advance moves to next pose
        ctrl.advancePose();
        expect(ctrl.poseIndex, 1);
        expect(ctrl.isLeftActive, isFalse);
        expect(ctrl.secondsRemaining, 45);

        // Third advance marks complete
        ctrl.advancePose();
        expect(ctrl.isCompleted, isTrue);
        ctrl.dispose();
      },
    );
  });
}
