import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/database/app_database.dart';
import '../../workout/bloc/workout_bloc.dart';
import '../../workout/bloc/workout_event.dart';
import '../../workout/bloc/workout_state.dart';
import '../../workout/widgets/add_set_dialog.dart';
import '../bloc/exercises_bloc.dart';
import '../bloc/exercises_event.dart';
import '../bloc/exercises_state.dart';
import '../widgets/category_filter_chips.dart';
import '../widgets/exercise_list_tile.dart';

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
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search exercises...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (String val) {
                context.read<ExercisesBloc>().add(SearchExercises(val));
              },
            ),
          ),
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
                return switch (state) {
                  ExercisesLoading() => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  ExercisesLoaded(exercises: final List<Exercise> list) =>
                    list.isEmpty
                        ? const Center(child: Text('No exercises found.'))
                        : ListView.builder(
                            itemCount: list.length,
                            itemBuilder: (BuildContext context, int index) {
                              final Exercise ex = list[index];
                              return ExerciseListTile(
                                key: ValueKey<String>(ex.id),
                                exercise: ex,
                                onTap: () => _onExerciseTapped(context, ex),
                              );
                            },
                          ),
                  ExercisesError(message: final String msg) => Center(
                    child: Text(msg),
                  ),
                  _ => const SizedBox.shrink(),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}
