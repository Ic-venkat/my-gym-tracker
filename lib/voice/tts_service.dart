import 'package:flutter_tts/flutter_tts.dart';

import '../core/logger/app_logger.dart';

/// Clean voice feedback service wrapping [FlutterTts].
class TtsService {
  TtsService({FlutterTts? tts}) : _tts = tts ?? FlutterTts() {
    _initTts();
  }

  final FlutterTts _tts;
  bool _isReady = false;

  Future<void> _initTts() async {
    try {
      await _tts.setLanguage('en-US');
      await _tts.setPitch(1.0);
      await _tts.setSpeechRate(0.5);
      _isReady = true;
    } catch (e, st) {
      AppLogger.e('Failed to initialize TTS service', error: e, stackTrace: st);
    }
  }

  /// Speaks the given [text] for audio confirmation in the gym.
  Future<void> speak(String text) async {
    if (!_isReady) {
      await _initTts();
    }
    try {
      await _tts.stop();
      await _tts.speak(text);
    } catch (e, st) {
      AppLogger.e('TTS speak error: $text', error: e, stackTrace: st);
    }
  }

  /// Stops current speech output.
  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (e, st) {
      AppLogger.e('TTS stop error', error: e, stackTrace: st);
    }
  }
}
