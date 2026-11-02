import 'package:flutter/material.dart';

import '../../../data/models/models.dart';
import 'cue_section_card.dart';

/// Card showing form cues and injury prevention mistakes.
class ExerciseCuesCard extends StatelessWidget {
  const ExerciseCuesCard({required this.exercise, super.key});

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    final String? cues = exercise.formCues;
    final String? mistakes = exercise.commonMistakes;

    if ((cues == null || cues.isEmpty) &&
        (mistakes == null || mistakes.isEmpty)) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (cues != null && cues.isNotEmpty) ...<Widget>[
          CueSectionCard(
            title: 'Posture & Execution Cues',
            content: cues,
            icon: Icons.check_circle_outline,
            accentColor: const Color(0xFF10B981),
          ),
          const SizedBox(height: 12),
        ],
        if (mistakes != null && mistakes.isNotEmpty) ...<Widget>[
          CueSectionCard(
            title: 'Common Mistakes to Avoid',
            content: mistakes,
            icon: Icons.warning_amber_rounded,
            accentColor: const Color(0xFFF59E0B),
          ),
        ],
      ],
    );
  }
}
