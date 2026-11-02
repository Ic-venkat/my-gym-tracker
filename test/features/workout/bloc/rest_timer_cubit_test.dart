import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/features/workout/bloc/rest_timer_cubit.dart';
import 'package:gym_tracker/features/workout/bloc/rest_timer_state.dart';
import 'package:gym_tracker/voice/tts_service.dart';
import 'package:mocktail/mocktail.dart';

class MockTtsService extends Mock implements TtsService {}

void main() {
  late MockTtsService mockTts;

  setUp(() {
    mockTts = MockTtsService();
    when(() => mockTts.speak(any())).thenAnswer((_) async {});
  });

  group('RestTimerCubit', () {
    blocTest<RestTimerCubit, RestTimerState>(
      'starts countdown timer with given seconds',
      build: () => RestTimerCubit(ttsService: mockTts),
      act: (RestTimerCubit cubit) => cubit.startTimer(90),
      expect: () => <Matcher>[
        isA<RestTimerState>()
            .having((RestTimerState s) => s.remainingSeconds, 'remaining', 90)
            .having((RestTimerState s) => s.isActive, 'active', isTrue),
      ],
    );

    blocTest<RestTimerCubit, RestTimerState>(
      'skips timer when skipTimer is invoked',
      build: () => RestTimerCubit(ttsService: mockTts),
      seed: () => const RestTimerState(remainingSeconds: 45, isActive: true),
      act: (RestTimerCubit cubit) => cubit.skipTimer(),
      expect: () => <Matcher>[
        isA<RestTimerState>()
            .having((RestTimerState s) => s.remainingSeconds, 'remaining', 0)
            .having((RestTimerState s) => s.isActive, 'active', isFalse),
      ],
    );
  });
}
