import 'package:flutter/material.dart';

import '../../../data/models/models.dart';
import '../bloc/exercises_state.dart';
import 'exercise_list_tile.dart';

/// Scrollable list rendering exercises or empty/loading placeholders.
class ExerciseListView extends StatelessWidget {
  const ExerciseListView({
    required this.state,
    required this.onExerciseTapped,
    super.key,
  });

  final ExercisesState state;
  final void Function(Exercise exercise) onExerciseTapped;

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      ExercisesLoading() => const Center(child: CircularProgressIndicator()),
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
                    onTap: () => onExerciseTapped(ex),
                  );
                },
              ),
      ExercisesError(message: final String msg) => Center(child: Text(msg)),
      _ => const SizedBox.shrink(),
    };
  }
}
