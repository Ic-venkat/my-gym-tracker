import 'package:equatable/equatable.dart';

import '../../../data/database/app_database.dart';

/// Base class for all exercise states.
sealed class ExercisesState extends Equatable {
  const ExercisesState();

  @override
  List<Object?> get props => <Object?>[];
}

/// Initial exercise state before loading.
final class ExercisesInitial extends ExercisesState {
  const ExercisesInitial();
}

/// State when exercises are being fetched.
final class ExercisesLoading extends ExercisesState {
  const ExercisesLoading();
}

/// State when exercises are successfully loaded.
final class ExercisesLoaded extends ExercisesState {
  const ExercisesLoaded({
    required this.exercises,
    this.selectedCategory = 'All',
  });

  final List<Exercise> exercises;
  final String selectedCategory;

  @override
  List<Object?> get props => <Object?>[exercises, selectedCategory];
}

/// State when an error occurs loading exercises.
final class ExercisesError extends ExercisesState {
  const ExercisesError(this.message);

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}

