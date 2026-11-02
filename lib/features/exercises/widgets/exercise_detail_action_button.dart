import 'package:flutter/material.dart';

/// Primary action button for starting a workout or logging a set from detail sheet.
class ExerciseDetailActionButton extends StatelessWidget {
  const ExerciseDetailActionButton({
    required this.exerciseName,
    required this.isActiveWorkout,
    required this.onPressed,
    super.key,
  });

  final String exerciseName;
  final bool isActiveWorkout;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF10B981),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: onPressed,
      icon: Icon(isActiveWorkout ? Icons.add_task : Icons.play_arrow),
      label: Text(
        isActiveWorkout
            ? 'Log Set for $exerciseName'
            : 'Start Workout with this Exercise',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
    );
  }
}
