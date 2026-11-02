import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/data/models/models.dart';
import 'package:gym_tracker/features/workout/bloc/workout_bloc.dart';
import 'package:gym_tracker/features/workout/bloc/workout_event.dart';
import 'package:gym_tracker/features/workout/bloc/workout_state.dart';
import 'package:gym_tracker/features/workout/widgets/set_row_widget.dart';
import 'package:mocktail/mocktail.dart';

class MockWorkoutBloc extends Mock implements WorkoutBloc {}

void main() {
  setUpAll(() {
    registerFallbackValue(const DeleteSetEvent('dummy_id'));
  });

  group('SetRowWidget', () {
    late MockWorkoutBloc mockWorkoutBloc;

    setUp(() {
      mockWorkoutBloc = MockWorkoutBloc();
      when(() => mockWorkoutBloc.state).thenReturn(const NoActiveWorkout());
      when(() => mockWorkoutBloc.stream)
          .thenAnswer((_) => const Stream<WorkoutState>.empty());
      when(() => mockWorkoutBloc.add(any())).thenReturn(null);
    });

    Widget createWidgetUnderTest(WorkoutSet set) {
      return MaterialApp(
        home: Scaffold(
          body: BlocProvider<WorkoutBloc>.value(
            value: mockWorkoutBloc,
            child: SetRowWidget(set: set),
          ),
        ),
      );
    }

    testWidgets('renders integer weight without trailing decimal', (
      WidgetTester tester,
    ) async {
      // Arrange
      final WorkoutSet set = WorkoutSet(
        id: 'set_1',
        workoutId: 'w_1',
        exerciseId: 'ex_bench',
        setNumber: 1,
        reps: 10,
        weight: 80.0,
        isCompleted: true,
        restSeconds: 90,
        createdAt: DateTime.now(),
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest(set));

      // Assert
      expect(find.text('Set 1'), findsOneWidget);
      expect(find.text('80 kg'), findsOneWidget);
      expect(find.text('10 reps'), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    });

    testWidgets('renders decimal weight with 1 decimal place', (
      WidgetTester tester,
    ) async {
      // Arrange
      final WorkoutSet set = WorkoutSet(
        id: 'set_2',
        workoutId: 'w_1',
        exerciseId: 'ex_squat',
        setNumber: 3,
        reps: 8,
        weight: 92.5,
        isCompleted: true,
        restSeconds: 120,
        createdAt: DateTime.now(),
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest(set));

      // Assert
      expect(find.text('Set 3'), findsOneWidget);
      expect(find.text('92.5 kg'), findsOneWidget);
      expect(find.text('8 reps'), findsOneWidget);
    });

    testWidgets('tapping delete icon dispatches DeleteSetEvent', (
      WidgetTester tester,
    ) async {
      // Arrange
      final WorkoutSet set = WorkoutSet(
        id: 'set_to_delete',
        workoutId: 'w_1',
        exerciseId: 'ex_bench',
        setNumber: 2,
        reps: 6,
        weight: 100.0,
        isCompleted: true,
        restSeconds: 180,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(createWidgetUnderTest(set));

      // Act
      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pump();

      // Assert
      verify(() => mockWorkoutBloc.add(const DeleteSetEvent('set_to_delete')))
          .called(1);
    });
  });
}
