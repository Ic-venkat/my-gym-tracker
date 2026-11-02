import 'package:flutter/material.dart';

import '../../../data/models/models.dart';
import '../../exercises/widgets/exercise_detail_sheet.dart';

/// List of filtered exercises with preview and selection handlers.
class ExercisePickerList extends StatelessWidget {
  const ExercisePickerList({
    required this.exercises,
    required this.scrollController,
    required this.onSelected,
    super.key,
  });

  final List<Exercise> exercises;
  final ScrollController scrollController;
  final ValueChanged<Exercise> onSelected;

  @override
  Widget build(BuildContext context) {
    if (exercises.isEmpty) {
      return const Center(
        child: Text(
          'No exercises match your search',
          style: TextStyle(color: Color(0xFF94A3B8)),
        ),
      );
    }

    return ListView.builder(
      controller: scrollController,
      itemCount: exercises.length,
      itemBuilder: (BuildContext ctx, int index) {
        final Exercise ex = exercises[index];
        return ListTile(
          title: Text(
            ex.name,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            '${ex.muscleGroup} • ${ex.category}',
            style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
          ),
          trailing: IconButton(
            icon: const Icon(
              Icons.info_outline,
              size: 18,
              color: Color(0xFF38BDF8),
            ),
            tooltip: 'Preview Form & Video',
            onPressed: () => ExerciseDetailSheet.show(ctx, ex),
          ),
          onTap: () {
            Navigator.of(ctx).pop();
            onSelected(ex);
          },
        );
      },
    );
  }
}
