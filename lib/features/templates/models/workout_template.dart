import 'package:equatable/equatable.dart';

import 'template_exercise.dart';

/// Pre-designed training session template with science-based exercise sequencing.
class WorkoutTemplate extends Equatable {
  const WorkoutTemplate({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.estimatedMinutes,
    required this.exercises,
  });

  /// Unique template ID.
  final String id;

  /// Routine name (e.g. 'Push Day (Hypertrophy)').
  final String name;

  /// Category tag ('PPL', 'Upper/Lower', 'Calisthenics', 'Mobility').
  final String category;

  /// Overview of training stimulus.
  final String description;

  /// Estimated session duration in minutes.
  final int estimatedMinutes;

  /// Prescribed sequence of exercises.
  final List<TemplateExercise> exercises;

  @override
  List<Object?> get props => <Object?>[
    id,
    name,
    category,
    description,
    estimatedMinutes,
    exercises,
  ];
}
