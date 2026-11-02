import 'dart:math' as math;

/// Mathematical model representing estimated One-Rep Max across standard scientific formulas.
class OneRepMaxEstimate {
  const OneRepMaxEstimate({
    required this.epley,
    required this.brzycki,
    required this.wathan,
    required this.lander,
    required this.consensus,
  });

  /// Epley formula estimate: w * (1 + r / 30).
  final double epley;

  /// Brzycki formula estimate: w * 36 / (37 - r).
  final double brzycki;

  /// Wathan formula estimate: 100 * w / (48.8 + 53.8 * exp(-0.075 * r)).
  final double wathan;

  /// Lander formula estimate: 100 * w / (101.3 - 2.67123 * r).
  final double lander;

  /// Mean average across validated formulas.
  final double consensus;
}

/// Pure domain service implementing validated biomechanical strength equations.
class OneRepMaxCalculator {
  OneRepMaxCalculator._();

  /// Calculates estimated 1RM using Epley, Brzycki, Wathan, and Lander formulas.
  static OneRepMaxEstimate calculate1Rm({
    required double weight,
    required int reps,
  }) {
    if (weight <= 0.0 || reps <= 0) {
      return const OneRepMaxEstimate(
        epley: 0.0,
        brzycki: 0.0,
        wathan: 0.0,
        lander: 0.0,
        consensus: 0.0,
      );
    }

    if (reps == 1) {
      return OneRepMaxEstimate(
        epley: weight,
        brzycki: weight,
        wathan: weight,
        lander: weight,
        consensus: weight,
      );
    }

    // 1. Epley Formula
    final double epley = weight * (1.0 + (reps / 30.0));

    // 2. Brzycki Formula (valid up to 36 reps)
    final double brzycki = reps < 37 ? weight * (36.0 / (37.0 - reps)) : epley;

    // 3. Wathan Formula
    final double wathanDenominator = 48.8 + (53.8 * math.exp(-0.075 * reps));
    final double wathan = (100.0 * weight) / wathanDenominator;

    // 4. Lander Formula
    final double landerDenominator = 101.3 - (2.67123 * reps);
    final double lander = landerDenominator > 0
        ? (100.0 * weight) / landerDenominator
        : epley;

    final double consensus = (epley + brzycki + wathan + lander) / 4.0;

    return OneRepMaxEstimate(
      epley: _round(epley),
      brzycki: _round(brzycki),
      wathan: _round(wathan),
      lander: _round(lander),
      consensus: _round(consensus),
    );
  }

  /// Calculates training load for a given percentage of 1RM (e.g. 0.80 for 80%).
  static double calculatePercentageLoad({
    required double oneRepMax,
    required double percentage,
  }) {
    if (oneRepMax <= 0.0 || percentage <= 0.0) return 0.0;
    return _round(oneRepMax * (percentage / 100.0));
  }

  /// Generates standard percentage-based training chart (100% down to 60%).
  static Map<int, double> generatePercentageChart(double oneRepMax) {
    const List<int> percentages = <int>[100, 95, 90, 85, 80, 75, 70, 65, 60];
    final Map<int, double> chart = <int, double>{};
    for (final int pct in percentages) {
      chart[pct] = calculatePercentageLoad(
        oneRepMax: oneRepMax,
        percentage: pct.toDouble(),
      );
    }
    return chart;
  }

  /// Estimates repetitions possible at a given working weight based on 1RM.
  static int estimateRepsAtWeight({
    required double oneRepMax,
    required double targetWeight,
  }) {
    if (oneRepMax <= 0.0 || targetWeight <= 0.0 || targetWeight > oneRepMax) {
      return targetWeight == oneRepMax ? 1 : 0;
    }
    // Inverting Epley: r = 30 * (1RM / w - 1)
    final double estimated = 30.0 * ((oneRepMax / targetWeight) - 1.0);
    return estimated.clamp(1.0, 30.0).round();
  }

  /// Calculates total tonnage/volume from a collection of weight and rep pairs.
  static double calculateTotalVolume(List<({double weight, int reps})> sets) {
    double total = 0.0;
    for (final ({double weight, int reps}) s in sets) {
      if (s.weight > 0.0 && s.reps > 0) {
        total += s.weight * s.reps;
      }
    }
    return _round(total);
  }

  static double _round(double val) => (val * 10.0).roundToDouble() / 10.0;
}
