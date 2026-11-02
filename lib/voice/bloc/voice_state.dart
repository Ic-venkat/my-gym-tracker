import 'package:equatable/equatable.dart';

/// Base class for voice recognition states.
sealed class VoiceState extends Equatable {
  const VoiceState();

  @override
  List<Object?> get props => <Object?>[];
}

/// Voice service is idle and ready to listen.
final class VoiceIdle extends VoiceState {
  const VoiceIdle();
}

/// Voice service is actively listening to speech input.
final class VoiceListening extends VoiceState {
  const VoiceListening({this.partialWords = ''});

  final String partialWords;

  @override
  List<Object?> get props => <Object?>[partialWords];
}

/// Final transcribed text was received.
final class VoiceSuccess extends VoiceState {
  const VoiceSuccess(this.transcribedText);

  final String transcribedText;

  @override
  List<Object?> get props => <Object?>[transcribedText];
}

/// Error occurred during speech recognition.
final class VoiceFailure extends VoiceState {
  const VoiceFailure(this.errorMessage);

  final String errorMessage;

  @override
  List<Object?> get props => <Object?>[errorMessage];
}
