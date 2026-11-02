import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/data/models/models.dart';
import 'package:gym_tracker/features/workout/bloc/rest_timer_cubit.dart';
import 'package:gym_tracker/features/workout/bloc/rest_timer_state.dart';
import 'package:gym_tracker/features/workout/bloc/workout_bloc.dart';
import 'package:gym_tracker/features/workout/bloc/workout_state.dart';
import 'package:gym_tracker/features/workout/screens/active_workout_screen.dart';
import 'package:mocktail/mocktail.dart';

class MockWorkoutBloc extends Mock implements WorkoutBloc {}

class MockRestTimerCubit extends Mock implements RestTimerCubit {}

void main() {
  late MockWorkoutBloc mockWorkoutBloc;
  late MockRestTimerCubit mockRestTimer;

  final Workout sampleWorkout = Workout(
    id: 'w_1',
    title: 'Leg Day',
    startedAt: DateTime.now(),
    totalVolume: 0,
    durationSeconds: 0,
  );

  setUp(() {
    mockWorkoutBloc = MockWorkoutBloc();
    mockRestTimer = MockRestTimerCubit();

    when(() => mockRestTimer.state).thenReturn(const RestTimerState());
    when(
      () => mockRestTimer.stream,
    ).thenAnswer((_) => Stream<RestTimerState>.value(const RestTimerState()));
    when(() => mockRestTimer.startTimer(any())).thenReturn(null);
    when(() => mockRestTimer.skipTimer()).thenReturn(null);
  });

  Widget createWidgetUnderTest() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<WorkoutBloc>.value(value: mockWorkoutBloc),
        BlocProvider<RestTimerCubit>.value(value: mockRestTimer),
      ],
      child: const MaterialApp(home: ActiveWorkoutScreen()),
    );
  }

  testWidgets('renders StartWorkoutView when NoActiveWorkout', (
    WidgetTester tester,
  ) async {
    when(() => mockWorkoutBloc.state).thenReturn(const NoActiveWorkout());
    when(() => mockWorkoutBloc.stream)
        .thenAnswer((_) => Stream<WorkoutState>.value(const NoActiveWorkout()));

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Ready to Train?'), findsOneWidget);
    expect(find.text('Start New Workout'), findsOneWidget);
  });

  testWidgets('renders loading spinner when WorkoutLoading', (
    WidgetTester tester,
  ) async {
    when(() => mockWorkoutBloc.state).thenReturn(const WorkoutLoading());
    when(() => mockWorkoutBloc.stream)
        .thenAnswer((_) => Stream<WorkoutState>.value(const WorkoutLoading()));

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets(
    'triggers startTimer on RestTimerCubit when restTriggerId changes',
    (WidgetTester tester) async {
      final StreamController<WorkoutState> workoutController =
          StreamController<WorkoutState>.broadcast();
      final ActiveWorkoutState state1 = ActiveWorkoutState(
        workout: sampleWorkout,
        sets: const <WorkoutSet>[],
        exercises: const <String, Exercise>{},
      );
      final ActiveWorkoutState state2 = state1.copyWith(
        restCountdownSeconds: 90,
        restTriggerId: 1,
      );

      when(() => mockWorkoutBloc.state).thenReturn(state1);
      when(() => mockWorkoutBloc.stream)
          .thenAnswer((_) => workoutController.stream);

      await tester.pumpWidget(createWidgetUnderTest());

      workoutController.add(state2);
      await tester.pump();

      verify(() => mockRestTimer.startTimer(90)).called(1);
      await workoutController.close();
    },
  );

  testWidgets('triggers skipTimer on RestTimerCubit when workout finishes', (
    WidgetTester tester,
  ) async {
    final StreamController<WorkoutState> workoutController =
        StreamController<WorkoutState>.broadcast();
    final ActiveWorkoutState state1 = ActiveWorkoutState(
      workout: sampleWorkout,
      sets: const <WorkoutSet>[],
      exercises: const <String, Exercise>{},
    );

    when(() => mockWorkoutBloc.state).thenReturn(state1);
    when(() => mockWorkoutBloc.stream)
        .thenAnswer((_) => workoutController.stream);

    await tester.pumpWidget(createWidgetUnderTest());

    workoutController.add(WorkoutCompletedState(sampleWorkout));
    await tester.pump();

    verify(() => mockRestTimer.skipTimer()).called(1);
    await workoutController.close();
  });
}
