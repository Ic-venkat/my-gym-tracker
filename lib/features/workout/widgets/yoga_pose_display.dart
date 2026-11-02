import 'package:flutter/material.dart';

import '../models/asana_pose.dart';

/// Informational display presenting active yoga posture names, cues, and muscle targets.
class YogaPoseDisplay extends StatelessWidget {
  const YogaPoseDisplay({
    required this.pose,
    required this.poseIndex,
    required this.totalPoses,
    required this.isLeftActive,
    super.key,
  });

  final AsanaPose pose;
  final int poseIndex;
  final int totalPoses;
  final bool isLeftActive;

  @override
  Widget build(BuildContext context) {
    final String sideLabel = pose.isBilateral
        ? ' • ${isLeftActive ? 'Left Side' : 'Right Side'}'
        : '';

    return Column(
      children: <Widget>[
        Text(
          'Pose ${poseIndex + 1} of $totalPoses$sideLabel',
          style: const TextStyle(
            color: Color(0xFF10B981),
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          pose.name,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        Text(
          pose.sanskritName,
          style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: <Widget>[
              Text(
                'Breath: ${pose.breathingPattern}',
                style: const TextStyle(
                  color: Color(0xFF38BDF8),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                pose.cues,
                style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
