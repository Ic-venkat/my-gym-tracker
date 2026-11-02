import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/database/app_database.dart';
import '../bloc/workout_bloc.dart';
import '../bloc/workout_event.dart';
import 'add_set_dialog.dart';
import 'set_row_widget.dart';

/// Card showing an exercise, all its logged sets, and a quick set add button.
class ExerciseCardWidget extends StatelessWidget {
  const ExerciseCardWidget({
    required this.exercise,
    required this.sets,
    super.key,
  });

  final Exercise exercise;
  final List<WorkoutSet> sets;

  void _showAddSetDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => AddSetDialog(
        exerciseName: exercise.name,
        onLog: (int reps, double weight) {
          context.read<WorkoutBloc>().add(
            LogSetEvent(exerciseId: exercise.id, reps: reps, weight: weight),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    exercise.name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _showAddSetDialog(context),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Set'),
                ),
              ],
            ),
            const Divider(color: Color(0xFF334155), height: 16),
            ...sets.map(
              (WorkoutSet s) =>
                  SetRowWidget(key: ValueKey<String>(s.id), set: s),
            ),
          ],
        ),
      ),
    );
  }
}
