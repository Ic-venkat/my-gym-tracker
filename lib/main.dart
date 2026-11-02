import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'data/database/app_database.dart';
import 'data/repositories/exercise_repository.dart';
import 'data/repositories/workout_repository.dart';
import 'features/exercises/bloc/exercises_bloc.dart';
import 'features/exercises/bloc/exercises_event.dart';
import 'features/history/bloc/history_bloc.dart';
import 'features/history/bloc/history_event.dart';
import 'features/home/screens/home_screen.dart';
import 'features/workout/bloc/rest_timer_cubit.dart';
import 'features/workout/bloc/workout_bloc.dart';
import 'features/workout/bloc/workout_event.dart';
import 'voice/speech_service.dart';
import 'voice/tts_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final AppDatabase database = AppDatabase();
  final ExerciseRepository exerciseRepository = ExerciseRepository(
    database: database,
  );
  final WorkoutRepository workoutRepository = WorkoutRepository(
    database: database,
  );

  final TtsService ttsService = TtsService();
  final SpeechService speechService = SpeechService();

  runApp(
    GymTrackerApp(
      exerciseRepository: exerciseRepository,
      workoutRepository: workoutRepository,
      ttsService: ttsService,
      speechService: speechService,
    ),
  );
}

/// Root widget for GymTracker.
class GymTrackerApp extends StatelessWidget {
  const GymTrackerApp({
    required this.exerciseRepository,
    required this.workoutRepository,
    required this.ttsService,
    required this.speechService,
    super.key,
  });

  final ExerciseRepository exerciseRepository;
  final WorkoutRepository workoutRepository;
  final TtsService ttsService;
  final SpeechService speechService;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RestTimerCubit>(
          create: (_) => RestTimerCubit(ttsService: ttsService),
        ),
        BlocProvider<ExercisesBloc>(
          create: (_) =>
              ExercisesBloc(exerciseRepository: exerciseRepository)
                ..add(const LoadExercises()),
        ),
        BlocProvider<WorkoutBloc>(
          create: (BuildContext c) => WorkoutBloc(
            workoutRepository: workoutRepository,
            exerciseRepository: exerciseRepository,
            ttsService: ttsService,
            restTimerCubit: c.read<RestTimerCubit>(),
          )..add(const CheckActiveWorkout()),
        ),
        BlocProvider<HistoryBloc>(
          create: (_) =>
              HistoryBloc(workoutRepository: workoutRepository)
                ..add(const LoadWorkoutHistory()),
        ),
      ],
      child: MaterialApp(
        title: 'GymTracker',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: HomeScreen(speechService: speechService),
      ),
    );
  }
}
