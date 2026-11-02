import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/models.dart';
import '../../workout/bloc/workout_bloc.dart';
import '../../workout/bloc/workout_event.dart';
import '../../workout/bloc/workout_state.dart';
import '../../workout/widgets/add_set_dialog.dart';

/// Handles button clicks from exercise detail sheet to start workout or log sets.
void handleDetailSheetAction(
  BuildContext context,
  Exercise exercise,
  VoidCallback? onSelect,
) {
  Navigator.of(context).pop();
  if (onSelect != null) {
    onSelect();
    return;
  }
  final WorkoutBloc bloc = context.read<WorkoutBloc>();
  if (bloc.state is ActiveWorkoutState) {
    showDialog<void>(
      context: context,
      builder: (_) => AddSetDialog(
        exerciseName: exercise.name,
        onLog: (int r, double w) =>
            bloc.add(LogSetEvent(exerciseId: exercise.id, reps: r, weight: w)),
      ),
    );
  } else {
    bloc.add(StartWorkoutEvent(title: exercise.muscleGroup));
  }
}
