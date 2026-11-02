import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/voice/bloc/voice_cubit.dart';
import 'package:gym_tracker/voice/bloc/voice_state.dart';
import 'package:gym_tracker/voice/speech_service.dart';
import 'package:mocktail/mocktail.dart';

class MockSpeechService extends Mock implements SpeechService {}

void main() {
  late MockSpeechService mockSpeech;
  late StreamController<bool> listeningController;

  setUp(() {
    mockSpeech = MockSpeechService();
    listeningController = StreamController<bool>.broadcast();
    when(() => mockSpeech.isListeningStream)
        .thenAnswer((_) => listeningController.stream);
  });

  tearDown(() {
    listeningController.close();
  });

  group('VoiceCubit', () {
    test('initial state is VoiceIdle', () {
      final VoiceCubit cubit = VoiceCubit(speechService: mockSpeech);
      expect(cubit.state, const VoiceIdle());
      cubit.close();
    });

    blocTest<VoiceCubit, VoiceState>(
      'emits [VoiceListening, VoiceSuccess, VoiceIdle] when speech recognized',
      build: () {
        when(() => mockSpeech.startListening(onResult: any(named: 'onResult')))
            .thenAnswer((Invocation inv) async {
              final void Function(String) onResult =
                  inv.namedArguments[const Symbol('onResult')]
                      as void Function(String);
              onResult('bench press 10 at 80');
            });
        return VoiceCubit(speechService: mockSpeech);
      },
      act: (VoiceCubit cubit) async {
        await cubit.startListening(onResult: (_) {});
      },
      expect: () => <VoiceState>[
        const VoiceListening(),
        const VoiceSuccess('bench press 10 at 80'),
        const VoiceIdle(),
      ],
    );

    blocTest<VoiceCubit, VoiceState>(
      'emits [VoiceListening, VoiceFailure] when speech service throws',
      build: () {
        when(() => mockSpeech.startListening(onResult: any(named: 'onResult')))
            .thenThrow(Exception('Mic permission denied'));
        return VoiceCubit(speechService: mockSpeech);
      },
      act: (VoiceCubit cubit) async {
        await cubit.startListening(onResult: (_) {});
      },
      expect: () => <Matcher>[
        isA<VoiceListening>(),
        isA<VoiceFailure>().having(
          (VoiceFailure f) => f.errorMessage,
          'error message',
          contains('Mic permission denied'),
        ),
      ],
    );

    blocTest<VoiceCubit, VoiceState>(
      'stopListening invokes speech service and emits VoiceIdle',
      build: () {
        when(() => mockSpeech.stopListening()).thenAnswer((_) async {});
        return VoiceCubit(speechService: mockSpeech);
      },
      act: (VoiceCubit cubit) async {
        await cubit.stopListening();
      },
      expect: () => <VoiceState>[const VoiceIdle()],
      verify: (_) {
        verify(() => mockSpeech.stopListening()).called(1);
      },
    );
  });
}
