import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';

/// Horizontal list of chips for filtering exercises by muscle group.
class CategoryFilterChips extends StatelessWidget {
  const CategoryFilterChips({
    required this.selectedCategory,
    required this.onSelected,
    super.key,
  });

  final String selectedCategory;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final List<String> categories = <String>[
      'All',
      ...AppConstants.muscleGroups,
    ];

    return SizedBox(
      height: 48,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (BuildContext _, int _) => const SizedBox(width: 8),
        itemBuilder: (BuildContext context, int index) {
          final String cat = categories[index];
          final bool isSelected = cat == selectedCategory;
          return FilterChip(
            label: Text(cat),
            selected: isSelected,
            onSelected: (_) => onSelected(cat),
            selectedColor: const Color(0xFF10B981),
            labelStyle: TextStyle(
              color: isSelected ? Colors.black : Colors.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          );
        },
      ),
    );
  }
}
