import 'package:flutter/material.dart';

import '../models/yoga_routine.dart';
import '../services/yoga_timer_controller.dart';
import 'yoga_pose_display.dart';

/// Body content displaying active posture cues, hold seconds, and advance button.
class YogaTimerBody extends StatelessWidget {
  const YogaTimerBody({required this.ctrl, required this.routine, super.key});

  final YogaTimerController ctrl;
  final YogaRoutine routine;

  @override
  Widget build(BuildContext context) {
    final bool isSwitch = ctrl.currentPose.isBilateral && !ctrl.isLeftActive;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        YogaPoseDisplay(
          pose: ctrl.currentPose,
          poseIndex: ctrl.poseIndex,
          totalPoses: routine.poses.length,
          isLeftActive: ctrl.isLeftActive,
        ),
        const SizedBox(height: 16),
        Text(
          '${ctrl.secondsRemaining}s',
          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: ctrl.advancePose,
          icon: const Icon(Icons.skip_next),
          label: Text(isSwitch ? 'Switch to Left Side' : 'Next Pose'),
        ),
      ],
    );
  }
}
