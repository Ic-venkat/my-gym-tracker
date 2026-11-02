import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
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

  setUp(() {
    mockWorkoutBloc = MockWorkoutBloc();
    mockRestTimer = MockRestTimerCubit();

    when(() => mockRestTimer.state).thenReturn(const RestTimerState());
    when(() => mockRestTimer.stream).thenAnswer(
      (_) => Stream<RestTimerState>.value(const RestTimerState()),
    );
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
}
