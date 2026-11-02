import 'package:flutter/material.dart';

import '../../../data/models/models.dart';
import 'exercise_stats_row.dart';

/// Card showing structured biomechanical tags, rep ranges, and equipment.
class ExerciseBiomechanicsCard extends StatelessWidget {
  const ExerciseBiomechanicsCard({required this.exercise, super.key});

  final Exercise exercise;

  String _formatTag(String raw) {
    return raw
        .replaceAll('_', ' ')
        .split(' ')
        .map((String word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1);
        })
        .join(' ');
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

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
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              _buildChip(exercise.muscleGroup, const Color(0xFF10B981)),
              _buildChip(exercise.category, const Color(0xFF38BDF8)),
              _buildChip(
                _formatTag(exercise.mechanics),
                const Color(0xFFA855F7),
              ),
              _buildChip(
                _formatTag(exercise.difficulty),
                const Color(0xFFF59E0B),
              ),
              _buildChip(
                _formatTag(exercise.movementPattern),
                const Color(0xFF64748B),
              ),
            ],
          ),
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
