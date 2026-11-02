import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/features/workout/bloc/workout_bloc.dart';
import 'package:gym_tracker/features/workout/widgets/voice_mic_button.dart';
import 'package:gym_tracker/voice/bloc/voice_cubit.dart';
import 'package:gym_tracker/voice/bloc/voice_state.dart';
import 'package:mocktail/mocktail.dart';

class MockVoiceCubit extends Mock implements VoiceCubit {}

class MockWorkoutBloc extends Mock implements WorkoutBloc {}

void main() {
  late MockVoiceCubit mockVoiceCubit;
  late MockWorkoutBloc mockWorkoutBloc;

  setUp(() {
    mockVoiceCubit = MockVoiceCubit();
    mockWorkoutBloc = MockWorkoutBloc();
  });

  Widget createWidgetUnderTest() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<VoiceCubit>.value(value: mockVoiceCubit),
        BlocProvider<WorkoutBloc>.value(value: mockWorkoutBloc),
      ],
      child: const MaterialApp(
        home: Scaffold(floatingActionButton: VoiceMicButton()),
      ),
    );
  }

  testWidgets('renders idle VoiceMicButton with "Voice Log"', (
    WidgetTester tester,
  ) async {
    when(() => mockVoiceCubit.state).thenReturn(const VoiceIdle());
    when(() => mockVoiceCubit.stream)
        .thenAnswer((_) => Stream<VoiceState>.value(const VoiceIdle()));

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Voice Log'), findsOneWidget);
    expect(find.byIcon(Icons.mic_none), findsOneWidget);
  });

  testWidgets('renders listening VoiceMicButton with "Listening..."', (
    WidgetTester tester,
  ) async {
    when(() => mockVoiceCubit.state).thenReturn(const VoiceListening());
    when(() => mockVoiceCubit.stream)
        .thenAnswer((_) => Stream<VoiceState>.value(const VoiceListening()));

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Listening...'), findsOneWidget);
    expect(find.byIcon(Icons.mic), findsOneWidget);
  });
}
