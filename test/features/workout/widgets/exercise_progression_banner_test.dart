import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/data/models/models.dart';
import 'package:gym_tracker/features/workout/widgets/exercise_progression_banner.dart';

import '../../../helpers/test_factories.dart';

void main() {
  group('ExerciseProgressionBanner', () {
    final Exercise sampleExercise = createTestExercise(targetRepRange: '8-12');

    WorkoutSet createSet({required int setNumber, required int reps}) {
      return WorkoutSet(
        id: 's_$setNumber',
        workoutId: 'w_1',
        exerciseId: 'ex_bench',
        setNumber: setNumber,
        reps: reps,
        weight: 80.0,
        isCompleted: true,
        restSeconds: 90,
        createdAt: DateTime.now(),
      );
    }

    testWidgets('renders SizedBox.shrink when sets list is empty', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExerciseProgressionBanner(
              exercise: sampleExercise,
              sets: const <WorkoutSet>[],
            ),
          ),
        ),
      );

      expect(find.byType(ExerciseProgressionBanner), findsOneWidget);
      expect(find.textContaining('Target reached!'), findsNothing);
    });

    testWidgets(
      'renders target reached pill when all sets hit top of rep range',
      (WidgetTester tester) async {
        final List<WorkoutSet> sets = <WorkoutSet>[
          createSet(setNumber: 1, reps: 12),
          createSet(setNumber: 2, reps: 12),
          createSet(setNumber: 3, reps: 12),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ExerciseProgressionBanner(
                exercise: sampleExercise,
                sets: sets,
              ),
            ),
          ),
        );

        expect(find.textContaining('Target reached!'), findsOneWidget);
        expect(find.textContaining('+2.5 kg (82.5 kg)'), findsOneWidget);
        expect(find.byIcon(Icons.trending_up), findsOneWidget);
      },
    );

    testWidgets(
      'renders calisthenics level up pill when skill benchmark is met',
      (WidgetTester tester) async {
        final Exercise pushupExercise = createTestExercise(
          id: 'ex_pushups',
          name: 'Standard Floor Push-ups',
          category: 'Bodyweight',
        );

        final List<WorkoutSet> sets = <WorkoutSet>[
          WorkoutSet(
            id: 'p1',
            workoutId: 'w_1',
            exerciseId: 'ex_pushups',
            setNumber: 1,
            reps: 20,
            weight: 0.0,
            isCompleted: true,
            restSeconds: 60,
            createdAt: DateTime.now(),
          ),
          WorkoutSet(
            id: 'p2',
            workoutId: 'w_1',
            exerciseId: 'ex_pushups',
            setNumber: 2,
            reps: 20,
            weight: 0.0,
            isCompleted: true,
            restSeconds: 60,
            createdAt: DateTime.now(),
          ),
          WorkoutSet(
            id: 'p3',
            workoutId: 'w_1',
            exerciseId: 'ex_pushups',
            setNumber: 3,
            reps: 20,
            weight: 0.0,
            isCompleted: true,
            restSeconds: 60,
            createdAt: DateTime.now(),
          ),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ExerciseProgressionBanner(
                exercise: pushupExercise,
                sets: sets,
              ),
            ),
          ),
        );

        expect(
          find.text('Benchmark Met! Level up to Diamond Push-ups'),
          findsOneWidget,
        );
        expect(find.byIcon(Icons.emoji_events_outlined), findsOneWidget);
      },
    );
  });
}
