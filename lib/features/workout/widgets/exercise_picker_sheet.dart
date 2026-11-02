import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/models.dart';
import '../../exercises/widgets/exercise_detail_sheet.dart';

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

  @override
  State<ExercisePickerSheet> createState() => _ExercisePickerSheetState();
}

class _ExercisePickerSheetState extends State<ExercisePickerSheet> {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  List<Exercise> get _filteredExercises {
    return widget.availableExercises.where((Exercise ex) {
      final bool matchesCat =
          _selectedCategory == 'All' || ex.muscleGroup == _selectedCategory;
      final bool matchesSearch =
          _searchQuery.isEmpty ||
          ex.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          ex.muscleGroup.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCat && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (BuildContext _, ScrollController scrollController) {
        return Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF475569),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: <Widget>[
                  const Expanded(
                    child: Text(
                      'Select Exercise',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search 45+ exercises...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  filled: true,
                  fillColor: const Color(0xFF1E293B),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (String val) =>
                    setState(() => _searchQuery = val.trim()),
              ),
            ),
            _buildCategoryFilters(),
            const Divider(height: 1, color: Color(0xFF334155)),
            Expanded(child: _buildExerciseList(scrollController)),
          ],
        );
      },
    );
  }

  Widget _buildCategoryFilters() {
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
          final bool isSelected = cat == _selectedCategory;
          return ChoiceChip(
            label: Text(cat),
            selected: isSelected,
            onSelected: (_) => setState(() => _selectedCategory = cat),
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

  Widget _buildExerciseList(ScrollController scrollController) {
    final List<Exercise> list = _filteredExercises;
    if (list.isEmpty) {
      return const Center(
        child: Text(
          'No exercises match your search',
          style: TextStyle(color: Color(0xFF94A3B8)),
        ),
      );
    }

    return ListView.builder(
      controller: scrollController,
      itemCount: list.length,
      itemBuilder: (BuildContext context, int index) {
        final Exercise ex = list[index];
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
            onPressed: () => ExerciseDetailSheet.show(context, ex),
          ),
          onTap: () {
            Navigator.of(context).pop();
            widget.onSelected(ex);
          },
        );
      },
    );
  }
}
