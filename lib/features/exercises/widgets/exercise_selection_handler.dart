import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/models.dart';
import '../../workout/bloc/workout_bloc.dart';
import '../../workout/bloc/workout_event.dart';
import '../../workout/bloc/workout_state.dart';
import '../../workout/widgets/add_set_dialog.dart';

/// Handles user tapping an exercise in the catalog to log sets or inform state.
void handleExerciseTapped(BuildContext context, Exercise exercise) {
  final WorkoutState workoutState = context.read<WorkoutBloc>().state;
  if (workoutState is! ActiveWorkoutState) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${exercise.name} selected. Start a workout to log sets!',
        ),
      ),
    );
    return;
  }

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
