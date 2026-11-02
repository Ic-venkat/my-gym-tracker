import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/asana_pose.dart';
import '../models/yoga_routine.dart';

/// Lightweight state controller managing active yoga hold durations and side transitions.
class YogaTimerController extends ChangeNotifier {
  YogaTimerController({required this.routine}) {
    _secondsRemaining = currentPose.holdSeconds;
    _startTimer();
  }

  final YogaRoutine routine;
  int poseIndex = 0;
  bool isLeftActive = false;
  int _secondsRemaining = 0;
  Timer? _timer;

  int get secondsRemaining => _secondsRemaining;
  AsanaPose get currentPose => routine.poses[poseIndex];
  bool get isCompleted => poseIndex >= routine.poses.length;

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (_secondsRemaining > 1) {
        _secondsRemaining--;
        notifyListeners();
      } else {
        advancePose();
      }
    });
  }

  /// Manually or automatically advances to the next side or next asana posture.
  void advancePose() {
    if (currentPose.isBilateral && !isLeftActive) {
      isLeftActive = true;
      _secondsRemaining = currentPose.holdSeconds;
    } else if (poseIndex + 1 < routine.poses.length) {
      poseIndex++;
      isLeftActive = false;
      _secondsRemaining = currentPose.holdSeconds;
    } else {
      _timer?.cancel();
      poseIndex = routine.poses.length;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
