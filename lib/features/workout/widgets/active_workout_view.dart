import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/models.dart';
import '../bloc/workout_bloc.dart';
import '../bloc/workout_event.dart';
import '../bloc/workout_state.dart';
import 'active_workout_set_list.dart';
import 'add_set_dialog.dart';
import 'exercise_picker_sheet.dart';

/// Active workout session view displaying ongoing sets and rest banner.
class ActiveWorkoutView extends StatelessWidget {
  const ActiveWorkoutView({required this.state, super.key});

  final ActiveWorkoutState state;

  void _openExercisePicker(BuildContext context) {
    ExercisePickerSheet.show(
      context,
      availableExercises: state.exercises.values.toList(),
      onSelected: (Exercise ex) {
        showDialog<void>(
          context: context,
          builder: (_) => AddSetDialog(
            exerciseName: ex.name,
            onLog: (int reps, double weight) => context.read<WorkoutBloc>().add(
              LogSetEvent(exerciseId: ex.id, reps: reps, weight: weight),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, List<WorkoutSet>> grouped = <String, List<WorkoutSet>>{};
    for (final WorkoutSet s in state.sets) {
      grouped.putIfAbsent(s.exerciseId, () => <WorkoutSet>[]).add(s);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(state.workout.title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Add Exercise',
            onPressed: () => _openExercisePicker(context),
          ),
          TextButton.icon(
            onPressed: () =>
                context.read<WorkoutBloc>().add(const FinishWorkoutEvent()),
            icon: const Icon(Icons.check_circle, color: Color(0xFF10B981)),
            label: const Text(
              'Finish',
              style: TextStyle(
                color: Color(0xFF10B981),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: ActiveWorkoutSetList(state: state, groupedSets: grouped),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openExercisePicker(context),
        backgroundColor: const Color(0xFF10B981),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Exercise',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
