import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';

/// Horizontal scrolling category chips for exercise filtering.
class ExerciseCategoryFilters extends StatelessWidget {
  const ExerciseCategoryFilters({
    required this.selectedCategory,
    required this.onCategorySelected,
    super.key,
  });

  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    final List<String> categories = <String>[
      'All',
      ...AppConstants.muscleGroups,
    ];
    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (BuildContext _, int index) {
          final String cat = categories[index];
          final bool isSelected = cat == selectedCategory;
          return ChoiceChip(
            key: ValueKey<String>(cat),
            label: Text(cat),
            selected: isSelected,
            onSelected: (_) => onCategorySelected(cat),
            selectedColor: const Color(0xFF10B981),
            labelStyle: TextStyle(
              color: isSelected ? Colors.black : Colors.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 12,
            ),
          );
        },
      ),
    );
  }
}
