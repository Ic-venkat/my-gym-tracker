import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/result.dart';
import '../../../data/database/app_database.dart';
import '../../../data/repositories/exercise_repository.dart';
import 'exercises_event.dart';
import 'exercises_state.dart';

/// BLoC managing exercise catalog, search, and custom exercises.
class ExercisesBloc extends Bloc<ExercisesEvent, ExercisesState> {
  ExercisesBloc({required ExerciseRepository exerciseRepository})
    : _repo = exerciseRepository,
      super(const ExercisesInitial()) {
    on<LoadExercises>(_onLoadExercises);
    on<SearchExercises>(_onSearchExercises);
    on<AddCustomExercise>(_onAddCustomExercise);
  }

  final ExerciseRepository _repo;
  List<Exercise> _allExercises = <Exercise>[];

  Future<void> _onLoadExercises(
    LoadExercises event,
    Emitter<ExercisesState> emit,
  ) async {
    emit(const ExercisesLoading());
    final Result<List<Exercise>> result = await _repo.getAllExercises();
    switch (result) {
      case Success<List<Exercise>>(data: final List<Exercise> list):
        _allExercises = list;
        final List<Exercise> filtered = event.category == 'All'
            ? list
            : list
                  .where((Exercise e) => e.muscleGroup == event.category)
                  .toList();
        emit(
          ExercisesLoaded(
            exercises: filtered,
            selectedCategory: event.category,
          ),
        );
      case Failure<List<Exercise>>(message: final String msg):
        emit(ExercisesError(msg));
    }
  }

  Future<void> _onSearchExercises(
    SearchExercises event,
    Emitter<ExercisesState> emit,
  ) async {
    final String query = event.query.trim().toLowerCase();
    if (query.isEmpty) {
      emit(ExercisesLoaded(exercises: _allExercises));
      return;
    }

    final List<Exercise> matches = _allExercises.where((Exercise e) {
      return e.name.toLowerCase().contains(query) ||
          e.muscleGroup.toLowerCase().contains(query);
    }).toList();

    emit(ExercisesLoaded(exercises: matches));
  }

  Future<void> _onAddCustomExercise(
    AddCustomExercise event,
    Emitter<ExercisesState> emit,
  ) async {
    final Result<Exercise> result = await _repo.createCustomExercise(
      name: event.name,
      muscleGroup: event.muscleGroup,
      category: event.category,
      instructions: event.instructions,
    );

    if (result.isSuccess) {
      add(const LoadExercises());
    } else if (result is Failure<Exercise>) {
      emit(ExercisesError(result.message));
    }
  }
}
