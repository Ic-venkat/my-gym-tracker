import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/models.dart';
import '../../workout/bloc/workout_bloc.dart';
import '../../workout/bloc/workout_state.dart';
import 'exercise_detail_action_handler.dart';
import 'exercise_detail_content.dart';
import 'exercise_detail_header.dart';

/// Modal bottom sheet presenting full posture, video, and biomechanical cues.
class ExerciseDetailSheet extends StatelessWidget {
  const ExerciseDetailSheet({required this.exercise, this.onSelect, super.key});

  final Exercise exercise;
  final VoidCallback? onSelect;

  static Future<void> show(
    BuildContext context,
    Exercise exercise, {
    VoidCallback? onSelect,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider<WorkoutBloc>.value(
        value: context.read<WorkoutBloc>(),
        child: ExerciseDetailSheet(exercise: exercise, onSelect: onSelect),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isActive =
        context.watch<WorkoutBloc>().state is ActiveWorkoutState;

    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (BuildContext _, ScrollController scrollController) {
        return Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF475569),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ExerciseDetailHeader(title: exercise.name),
            const Divider(height: 1, color: Color(0xFF334155)),
            Expanded(
              child: ExerciseDetailContent(
                exercise: exercise,
                isActive: isActive,
                onAction: () =>
                    handleDetailSheetAction(context, exercise, onSelect),
                scrollController: scrollController,
              ),
            ),
          ],
        );
      },
    );
  }
}
