import 'package:equatable/equatable.dart';

/// Base class for history events.
sealed class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object?> get props => <Object?>[];
}

/// Event to load all completed past workouts.
final class LoadWorkoutHistory extends HistoryEvent {
  const LoadWorkoutHistory();
}

