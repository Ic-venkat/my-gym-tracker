import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/features/templates/widgets/template_picker_sheet.dart';
import 'package:gym_tracker/features/workout/bloc/workout_bloc.dart';
import 'package:gym_tracker/features/workout/bloc/workout_event.dart';
import 'package:gym_tracker/features/workout/bloc/workout_state.dart';
import 'package:gym_tracker/features/workout/widgets/start_workout_view.dart';
import 'package:mocktail/mocktail.dart';

class MockWorkoutBloc extends Mock implements WorkoutBloc {}

void main() {
  setUpAll(() {
    registerFallbackValue(const StartWorkoutEvent());
  });

  group('StartWorkoutView', () {
    late MockWorkoutBloc mockWorkoutBloc;

    setUp(() {
      mockWorkoutBloc = MockWorkoutBloc();
      when(() => mockWorkoutBloc.state).thenReturn(const NoActiveWorkout());
      when(() => mockWorkoutBloc.stream)
          .thenAnswer((_) => const Stream<WorkoutState>.empty());
      when(() => mockWorkoutBloc.add(any())).thenReturn(null);
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: Scaffold(
          body: BlocProvider<WorkoutBloc>.value(
            value: mockWorkoutBloc,
            child: const StartWorkoutView(),
          ),
        ),
      );
    }

    testWidgets('renders header text and action buttons', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.text('Ready to Train?'), findsOneWidget);
      expect(find.byIcon(Icons.fitness_center), findsOneWidget);
      expect(find.text('Start New Workout'), findsOneWidget);
      expect(find.text('Start From Template'), findsOneWidget);
    });

    testWidgets('tapping Start New Workout dispatches StartWorkoutEvent', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());

      // Act
      await tester.tap(find.text('Start New Workout'));
      await tester.pump();

      // Assert
      verify(() => mockWorkoutBloc.add(const StartWorkoutEvent())).called(1);
    });

    testWidgets('tapping Start From Template opens TemplatePickerSheet', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());

      // Act
      await tester.tap(find.text('Start From Template'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(TemplatePickerSheet), findsOneWidget);
      expect(find.text('Choose a Workout Split'), findsOneWidget);
    });

    testWidgets(
      'selecting a template from picker sheet starts workout with template title',
      (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.tap(find.text('Start From Template'));
        await tester.pumpAndSettle();

        // Act: select the first template in the list (e.g. Push (Chest, Shoulders, Triceps))
        await tester.tap(find.textContaining('Push').first);
        await tester.pumpAndSettle();

        // Assert
        verify(
          () => mockWorkoutBloc.add(
            any(
              that: isA<StartWorkoutEvent>().having(
                (StartWorkoutEvent e) => e.title,
                'title',
                contains('Push'),
              ),
            ),
          ),
        ).called(1);
        expect(find.byType(TemplatePickerSheet), findsNothing);
      },
    );
  });
}
