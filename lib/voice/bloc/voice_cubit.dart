import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../speech_service.dart';
import 'voice_state.dart';

/// Cubit managing speech recognition state and UI coordination.
class VoiceCubit extends Cubit<VoiceState> {
  VoiceCubit({required SpeechService speechService})
    : _speech = speechService,
      super(const VoiceIdle()) {
    _statusSub = _speech.isListeningStream.listen((bool listening) {
      if (!listening && state is VoiceListening) {
        emit(const VoiceIdle());
      }
    });
  }

  final SpeechService _speech;
  StreamSubscription<bool>? _statusSub;

  /// Starts speech recognition session.
  Future<void> startListening({
    required void Function(String result) onResult,
  }) async {
    emit(const VoiceListening());
    try {
      await _speech.startListening(
        onResult: (String text) {
          emit(VoiceSuccess(text));
          onResult(text);
          emit(const VoiceIdle());
        },
      );
    } catch (e) {
      emit(VoiceFailure(e.toString()));
    }
  }

  /// Manually stops current speech listening session.
  Future<void> stopListening() async {
    await _speech.stopListening();
    emit(const VoiceIdle());
  }

  @override
  Future<void> close() {
    _statusSub?.cancel();
    return super.close();
  }
}
