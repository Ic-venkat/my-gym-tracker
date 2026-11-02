import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/workout_bloc.dart';
import '../bloc/workout_state.dart';
import '../widgets/active_workout_view.dart';
import '../widgets/start_workout_view.dart';

/// Main screen displaying the active workout session or starting view.
class ActiveWorkoutScreen extends StatelessWidget {
  const ActiveWorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WorkoutBloc, WorkoutState>(
      listener: (BuildContext context, WorkoutState state) {
        if (state is WorkoutCompletedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Saved "${state.workout.title}"! Total: ${state.workout.totalVolume} kg',
              ),
              backgroundColor: const Color(0xFF10B981),
            ),
          );
        } else if (state is WorkoutError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: const Color(0xFFEF4444),
            ),
          );
        }
      },
      builder: (BuildContext context, WorkoutState state) {
        return switch (state) {
          WorkoutLoading() => const Center(child: CircularProgressIndicator()),
          NoActiveWorkout() ||
          WorkoutCompletedState() => const StartWorkoutView(),
          ActiveWorkoutState() => ActiveWorkoutView(state: state),
          _ => const StartWorkoutView(),
        };
      },
    );
  }
}
