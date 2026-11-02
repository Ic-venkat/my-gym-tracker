import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/models.dart';
import '../../workout/bloc/workout_bloc.dart';
import '../../workout/bloc/workout_event.dart';
import '../../workout/bloc/workout_state.dart';
import '../../workout/widgets/add_set_dialog.dart';
import '../bloc/exercises_bloc.dart';
import '../bloc/exercises_event.dart';
import '../bloc/exercises_state.dart';
import '../widgets/category_filter_chips.dart';
import '../widgets/exercise_list_view.dart';
import '../widgets/exercise_search_bar.dart';

/// Screen allowing browsing, searching, and filtering of all gym exercises.
class ExerciseLibraryScreen extends StatelessWidget {
  const ExerciseLibraryScreen({super.key});

  void _onExerciseTapped(BuildContext context, Exercise exercise) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exercise Library')),
      body: Column(
        children: <Widget>[
          const ExerciseSearchBar(),
          BlocBuilder<ExercisesBloc, ExercisesState>(
            builder: (BuildContext context, ExercisesState state) {
              final String selected = state is ExercisesLoaded
                  ? state.selectedCategory
                  : 'All';
              return CategoryFilterChips(
                selectedCategory: selected,
                onSelected: (String cat) {
                  context.read<ExercisesBloc>().add(
                    LoadExercises(category: cat),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 12),
          Expanded(
            child: BlocBuilder<ExercisesBloc, ExercisesState>(
              builder: (BuildContext context, ExercisesState state) {
                return ExerciseListView(
                  state: state,
                  onExerciseTapped: (Exercise ex) =>
                      _onExerciseTapped(context, ex),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
