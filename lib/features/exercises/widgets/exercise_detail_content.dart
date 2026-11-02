import 'package:flutter/material.dart';

import '../../../data/models/models.dart';
import 'exercise_biomechanics_card.dart';
import 'exercise_cues_card.dart';
import 'exercise_detail_action_button.dart';
import 'exercise_video_preview.dart';

/// Scrollable body for exercise detail sheet displaying video, cues, and action button.
class ExerciseDetailContent extends StatelessWidget {
  const ExerciseDetailContent({
    required this.exercise,
    required this.isActive,
    required this.onAction,
    this.scrollController,
    super.key,
  });

  final Exercise exercise;
  final bool isActive;
  final VoidCallback onAction;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(20),
      children: <Widget>[
        ExerciseVideoPreview(exercise: exercise),
        const SizedBox(height: 12),
        ExerciseBiomechanicsCard(exercise: exercise),
        const SizedBox(height: 16),
        ExerciseCuesCard(exercise: exercise),
        const SizedBox(height: 24),
        ExerciseDetailActionButton(
          exerciseName: exercise.name,
          isActiveWorkout: isActive,
          onPressed: onAction,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
