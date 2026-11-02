import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/models.dart';
import '../../exercises/widgets/exercise_detail_sheet.dart';
import '../bloc/workout_bloc.dart';
import '../bloc/workout_event.dart';
import 'add_set_dialog.dart';

/// Header for ExerciseCardWidget containing exercise name, info button, and add set button.
class ExerciseCardHeader extends StatelessWidget {
  const ExerciseCardHeader({required this.exercise, super.key});

  final Exercise exercise;

  void _showAddSetDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => AddSetDialog(
        exerciseName: exercise.name,
        onLog: (int reps, double weight) => context.read<WorkoutBloc>().add(
          LogSetEvent(exerciseId: exercise.id, reps: reps, weight: weight),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Text(
            exercise.name,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.info_outline,
            size: 18,
            color: Color(0xFF94A3B8),
          ),
          tooltip: 'Form Guide',
          onPressed: () => ExerciseDetailSheet.show(context, exercise),
        ),
        TextButton.icon(
          onPressed: () => _showAddSetDialog(context),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Set'),
        ),
      ],
    );
  }
}
