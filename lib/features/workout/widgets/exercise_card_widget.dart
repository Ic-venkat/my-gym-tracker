import 'package:flutter/material.dart';

import '../../../data/models/models.dart';
import 'exercise_card_header.dart';
import 'set_row_widget.dart';

/// Card showing an exercise, all its logged sets, and a quick set add button.
class ExerciseCardWidget extends StatelessWidget {
  const ExerciseCardWidget({
    required this.exercise,
    required this.sets,
    super.key,
  });

  final Exercise exercise;
  final List<WorkoutSet> sets;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ExerciseCardHeader(exercise: exercise),
            const Divider(color: Color(0xFF334155), height: 16),
            ...sets.map(
              (WorkoutSet s) =>
                  SetRowWidget(key: ValueKey<String>(s.id), set: s),
            ),
          ],
        ),
      ),
    );
  }
}
