import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/models.dart';
import '../bloc/rest_timer_cubit.dart';
import '../bloc/rest_timer_state.dart';
import '../bloc/workout_state.dart';
import 'empty_workout_placeholder.dart';
import 'exercise_card_widget.dart';
import 'rest_timer_banner.dart';

/// Scrollable list displaying the rest timer and exercise cards.
class ActiveWorkoutSetList extends StatelessWidget {
  const ActiveWorkoutSetList({
    required this.state,
    required this.groupedSets,
    super.key,
  });

  final ActiveWorkoutState state;
  final Map<String, List<WorkoutSet>> groupedSets;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
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
        if (groupedSets.isEmpty)
          const EmptyWorkoutPlaceholder()
        else
          ...groupedSets.entries.map((
            MapEntry<String, List<WorkoutSet>> entry,
          ) {
            final Exercise? ex = state.exercises[entry.key];
            if (ex == null) return const SizedBox.shrink();
            return ExerciseCardWidget(
              key: ValueKey<String>(entry.key),
              exercise: ex,
              sets: entry.value,
            );
          }),
      ],
    );
  }
}
