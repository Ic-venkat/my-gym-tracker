import '../../../data/models/models.dart';
import '../models/calisthenics_ladder.dart';
import '../models/calisthenics_step.dart';
import '../models/progression_recommendation.dart';
import '../models/yoga_routine.dart';

/// Pure domain service calculating science-based progression recommendations.
class ProgressiveOverloadService {
  ProgressiveOverloadService._();

  /// Evaluates double progression for loaded resistance movements.
  static ProgressionRecommendation evaluateDoubleProgression({
    required String exerciseName,
    required String targetRepRange,
    required double minIncrementKg,
    required List<List<WorkoutSet>> sessionHistory,
  }) {
    if (sessionHistory.isEmpty) {
      return MaintainAndRepProgression(
        exerciseName: exerciseName,
        currentWeight: 0.0,
        targetReps: _parseBottomRep(targetRepRange),
        targetSets: 3,
        reason: 'Establish baseline strength at initial comfortable weight.',
      );
    }

    final List<WorkoutSet> latestSession = sessionHistory.first;
    if (latestSession.isEmpty) {
      return MaintainAndRepProgression(
        exerciseName: exerciseName,
        currentWeight: 0.0,
        targetReps: _parseBottomRep(targetRepRange),
        targetSets: 3,
        reason: 'No completed sets recorded in latest session.',
      );
    }

    final double currentWeight = latestSession.first.weight;
    final int topRep = _parseTopRep(targetRepRange);
    final int bottomRep = _parseBottomRep(targetRepRange);

    // 1. Check for Deload / Plateau (stalled for 3 consecutive sessions)
    if (_isStagnant(sessionHistory, 3)) {
      final double deloadWeight = _round(currentWeight * 0.90);
      return DeloadRecommendation(
        exerciseName: exerciseName,
        currentWeight: currentWeight,
        deloadWeight: deloadWeight,
        targetSets: (latestSession.length * 0.6).round().clamp(2, 4),
        targetReps: bottomRep,
        reason:
            'Performance plateau detected across 3 consecutive sessions. '
            'A 10% deload to $deloadWeight kg at reduced volume will dissipate systemic fatigue.',
      );
    }

    // 2. Check if all completed sets reached or exceeded top of target rep range
    final bool allHitTop = latestSession.every(
      (WorkoutSet s) => s.reps >= topRep,
    );

    if (allHitTop) {
      final double nextWeight = _round(currentWeight + minIncrementKg);
      return WeightIncreaseRecommendation(
        exerciseName: exerciseName,
        currentWeight: currentWeight,
        suggestedWeight: nextWeight,
        targetReps: bottomRep,
        targetSets: latestSession.length,
        reason:
            'Target rep ceiling ($topRep reps) achieved across all sets! '
            'Double progression triggers a +$minIncrementKg kg load increase to $nextWeight kg, resetting to $bottomRep reps.',
      );
    }

    // 3. Working within rep range: maintain weight and strive for rep progression
    final int minRepsInSession = latestSession
        .map((WorkoutSet s) => s.reps)
        .reduce((int a, int b) => a < b ? a : b);
    final int nextTargetRep = (minRepsInSession + 1).clamp(bottomRep, topRep);

    return MaintainAndRepProgression(
      exerciseName: exerciseName,
      currentWeight: currentWeight,
      targetReps: nextTargetRep,
      targetSets: latestSession.length,
      reason:
          'Maintain $currentWeight kg. Aim to add +1 rep to your lowest set '
          '(target $nextTargetRep reps) until all sets reach $topRep reps.',
    );
  }

