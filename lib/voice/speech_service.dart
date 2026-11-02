import 'dart:async';

import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../core/logger/app_logger.dart';

/// Clean voice recognition service wrapping [SpeechToText].
class SpeechService {
  SpeechService({SpeechToText? speechToText})
    : _speech = speechToText ?? SpeechToText();

  final SpeechToText _speech;
  final StreamController<String> _wordsController =
      StreamController<String>.broadcast();
  final StreamController<bool> _listeningController =
      StreamController<bool>.broadcast();

  bool _isInitialized = false;

  /// Stream of recognized phrases as user speaks.
  Stream<String> get recognizedWordsStream => _wordsController.stream;

  /// Stream indicating whether microphone is actively listening.
  Stream<bool> get isListeningStream => _listeningController.stream;

  /// Whether speech recognition is initialized.
  bool get isInitialized => _isInitialized;

  /// Whether microphone is currently listening.
  bool get isListening => _speech.isListening;

  /// Initializes the speech recognition engine.
  Future<bool> initialize() async {
    if (_isInitialized) {
      return true;
    }
    try {
      _isInitialized = await _speech.initialize(
        onError: (SpeechRecognitionError error) {
          AppLogger.e('Speech recognition error: ${error.errorMsg}');
          if (!_listeningController.isClosed) {
            _listeningController.add(false);
          }
        },
        onStatus: (String status) {
          AppLogger.d('Speech recognition status: $status');
          if (!_listeningController.isClosed) {
            _listeningController.add(status == 'listening');
          }
        },
      );
      return _isInitialized;
    } catch (e, st) {
      AppLogger.e(
        'Failed to initialize speech service',
        error: e,
        stackTrace: st,
      );
      return false;
    }
  }

  /// Starts listening for gym voice commands.
  Future<void> startListening({
    required void Function(String result) onResult,
  }) async {
    if (!_isInitialized) {
      final bool initialized = await initialize();
      if (!initialized) {
        AppLogger.w('Cannot start listening: Speech recognition not available');
        return;
      }
    }

    try {
      await _speech.listen(
        onResult: (SpeechRecognitionResult result) {
          final String words = result.recognizedWords;
          if (!_wordsController.isClosed) {
            _wordsController.add(words);
          }
          if (result.finalResult) {
            stopListening();
            onResult(words);
          }
        },
        listenOptions: SpeechListenOptions(listenMode: ListenMode.dictation),
      );
      if (!_listeningController.isClosed) {
        _listeningController.add(true);
      }
    } catch (e, st) {
      AppLogger.e('Error starting speech listening', error: e, stackTrace: st);
      if (!_listeningController.isClosed) {
        _listeningController.add(false);
      }
    }
  }

  /// Stops listening.
  Future<void> stopListening() async {
    try {
      await _speech.stop();
      if (!_listeningController.isClosed) {
        _listeningController.add(false);
      }
    } catch (e, st) {
      AppLogger.e('Error stopping speech listening', error: e, stackTrace: st);
    }
  }

  /// Cleans up resources.
  void dispose() {
    _wordsController.close();
    _listeningController.close();
  }
}
