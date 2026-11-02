import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/core/utils/result.dart';
import 'package:gym_tracker/data/models/models.dart';
import 'package:gym_tracker/data/repositories/workout_repository.dart';
import 'package:gym_tracker/features/history/bloc/history_bloc.dart';
import 'package:gym_tracker/features/history/bloc/history_event.dart';
import 'package:gym_tracker/features/history/bloc/history_state.dart';
import 'package:mocktail/mocktail.dart';

class MockWorkoutRepository extends Mock implements WorkoutRepository {}

void main() {
  late MockWorkoutRepository mockRepo;

  final Workout sampleWorkout = Workout(
    id: 'w_hist_1',
    title: 'Leg Day',
    startedAt: DateTime.now().subtract(const Duration(hours: 1)),
    completedAt: DateTime.now(),
    totalVolume: 3500.0,
    durationSeconds: 3600,
  );

  setUp(() {
    mockRepo = MockWorkoutRepository();
  });

  group('HistoryBloc', () {
    blocTest<HistoryBloc, HistoryState>(
      'loads completed workouts successfully',
      build: () {
        when(() => mockRepo.getCompletedWorkouts()).thenAnswer(
          (_) async => Success<List<Workout>>(<Workout>[sampleWorkout]),
        );
        return HistoryBloc(workoutRepository: mockRepo);
      },
      act: (HistoryBloc bloc) => bloc.add(const LoadWorkoutHistory()),
      expect: () => <Matcher>[
        isA<HistoryLoading>(),
        isA<HistoryLoaded>().having(
          (HistoryLoaded s) => s.workouts.first.title,
          'title',
          'Leg Day',
        ),
      ],
    );

    blocTest<HistoryBloc, HistoryState>(
      'emits HistoryError when repository fails',
      build: () {
        when(
          () => mockRepo.getCompletedWorkouts(),
        ).thenAnswer((_) async => const Failure<List<Workout>>('Disk error'));
        return HistoryBloc(workoutRepository: mockRepo);
      },
      act: (HistoryBloc bloc) => bloc.add(const LoadWorkoutHistory()),
      expect: () => <Matcher>[
        isA<HistoryLoading>(),
        isA<HistoryError>().having(
          (HistoryError s) => s.message,
          'message',
          'Disk error',
        ),
      ],
    );
  });
}
