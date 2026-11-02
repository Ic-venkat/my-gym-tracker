import 'package:flutter/material.dart';

import '../../../data/models/models.dart';
import 'exercise_picker_sheet.dart';

/// Filters exercises by selected muscle category and text search query.
List<Exercise> filterExercises(
  List<Exercise> exercises,
  String selectedCategory,
  String searchQuery,
) {
  final String query = searchQuery.trim().toLowerCase();
  return exercises.where((Exercise ex) {
    final bool matchesCat =
        selectedCategory == 'All' || ex.muscleGroup == selectedCategory;
    final bool matchesSearch =
        query.isEmpty ||
        ex.name.toLowerCase().contains(query) ||
        ex.muscleGroup.toLowerCase().contains(query);
    return matchesCat && matchesSearch;
  }).toList();
}

/// Displays the exercise picker in a bottom sheet modal.
Future<void> showExercisePickerModal(
  BuildContext context, {
  required List<Exercise> availableExercises,
  required ValueChanged<Exercise> onSelected,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0xFF0F172A),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => ExercisePickerSheet(
      availableExercises: availableExercises,
      onSelected: onSelected,
    ),
  );
}
