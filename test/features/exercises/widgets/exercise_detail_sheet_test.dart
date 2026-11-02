import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/data/models/models.dart';
import 'package:gym_tracker/features/exercises/widgets/exercise_detail_sheet.dart';
import 'package:gym_tracker/features/workout/bloc/workout_bloc.dart';
import 'package:gym_tracker/features/workout/bloc/workout_state.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/test_factories.dart';

class MockWorkoutBloc extends Mock implements WorkoutBloc {}

void main() {
  late MockWorkoutBloc mockWorkoutBloc;

  setUp(() {
    mockWorkoutBloc = MockWorkoutBloc();
    when(() => mockWorkoutBloc.state).thenReturn(const NoActiveWorkout());
    when(() => mockWorkoutBloc.stream)
        .thenAnswer((_) => Stream<WorkoutState>.value(const NoActiveWorkout()));
  });

  Widget buildTestWidget(Exercise exercise) {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<WorkoutBloc>.value(
          value: mockWorkoutBloc,
          child: ExerciseDetailSheet(exercise: exercise),
        ),
      ),
    );
  }

  group('ExerciseDetailSheet', () {
    testWidgets('renders exercise name, biomechanics badges, and cues', (
      WidgetTester tester,
    ) async {
      final Exercise exercise = createTestExercise(
        name: 'Romanian Deadlift',
        muscleGroup: 'Legs',
        category: 'Dumbbell',
        movementPattern: 'hip_dominant',
        targetRepRange: '8-10',
        defaultRestSeconds: 120,
        formCues: '1. Soft knee bend.\n2. Push hips back.',
        commonMistakes: 'Rounding lumbar spine.',
      );

      await tester.pumpWidget(buildTestWidget(exercise));
      await tester.pumpAndSettle();

      expect(find.text('Romanian Deadlift'), findsOneWidget);
      expect(find.text('Legs'), findsOneWidget);
      expect(find.text('Dumbbell'), findsOneWidget);
      expect(find.text('8-10'), findsOneWidget);
      expect(find.text('120s'), findsOneWidget);
      expect(find.text('Posture & Execution Cues'), findsOneWidget);
      expect(find.text('Common Mistakes to Avoid'), findsOneWidget);
      expect(find.text('Start Workout with this Exercise'), findsOneWidget);
    });

    testWidgets('renders active workout button when workout is active', (
      WidgetTester tester,
    ) async {
      final Exercise exercise = createTestExercise(name: 'Barbell Squat');
      final Workout workout = Workout(
        id: 'w_act',
        title: 'Legs',
        startedAt: DateTime.now(),
        totalVolume: 0,
        durationSeconds: 0,
      );

      when(() => mockWorkoutBloc.state).thenReturn(
        ActiveWorkoutState(
          workout: workout,
          sets: const <WorkoutSet>[],
          exercises: <String, Exercise>{exercise.id: exercise},
        ),
      );

      await tester.pumpWidget(buildTestWidget(exercise));
      await tester.pumpAndSettle();

      expect(find.text('Log Set for Barbell Squat'), findsOneWidget);
    });
  });
}
