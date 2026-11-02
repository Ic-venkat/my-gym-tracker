import 'package:flutter/material.dart';

import '../../../data/models/models.dart';

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
          _buildSection(
            title: 'Posture & Execution Cues',
            content: cues,
            icon: Icons.check_circle_outline,
            accentColor: const Color(0xFF10B981),
          ),
          const SizedBox(height: 12),
        ],
        if (mistakes != null && mistakes.isNotEmpty) ...<Widget>[
          _buildSection(
            title: 'Common Mistakes to Avoid',
            content: mistakes,
            icon: Icons.warning_amber_rounded,
            accentColor: const Color(0xFFF59E0B),
          ),
        ],
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    required IconData icon,
    required Color accentColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: accentColor.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(icon, size: 16, color: accentColor),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  color: accentColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: const TextStyle(
              fontSize: 13,
              height: 1.4,
              color: Color(0xFFE2E8F0),
            ),
          ),
        ],
      ),
    );
  }
}