  /// Evaluates bodyweight calisthenics skill advancement.
  static CalisthenicsProgressionRecommendation?
  evaluateCalisthenicsProgression({
    required String exerciseIdentifier,
    required List<WorkoutSet> recentSets,
  }) {
    if (recentSets.isEmpty) return null;

    for (final CalisthenicsLadder ladder in CalisthenicsLadder.allLadders) {
      final int? stepIdx = ladder.findStepIndex(exerciseIdentifier);
      if (stepIdx == null) continue;

      final CalisthenicsStep currentStep = ladder.steps[stepIdx];
      final bool hasNextStep = stepIdx + 1 < ladder.steps.length;
      if (!hasNextStep) return null;

      final CalisthenicsStep nextStep = ladder.steps[stepIdx + 1];

      // Check if user hit graduation criteria
      final int completedSets = recentSets
          .where((WorkoutSet s) => s.reps >= currentStep.targetReps)
          .length;

      if (completedSets >= currentStep.targetSets) {
        final String metric = currentStep.isHoldSeconds ? 's hold' : ' reps';
        return CalisthenicsProgressionRecommendation(
          exerciseName: currentStep.name,
          nextExerciseName: nextStep.name,
          ladderName: ladder.name,
          currentStep: currentStep.step,
          nextStep: nextStep.step,
          reason:
              'Graduation criteria met (completed ${currentStep.targetSets} sets of '
              '${currentStep.targetReps}$metric). Ready to advance to Tier ${nextStep.step}: ${nextStep.name}!',
        );
      }
    }
    return null;
  }

  /// Recommends a targeted post-workout yoga/mobility routine based on muscle groups trained.
  static YogaRecoveryRecommendation recommendYogaRecovery({
    required List<String> trainedMuscles,
  }) {
    final Set<String> muscles = trainedMuscles
        .map((String m) => m.toLowerCase().trim())
        .toSet();

    for (final YogaRoutine routine in YogaRoutine.allRoutines) {
      final bool matches = routine.recommendedAfterMuscles.any(
        (String rm) => muscles.contains(rm.toLowerCase().trim()),
      );
      if (matches) {
        return YogaRecoveryRecommendation(
          exerciseName: 'Yoga Recovery',
          routineId: routine.id,
          routineName: routine.name,
          estimatedMinutes: routine.estimatedMinutes,
          targetMuscles: routine.recommendedAfterMuscles,
          reason:
              'Based on your training of ${trainedMuscles.join(', ')}, ${routine.name} '
              'will facilitate ${routine.targetBenefit.toLowerCase()}.',
        );
      }
    }

    const YogaRoutine fallback = YogaRoutine.spinalHipDecompression;
    return YogaRecoveryRecommendation(
      exerciseName: 'Yoga Recovery',
      routineId: fallback.id,
      routineName: fallback.name,
      estimatedMinutes: fallback.estimatedMinutes,
      targetMuscles: fallback.recommendedAfterMuscles,
      reason: 'Post-workout mobility routine to down-regulate nervous system and relieve spinal compression.',
    );
  }

  static bool _isStagnant(List<List<WorkoutSet>> history, int threshold) {
    if (history.length < threshold) return false;
    final double baseWeight = history.first.isNotEmpty
        ? history.first.first.weight
        : 0.0;
    for (int i = 0; i < threshold; i++) {
      final List<WorkoutSet> session = history[i];
      if (session.isEmpty || session.first.weight != baseWeight) {
        return false;
      }
    }
    // Check if total volume is not increasing
    final double vol0 = _sessionVolume(history[0]);
    final double vol1 = _sessionVolume(history[1]);
    final double vol2 = _sessionVolume(history[2]);
    return vol0 <= vol1 && vol1 <= vol2;
  }

  static double _sessionVolume(List<WorkoutSet> sets) {
    return sets.fold(
      0.0,
      (double sum, WorkoutSet s) => sum + (s.weight * s.reps),
    );
  }

  static int _parseBottomRep(String range) {
    final List<String> parts = range.split('-');
    return int.tryParse(parts.first.replaceAll(RegExp(r'\D'), '')) ?? 8;
  }

  static int _parseTopRep(String range) {
    final List<String> parts = range.split('-');
    return int.tryParse(parts.last.replaceAll(RegExp(r'\D'), '')) ?? 12;
  }

  static double _round(double val) => (val * 10.0).roundToDouble() / 10.0;
}
