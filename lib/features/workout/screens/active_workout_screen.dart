import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/database/app_database.dart';
import '../bloc/workout_bloc.dart';
import '../bloc/workout_event.dart';
import '../bloc/workout_state.dart';
import '../widgets/exercise_card_widget.dart';
import '../widgets/rest_timer_banner.dart';
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
          ActiveWorkoutState() => _buildActiveView(context, state),
          _ => const StartWorkoutView(),
        };
      },
    );
  }

  Widget _buildActiveView(BuildContext context, ActiveWorkoutState state) {
    // Group sets by exercise
    final Map<String, List<WorkoutSet>> groupedSets =
        <String, List<WorkoutSet>>{};
    for (final WorkoutSet s in state.sets) {
      groupedSets.putIfAbsent(s.exerciseId, () => <WorkoutSet>[]).add(s);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(state.workout.title),
        actions: <Widget>[
          TextButton.icon(
            onPressed: () {
              context.read<WorkoutBloc>().add(const FinishWorkoutEvent());
            },
            icon: const Icon(Icons.check_circle, color: Color(0xFF10B981)),
            label: const Text(
              'Finish',
              style: TextStyle(
                color: Color(0xFF10B981),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          if (state.isRestTimerActive) ...<Widget>[
            RestTimerBanner(remainingSeconds: state.remainingRestSeconds),
            const SizedBox(height: 16),
          ],
          if (groupedSets.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Text(
                  'No exercises logged yet.\nUse voice: "Log bench press 10 reps 80 kg"\nor select from the Exercises tab.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 16),
                ),
              ),
            )
          else
            ...groupedSets.entries.map((
              MapEntry<String, List<WorkoutSet>> entry,
            ) {
              final Exercise? ex = state.exercises[entry.key];
              if (ex == null) {
                return const SizedBox.shrink();
              }
              return ExerciseCardWidget(
                key: ValueKey<String>(entry.key),
                exercise: ex,
                sets: entry.value,
              );
            }),
        ],
      ),
    );
  }
}
