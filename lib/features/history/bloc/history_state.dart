import 'package:equatable/equatable.dart';

import '../../../data/database/app_database.dart';

/// Base class for history states.
sealed class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object?> get props => <Object?>[];
}

/// Initial state before history is loaded.
final class HistoryInitial extends HistoryState {
  const HistoryInitial();
}

/// State when history is loading.
final class HistoryLoading extends HistoryState {
  const HistoryLoading();
}

/// State containing loaded workout history.
final class HistoryLoaded extends HistoryState {
  const HistoryLoaded(this.workouts);

  final List<Workout> workouts;

  @override
  List<Object?> get props => <Object?>[workouts];
}

/// Error state for history loading failure.
final class HistoryError extends HistoryState {
  const HistoryError(this.message);

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}

