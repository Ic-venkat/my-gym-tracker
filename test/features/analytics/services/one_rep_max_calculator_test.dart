import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/features/analytics/services/one_rep_max_calculator.dart';

void main() {
  group('OneRepMaxCalculator', () {
    test('returns exact weight when reps is 1', () {
      final OneRepMaxEstimate estimate = OneRepMaxCalculator.calculate1Rm(
        weight: 100.0,
        reps: 1,
      );

      expect(estimate.epley, 100.0);
      expect(estimate.brzycki, 100.0);
      expect(estimate.wathan, 100.0);
      expect(estimate.lander, 100.0);
      expect(estimate.consensus, 100.0);
    });

    test('returns 0 for non-positive weight or reps', () {
      final OneRepMaxEstimate zeroWeight = OneRepMaxCalculator.calculate1Rm(
        weight: 0.0,
        reps: 5,
      );
      expect(zeroWeight.consensus, 0.0);

      final OneRepMaxEstimate zeroReps = OneRepMaxCalculator.calculate1Rm(
        weight: 100.0,
        reps: 0,
      );
      expect(zeroReps.consensus, 0.0);
    });

    test('calculates accurate estimates for standard 100kg x 10 reps', () {
      final OneRepMaxEstimate estimate = OneRepMaxCalculator.calculate1Rm(
        weight: 100.0,
        reps: 10,
      );

      // Epley: 100 * (1 + 10/30) = 133.3
      expect(estimate.epley, 133.3);

      // Brzycki: 100 * 36 / (37 - 10) = 133.3
      expect(estimate.brzycki, 133.3);

      // Wathan: 100 * 100 / (48.8 + 53.8 * exp(-0.75)) = 134.7
      expect(estimate.wathan, greaterThan(130.0));
      expect(estimate.wathan, lessThan(140.0));

      // Consensus should be around 133-135 kg
      expect(estimate.consensus, greaterThan(130.0));
      expect(estimate.consensus, lessThan(136.0));
    });

    test('calculates percentage load accurately', () {
      final double load80 = OneRepMaxCalculator.calculatePercentageLoad(
        oneRepMax: 140.0,
        percentage: 80.0,
      );
      expect(load80, 112.0);

      final double load65 = OneRepMaxCalculator.calculatePercentageLoad(
        oneRepMax: 100.0,
        percentage: 65.0,
      );
      expect(load65, 65.0);
    });

    test('generates percentage chart with all target intervals', () {
      final Map<int, double> chart =
          OneRepMaxCalculator.generatePercentageChart(100.0);

      expect(chart[100], 100.0);
      expect(chart[95], 95.0);
      expect(chart[90], 90.0);
      expect(chart[85], 85.0);
      expect(chart[80], 80.0);
      expect(chart[75], 75.0);
      expect(chart[70], 70.0);
      expect(chart[65], 65.0);
      expect(chart[60], 60.0);
    });

    test('estimates reps at target working weight', () {
      // 1RM of 133.3kg at 100kg should estimate ~10 reps
      final int reps = OneRepMaxCalculator.estimateRepsAtWeight(
        oneRepMax: 133.3,
        targetWeight: 100.0,
      );
      expect(reps, 10);
    });

    test('calculates total tonnage correctly', () {
      final double total = OneRepMaxCalculator.calculateTotalVolume(
        <({double weight, int reps})>[
          (weight: 100.0, reps: 5),
          (weight: 100.0, reps: 5),
          (weight: 100.0, reps: 5),
          (weight: 80.0, reps: 8),
        ],
      );
      // 500 + 500 + 500 + 640 = 2140
      expect(total, 2140.0);
    });
  });
}
