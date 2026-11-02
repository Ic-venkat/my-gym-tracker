import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/features/workout/bloc/rest_timer_cubit.dart';
import 'package:gym_tracker/features/workout/bloc/rest_timer_state.dart';
import 'package:gym_tracker/features/workout/widgets/rest_timer_banner.dart';
import 'package:mocktail/mocktail.dart';

class MockRestTimerCubit extends Mock implements RestTimerCubit {}

void main() {
  group('RestTimerBanner', () {
    late MockRestTimerCubit mockRestTimerCubit;

    setUp(() {
      mockRestTimerCubit = MockRestTimerCubit();
      when(() => mockRestTimerCubit.state).thenReturn(const RestTimerState());
      when(() => mockRestTimerCubit.stream)
          .thenAnswer((_) => const Stream<RestTimerState>.empty());
      when(() => mockRestTimerCubit.skipTimer()).thenReturn(null);
    });

    Widget createWidgetUnderTest({required int remainingSeconds}) {
      return MaterialApp(
        home: Scaffold(
          body: BlocProvider<RestTimerCubit>.value(
            value: mockRestTimerCubit,
            child: RestTimerBanner(remainingSeconds: remainingSeconds),
          ),
        ),
      );
    }

    testWidgets('formats time correctly for 90 seconds (01:30)', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(createWidgetUnderTest(remainingSeconds: 90));

      // Assert
      expect(find.text('Rest: 01:30'), findsOneWidget);
      expect(find.byIcon(Icons.timer), findsOneWidget);
    });

    testWidgets('formats time correctly for 5 seconds (00:05)', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(createWidgetUnderTest(remainingSeconds: 5));

      // Assert
      expect(find.text('Rest: 00:05'), findsOneWidget);
    });

    testWidgets('formats time correctly for 125 seconds (02:05)', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(createWidgetUnderTest(remainingSeconds: 125));

      // Assert
      expect(find.text('Rest: 02:05'), findsOneWidget);
    });

    testWidgets('tapping Skip button calls skipTimer on RestTimerCubit', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest(remainingSeconds: 60));

      // Act
      await tester.tap(find.text('Skip'));
      await tester.pump();

      // Assert
      verify(() => mockRestTimerCubit.skipTimer()).called(1);
    });
  });
}
