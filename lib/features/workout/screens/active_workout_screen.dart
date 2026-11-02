import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/rest_timer_cubit.dart';
import '../bloc/workout_bloc.dart';
import '../bloc/workout_state.dart';
import '../widgets/active_workout_view.dart';
import '../widgets/start_workout_view.dart';

/// Main screen displaying the active workout session or starting view.
class ActiveWorkoutScreen extends StatelessWidget {
  const ActiveWorkoutScreen({super.key});

  void _handleStateMessages(BuildContext context, WorkoutState state) {
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
  }

  void _handleRestTimer(BuildContext context, WorkoutState state) {
    final RestTimerCubit timer = context.read<RestTimerCubit>();
    if (state is WorkoutCompletedState) {
      timer.skipTimer();
    } else if (state is ActiveWorkoutState &&
        state.restCountdownSeconds != null) {
      timer.startTimer(state.restCountdownSeconds!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WorkoutBloc, WorkoutState>(
      listenWhen: (WorkoutState prev, WorkoutState curr) {
        if (curr is WorkoutCompletedState) return true;
        if (prev is ActiveWorkoutState && curr is ActiveWorkoutState) {
          return curr.restTriggerId != prev.restTriggerId;
        }
        return false;
      },
      listener: _handleRestTimer,
      child: BlocConsumer<WorkoutBloc, WorkoutState>(
        listener: _handleStateMessages,
        builder: (BuildContext context, WorkoutState state) {
          return switch (state) {
            WorkoutLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            NoActiveWorkout() ||
            WorkoutCompletedState() => const StartWorkoutView(),
            ActiveWorkoutState() => ActiveWorkoutView(state: state),
            _ => const StartWorkoutView(),
          };
        },
      ),
    );
  }
}
