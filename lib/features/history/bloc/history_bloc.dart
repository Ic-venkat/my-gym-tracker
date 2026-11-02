import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/result.dart';
import '../../../data/database/app_database.dart';
import '../../../data/repositories/workout_repository.dart';
import 'history_event.dart';
import 'history_state.dart';

/// BLoC managing workout history list.
class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc({required WorkoutRepository workoutRepository})
    : _repo = workoutRepository,
      super(const HistoryInitial()) {
    on<LoadWorkoutHistory>(_onLoadHistory);
  }

  final WorkoutRepository _repo;

  Future<void> _onLoadHistory(
    LoadWorkoutHistory event,
    Emitter<HistoryState> emit,
  ) async {
    emit(const HistoryLoading());
    final Result<List<Workout>> result = await _repo.getCompletedWorkouts();
    switch (result) {
      case Success<List<Workout>>(data: final List<Workout> list):
        emit(HistoryLoaded(list));
      case Failure<List<Workout>>(message: final String msg):
        emit(HistoryError(msg));
    }
  }
}
