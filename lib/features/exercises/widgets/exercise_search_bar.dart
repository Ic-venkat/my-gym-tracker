import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/exercises_bloc.dart';
import '../bloc/exercises_event.dart';

/// Search input bar for exercise filtering.
class ExerciseSearchBar extends StatelessWidget {
  const ExerciseSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}
