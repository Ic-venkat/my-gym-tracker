import 'package:equatable/equatable.dart';

/// Base class for all intelligent progression recommendations.
sealed class ProgressionRecommendation extends Equatable {
  const ProgressionRecommendation({
    required this.exerciseName,
    required this.reason,
  });

  /// The exercise this recommendation applies to.
  final String exerciseName;

  /// Scientific or algorithmic rationale for this recommendation.
  final String reason;

  @override
  List<Object?> get props => <Object?>[exerciseName, reason];
}

/// Recommendation to increase load (micro-load) after achieving rep threshold.
final class WeightIncreaseRecommendation extends ProgressionRecommendation {
  const WeightIncreaseRecommendation({
    required super.exerciseName,
    required super.reason,
    required this.currentWeight,
    required this.suggestedWeight,
    required this.targetReps,
    required this.targetSets,
  });

  final double currentWeight;
  final double suggestedWeight;
  final int targetReps;
  final int targetSets;

  @override
  List<Object?> get props => <Object?>[
    ...super.props,
    currentWeight,
    suggestedWeight,
    targetReps,
    targetSets,
  ];
}

/// Recommendation to maintain weight and add repetitions.
final class MaintainAndRepProgression extends ProgressionRecommendation {
  const MaintainAndRepProgression({
    required super.exerciseName,
    required super.reason,
    required this.currentWeight,
    required this.targetReps,
    required this.targetSets,
  });

  final double currentWeight;
  final int targetReps;
  final int targetSets;

  @override
  List<Object?> get props => <Object?>[
    ...super.props,
    currentWeight,
    targetReps,
    targetSets,
  ];
}

/// Recommendation for a tactical deload session to clear systemic fatigue.
final class DeloadRecommendation extends ProgressionRecommendation {
  const DeloadRecommendation({
    required super.exerciseName,
    required super.reason,
    required this.currentWeight,
    required this.deloadWeight,
    required this.targetSets,
    required this.targetReps,
  });

  final double currentWeight;
  final double deloadWeight;
  final int targetSets;
  final int targetReps;

  @override
  List<Object?> get props => <Object?>[
    ...super.props,
    currentWeight,
    deloadWeight,
    targetSets,
    targetReps,
  ];
}

/// Recommendation to advance to the next bodyweight calisthenics skill tier.
final class CalisthenicsProgressionRecommendation
    extends ProgressionRecommendation {
  const CalisthenicsProgressionRecommendation({
    required super.exerciseName,
    required super.reason,
    required this.nextExerciseName,
    required this.ladderName,
    required this.currentStep,
    required this.nextStep,
  });

  final String nextExerciseName;
  final String ladderName;
  final int currentStep;
  final int nextStep;

  @override
  List<Object?> get props => <Object?>[
    ...super.props,
    nextExerciseName,
    ladderName,
    currentStep,
    nextStep,
  ];
}

/// Post-workout yoga & mobility recommendation tailored to targeted muscle groups.
final class YogaRecoveryRecommendation extends ProgressionRecommendation {
  const YogaRecoveryRecommendation({
    required super.exerciseName,
    required super.reason,
    required this.routineId,
    required this.routineName,
    required this.estimatedMinutes,
    required this.targetMuscles,
  });

  final String routineId;
  final String routineName;
  final int estimatedMinutes;
  final List<String> targetMuscles;

  @override
  List<Object?> get props => <Object?>[
    ...super.props,
    routineId,
    routineName,
    estimatedMinutes,
    targetMuscles,
  ];
}
