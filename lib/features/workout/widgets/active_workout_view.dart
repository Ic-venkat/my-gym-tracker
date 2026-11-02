import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/models.dart';
import '../bloc/rest_timer_cubit.dart';
import '../bloc/rest_timer_state.dart';
import '../bloc/workout_bloc.dart';
import '../bloc/workout_event.dart';
import '../bloc/workout_state.dart';
import 'empty_workout_placeholder.dart';
import 'exercise_card_widget.dart';
import 'rest_timer_banner.dart';

/// Active workout session view displaying ongoing sets and rest banner.
class ActiveWorkoutView extends StatelessWidget {
  const ActiveWorkoutView({required this.state, super.key});

  final ActiveWorkoutState state;

  @override
  Widget build(BuildContext context) {
    final Map<String, List<WorkoutSet>> grouped = <String, List<WorkoutSet>>{};
    for (final WorkoutSet s in state.sets) {
      grouped.putIfAbsent(s.exerciseId, () => <WorkoutSet>[]).add(s);
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
          BlocBuilder<RestTimerCubit, RestTimerState>(
            builder: (BuildContext context, RestTimerState timerState) {
              if (timerState.isActive) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: RestTimerBanner(
                    remainingSeconds: timerState.remainingSeconds,
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          if (grouped.isEmpty)
            const EmptyWorkoutPlaceholder()
          else
            ...grouped.entries.map((MapEntry<String, List<WorkoutSet>> entry) {
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
