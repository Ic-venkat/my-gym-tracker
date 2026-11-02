import 'package:flutter/material.dart';

import '../../../data/models/models.dart';
import 'exercise_stats_row.dart';
import 'exercise_tags_wrap.dart';

/// Card showing structured biomechanical tags, rep ranges, and equipment.
class ExerciseBiomechanicsCard extends StatelessWidget {
  const ExerciseBiomechanicsCard({required this.exercise, super.key});

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ExerciseTagsWrap(exercise: exercise),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFF334155)),
          const SizedBox(height: 12),
          ExerciseStatsRow(
            repRange: exercise.targetRepRange,
            restSeconds: exercise.defaultRestSeconds,
            incrementKg: exercise.minIncrementKg,
          ),
          if (exercise.secondaryMuscles != null &&
              exercise.secondaryMuscles!.isNotEmpty) ...<Widget>[
            const SizedBox(height: 10),
            Text(
              'Secondary: ${exercise.secondaryMuscles!}',
              style: const TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
