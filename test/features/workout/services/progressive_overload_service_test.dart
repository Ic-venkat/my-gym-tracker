import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/data/models/models.dart';
import 'package:gym_tracker/features/workout/models/progression_recommendation.dart';
import 'package:gym_tracker/features/workout/services/progressive_overload_service.dart';

void main() {
  group('ProgressiveOverloadService', () {
    WorkoutSet createSet({
      required String id,
      required int setNumber,
      required int reps,
      required double weight,
    }) {
      return WorkoutSet(
        id: id,
        workoutId: 'w_test',
        exerciseId: 'ex_bench',
        setNumber: setNumber,
        reps: reps,
        weight: weight,
        isCompleted: true,
        restSeconds: 90,
        createdAt: DateTime.now(),
      );
    }

    group('evaluateDoubleProgression', () {
      test('triggers WeightIncreaseRecommendation when all sets hit top of rep range', () {
        final List<List<WorkoutSet>> history = <List<WorkoutSet>>[
          <WorkoutSet>[
            createSet(id: 's1', setNumber: 1, reps: 12, weight: 80.0),
            createSet(id: 's2', setNumber: 2, reps: 12, weight: 80.0),
            createSet(id: 's3', setNumber: 3, reps: 12, weight: 80.0),
          ],
        ];

        final ProgressionRecommendation rec =
            ProgressiveOverloadService.evaluateDoubleProgression(
              exerciseName: 'Barbell Bench Press',
              targetRepRange: '8-12',
              minIncrementKg: 2.5,
              sessionHistory: history,
            );

        expect(rec, isA<WeightIncreaseRecommendation>());
        final WeightIncreaseRecommendation inc =
            rec as WeightIncreaseRecommendation;
        expect(inc.currentWeight, 80.0);
        expect(inc.suggestedWeight, 82.5);
        expect(inc.targetReps, 8);
        expect(inc.targetSets, 3);
      });

      test(
        'triggers MaintainAndRepProgression when working within rep range',
        () {
          final List<List<WorkoutSet>> history = <List<WorkoutSet>>[
            <WorkoutSet>[
              createSet(id: 's1', setNumber: 1, reps: 11, weight: 80.0),
              createSet(id: 's2', setNumber: 2, reps: 10, weight: 80.0),
              createSet(id: 's3', setNumber: 3, reps: 8, weight: 80.0),
            ],
          ];

          final ProgressionRecommendation rec =
              ProgressiveOverloadService.evaluateDoubleProgression(
                exerciseName: 'Barbell Bench Press',
                targetRepRange: '8-12',
                minIncrementKg: 2.5,
                sessionHistory: history,
              );

          expect(rec, isA<MaintainAndRepProgression>());
          final MaintainAndRepProgression maintain =
              rec as MaintainAndRepProgression;
          expect(maintain.currentWeight, 80.0);
          expect(maintain.targetReps, 9);
        },
      );

      test('triggers DeloadRecommendation when performance plateaus for 3 sessions', () {
        final List<WorkoutSet> stagnantSets = <WorkoutSet>[
          createSet(id: 's1', setNumber: 1, reps: 8, weight: 100.0),
          createSet(id: 's2', setNumber: 2, reps: 8, weight: 100.0),
          createSet(id: 's3', setNumber: 3, reps: 7, weight: 100.0),
        ];

        final List<List<WorkoutSet>> history = <List<WorkoutSet>>[
          stagnantSets,
          stagnantSets,
          stagnantSets,
        ];

        final ProgressionRecommendation rec =
            ProgressiveOverloadService.evaluateDoubleProgression(
              exerciseName: 'Barbell Squat',
              targetRepRange: '8-12',
              minIncrementKg: 2.5,
              sessionHistory: history,
            );

        expect(rec, isA<DeloadRecommendation>());
        final DeloadRecommendation deload = rec as DeloadRecommendation;
        expect(deload.currentWeight, 100.0);
        expect(deload.deloadWeight, 90.0);
      });
    });

    group('evaluateCalisthenicsProgression', () {
      test(
        'advances push-up ladder from Standard Push-ups to Diamond Push-ups',
        () {
          final List<WorkoutSet> sets = <WorkoutSet>[
            createSet(id: 'p1', setNumber: 1, reps: 20, weight: 0.0),
            createSet(id: 'p2', setNumber: 2, reps: 20, weight: 0.0),
            createSet(id: 'p3', setNumber: 3, reps: 20, weight: 0.0),
          ];

          final CalisthenicsProgressionRecommendation? rec =
              ProgressiveOverloadService.evaluateCalisthenicsProgression(
                exerciseIdentifier: 'ex_pushups',
                recentSets: sets,
              );

          expect(rec, isNotNull);
          expect(rec!.currentStep, 2);
          expect(rec.nextStep, 3);
          expect(rec.nextExerciseName, 'Diamond Push-ups');
        },
      );

      test('returns null when graduation threshold is not yet met', () {
        final List<WorkoutSet> sets = <WorkoutSet>[
          createSet(id: 'p1', setNumber: 1, reps: 20, weight: 0.0),
          createSet(id: 'p2', setNumber: 2, reps: 15, weight: 0.0), // Under 20
        ];

        final CalisthenicsProgressionRecommendation? rec =
            ProgressiveOverloadService.evaluateCalisthenicsProgression(
              exerciseIdentifier: 'ex_pushups',
              recentSets: sets,
            );

        expect(rec, isNull);
      });
    });

    group('recommendYogaRecovery', () {
      test('matches Spinal & Hip Decompression after leg training', () {
        final YogaRecoveryRecommendation rec =
            ProgressiveOverloadService.recommendYogaRecovery(
              trainedMuscles: <String>['Legs', 'Glutes'],
            );

        expect(rec.routineId, 'routine_spine_hip_decompression');
        expect(rec.estimatedMinutes, 8);
      });

      test('matches Shoulder & Thoracic Prehab after chest and shoulders', () {
        final YogaRecoveryRecommendation rec =
            ProgressiveOverloadService.recommendYogaRecovery(
              trainedMuscles: <String>['Chest', 'Shoulders'],
            );

        expect(rec.routineId, 'routine_shoulder_thoracic_prehab');
        expect(rec.estimatedMinutes, 6);
      });
    });
  });
}
