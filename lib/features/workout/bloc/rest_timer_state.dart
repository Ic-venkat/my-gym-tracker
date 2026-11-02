import 'package:equatable/equatable.dart';

/// State representing the current rest timer countdown.
class RestTimerState extends Equatable {
  const RestTimerState({this.remainingSeconds = 0, this.isActive = false});

  final int remainingSeconds;
  final bool isActive;

  RestTimerState copyWith({int? remainingSeconds, bool? isActive}) {
    return RestTimerState(
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => <Object?>[remainingSeconds, isActive];
}
