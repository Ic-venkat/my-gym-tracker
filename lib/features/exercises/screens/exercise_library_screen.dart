import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/models.dart';
import '../bloc/exercises_bloc.dart';
import '../bloc/exercises_event.dart';
import '../bloc/exercises_state.dart';
import '../widgets/category_filter_chips.dart';
import '../widgets/exercise_list_view.dart';
import '../widgets/exercise_search_bar.dart';
import '../widgets/exercise_selection_handler.dart';

/// Screen allowing browsing, searching, and filtering of all gym exercises.
class ExerciseLibraryScreen extends StatelessWidget {
  const ExerciseLibraryScreen({super.key});

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
                      handleExerciseTapped(context, ex),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
