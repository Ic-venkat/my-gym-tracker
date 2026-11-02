import 'package:equatable/equatable.dart';

/// Pre-configured exercise specification within a structured workout template.
class TemplateExercise extends Equatable {
  const TemplateExercise({
    required this.exerciseId,
    required this.exerciseName,
    required this.targetSets,
    required this.targetRepRange,
    required this.targetRestSeconds,
    this.notes,
  });

  /// Exercise identifier matching catalog.
  final String exerciseId;

  /// Display name of the exercise.
  final String exerciseName;

  /// Prescribed working sets.
  final int targetSets;

  /// Prescribed repetition window (e.g. '8-12').
  final String targetRepRange;

  /// Target rest interval in seconds.
  final int targetRestSeconds;

  /// Optional tactical cues or tempo guidance.
  final String? notes;

  @override
  List<Object?> get props => <Object?>[
    exerciseId,
    exerciseName,
    targetSets,
    targetRepRange,
    targetRestSeconds,
    notes,
  ];
}
