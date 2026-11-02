import 'package:flutter/material.dart';

import '../../../data/models/models.dart';
import 'exercise_detail_sheet.dart';

/// Handles user tapping an exercise in the catalog to inspect posture and form.
void handleExerciseTapped(BuildContext context, Exercise exercise) {
  ExerciseDetailSheet.show(context, exercise);
}
