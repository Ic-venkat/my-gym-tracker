import 'package:flutter/material.dart';

import '../../../data/models/models.dart';
import 'exercise_category_filters.dart';
import 'exercise_picker_filter.dart';
import 'exercise_picker_header.dart';
import 'exercise_picker_list.dart';

/// Modal bottom sheet allowing users to manually search and select an exercise.
class ExercisePickerSheet extends StatefulWidget {
  const ExercisePickerSheet({
    required this.availableExercises,
    required this.onSelected,
    super.key,
  });

  final List<Exercise> availableExercises;
  final ValueChanged<Exercise> onSelected;

  static Future<void> show(
    BuildContext context, {
    required List<Exercise> availableExercises,
    required ValueChanged<Exercise> onSelected,
  }) => showExercisePickerModal(
    context,
    availableExercises: availableExercises,
    onSelected: onSelected,
  );

  @override
  State<ExercisePickerSheet> createState() => _ExercisePickerSheetState();
}

class _ExercisePickerSheetState extends State<ExercisePickerSheet> {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final List<Exercise> filtered = filterExercises(
      widget.availableExercises,
      _selectedCategory,
      _searchQuery,
    );
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (BuildContext _, ScrollController scrollController) {
        return Column(
          children: <Widget>[
            ExercisePickerHeader(
              onSearchChanged: (String val) =>
                  setState(() => _searchQuery = val),
            ),
            ExerciseCategoryFilters(
              selectedCategory: _selectedCategory,
              onCategorySelected: (String cat) =>
                  setState(() => _selectedCategory = cat),
            ),
            const Divider(height: 1, color: Color(0xFF334155)),
            Expanded(
              child: ExercisePickerList(
                exercises: filtered,
                scrollController: scrollController,
                onSelected: widget.onSelected,
              ),
            ),
          ],
        );
      },
    );
  }
}
