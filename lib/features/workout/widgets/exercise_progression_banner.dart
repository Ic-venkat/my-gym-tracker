import 'package:flutter/material.dart';

import '../../../data/models/models.dart';
import '../models/progression_recommendation.dart';
import '../services/progressive_overload_service.dart';
import 'progression_pill_badge.dart';

/// Banner displaying real-time progressive overload coaching cues on exercise cards.
class ExerciseProgressionBanner extends StatelessWidget {
  const ExerciseProgressionBanner({
    required this.exercise,
    required this.sets,
    super.key,
  });

  final Exercise exercise;
  final List<WorkoutSet> sets;

  @override
  Widget build(BuildContext context) {
    if (sets.isEmpty) return const SizedBox.shrink();

    final CalisthenicsProgressionRecommendation? cali =
        ProgressiveOverloadService.evaluateCalisthenicsProgression(
          exerciseIdentifier: exercise.id,
          recentSets: sets,
        );

    if (cali != null) {
      return ProgressionPillBadge(
        icon: Icons.emoji_events_outlined,
        color: const Color(0xFFA855F7),
        text: 'Benchmark Met! Level up to ${cali.nextExerciseName}',
      );
    }

    final ProgressionRecommendation rec =
        ProgressiveOverloadService.evaluateDoubleProgression(
          exerciseName: exercise.name,
          targetRepRange: exercise.targetRepRange,
          minIncrementKg: exercise.minIncrementKg,
          sessionHistory: <List<WorkoutSet>>[sets],
        );

    return switch (rec) {
      final WeightIncreaseRecommendation w => ProgressionPillBadge(
        icon: Icons.trending_up,
        color: const Color(0xFF10B981),
        text:
            'Target reached! Next load: +${exercise.minIncrementKg} kg (${w.suggestedWeight} kg)',
      ),
      final MaintainAndRepProgression m => ProgressionPillBadge(
        icon: Icons.fitness_center,
        color: const Color(0xFF38BDF8),
        text:
            'Working load: ${m.currentWeight} kg • Target: ${m.targetReps} reps',
      ),
      final DeloadRecommendation d => ProgressionPillBadge(
        icon: Icons.battery_charging_full,
        color: const Color(0xFFF59E0B),
        text: 'Plateau: Deload recommended (${d.deloadWeight} kg)',
      ),
      _ => const SizedBox.shrink(),
    };
  }
}
