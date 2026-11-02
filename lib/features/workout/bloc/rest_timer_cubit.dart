import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../voice/tts_service.dart';
import 'rest_timer_state.dart';

/// Cubit managing rest countdown timers between sets.
class RestTimerCubit extends Cubit<RestTimerState> {
  RestTimerCubit({required TtsService ttsService})
    : _tts = ttsService,
      super(const RestTimerState());

  final TtsService _tts;
  Timer? _timer;

  /// Starts a countdown timer for [seconds].
  void startTimer(int seconds) {
    _timer?.cancel();
    if (seconds <= 0) {
      emit(const RestTimerState());
      return;
    }

    emit(RestTimerState(remainingSeconds: seconds, isActive: true));

    int count = seconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      count--;
      if (count <= 0) {
        t.cancel();
        emit(const RestTimerState());
        _tts.speak('Rest time is up! Ready for next set.');
      } else {
        emit(RestTimerState(remainingSeconds: count, isActive: true));
      }
    });
  }

  /// Cancels and skips the current rest timer.
  void skipTimer() {
    _timer?.cancel();
    emit(const RestTimerState());
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
