import 'package:bloc_test/bloc_test.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/data/database/app_database.dart';
import 'package:gym_tracker/data/repositories/workout_repository.dart';
import 'package:gym_tracker/features/history/bloc/history_bloc.dart';
import 'package:gym_tracker/features/history/bloc/history_event.dart';
import 'package:gym_tracker/features/history/bloc/history_state.dart';

void main() {
  late AppDatabase db;
  late WorkoutRepository workoutRepo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    workoutRepo = WorkoutRepository(database: db);
  });

  tearDown(() async {
    await db.close();
  });

  group('HistoryBloc', () {
    blocTest<HistoryBloc, HistoryState>(
      'loads completed workouts successfully',
      build: () => HistoryBloc(workoutRepository: workoutRepo),
      act: (HistoryBloc bloc) => bloc.add(const LoadWorkoutHistory()),
      expect: () => <Matcher>[
        isA<HistoryLoading>(),
        isA<HistoryLoaded>().having(
          (HistoryLoaded s) => s.workouts.isEmpty,
          'empty',
          isTrue,
        ),
      ],
    );
  });
}
