import 'package:equatable/equatable.dart';

/// Single milestone tier within a calisthenics skill ladder.
class CalisthenicsStep extends Equatable {
  const CalisthenicsStep({
    required this.step,
    required this.exerciseId,
    required this.name,
    required this.targetSets,
    required this.targetReps,
    required this.formCues,
    this.isHoldSeconds = false,
  });

  /// Step index (1-based: Tier 1, Tier 2, etc.).
  final int step;

  /// Identifier matching exercise catalog.
  final String exerciseId;

  /// Human-readable exercise name.
  final String name;

  /// Target sets required for graduation.
  final int targetSets;

  /// Target repetitions or hold duration in seconds.
  final int targetReps;

  /// Whether target represents isometric duration in seconds instead of dynamic reps.
  final bool isHoldSeconds;

  /// Key posture cue for strict form compliance.
  final String formCues;

  @override
  List<Object?> get props => <Object?>[
    step,
    exerciseId,
    name,
    targetSets,
    targetReps,
    isHoldSeconds,
    formCues,
  ];
}
