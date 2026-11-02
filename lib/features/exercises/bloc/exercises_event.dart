import 'package:equatable/equatable.dart';

/// Base class for all exercise events.
sealed class ExercisesEvent extends Equatable {
  const ExercisesEvent();

  @override
  List<Object?> get props => <Object?>[];
}

/// Event to load all exercises with optional category filter.
final class LoadExercises extends ExercisesEvent {
  const LoadExercises({this.category = 'All'});

  final String category;

  @override
  List<Object?> get props => <Object?>[category];
}

/// Event to search exercises by keyword.
final class SearchExercises extends ExercisesEvent {
  const SearchExercises(this.query);

  final String query;

  @override
  List<Object?> get props => <Object?>[query];
}

/// Event to create a new custom exercise.
final class AddCustomExercise extends ExercisesEvent {
  const AddCustomExercise({
    required this.name,
    required this.muscleGroup,
    required this.category,
    this.instructions,
  });

  final String name;
  final String muscleGroup;
  final String category;
  final String? instructions;

  @override
  List<Object?> get props => <Object?>[
    name,
    muscleGroup,
    category,
    instructions,
  ];
}
