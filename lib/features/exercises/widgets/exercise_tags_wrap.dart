import 'package:flutter/material.dart';

import '../../../data/models/models.dart';
import 'biomechanic_tag_chip.dart';

/// Wraps exercise tags (muscle, mechanics, category, difficulty) into chips.
class ExerciseTagsWrap extends StatelessWidget {
  const ExerciseTagsWrap({required this.exercise, super.key});

  final Exercise exercise;

  static String formatTag(String raw) {
    return raw
        .replaceAll('_', ' ')
        .split(' ')
        .map((String w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1))
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: <Widget>[
        BiomechanicTagChip(
          label: exercise.muscleGroup,
          color: const Color(0xFF10B981),
        ),
        BiomechanicTagChip(
          label: exercise.category,
          color: const Color(0xFF38BDF8),
        ),
        BiomechanicTagChip(
          label: formatTag(exercise.mechanics),
          color: const Color(0xFFA855F7),
        ),
        BiomechanicTagChip(
          label: formatTag(exercise.difficulty),
          color: const Color(0xFFF59E0B),
        ),
        BiomechanicTagChip(
          label: formatTag(exercise.movementPattern),
          color: const Color(0xFF64748B),
        ),
      ],
    );
  }
}
