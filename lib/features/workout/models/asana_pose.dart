import 'package:equatable/equatable.dart';

/// Single yoga posture or mobility stretch with execution details and breath cues.
class AsanaPose extends Equatable {
  const AsanaPose({
    required this.name,
    required this.sanskritName,
    required this.holdSeconds,
    required this.targetMuscles,
    required this.cues,
    required this.breathingPattern,
    this.isBilateral = false,
  });

  /// English / common posture name.
  final String name;

  /// Traditional Sanskrit asana name.
  final String sanskritName;

  /// Recommended hold duration in seconds per side.
  final int holdSeconds;

  /// Whether posture requires separate left-side and right-side holds.
  final bool isBilateral;

  /// Targeted anatomical tissues and joints.
  final String targetMuscles;

  /// Postural alignment cues.
  final String cues;

  /// Recommended breath pacing cadence.
  final String breathingPattern;

  @override
  List<Object?> get props => <Object?>[
    name,
    sanskritName,
    holdSeconds,
    isBilateral,
    targetMuscles,
    cues,
    breathingPattern,
  ];
}
