import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/models.dart';
import '../../workout/bloc/workout_bloc.dart';
import '../../workout/bloc/workout_event.dart';
import '../../workout/bloc/workout_state.dart';
import '../../workout/widgets/add_set_dialog.dart';
import 'exercise_biomechanics_card.dart';
import 'exercise_cues_card.dart';
import 'exercise_video_preview.dart';

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

  void _onActionButtonPressed(BuildContext context) {
    Navigator.of(context).pop();
    if (onSelect != null) {
      onSelect!();
      return;
    }

    final WorkoutState workoutState = context.read<WorkoutBloc>().state;
    if (workoutState is ActiveWorkoutState) {
      showDialog<void>(
        context: context,
        builder: (_) => AddSetDialog(
          exerciseName: exercise.name,
          onLog: (int reps, double weight) {
            context.read<WorkoutBloc>().add(
              LogSetEvent(exerciseId: exercise.id, reps: reps, weight: weight),
            );
          },
        ),
      );
    } else {
      context.read<WorkoutBloc>().add(
        StartWorkoutEvent(title: exercise.muscleGroup),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final WorkoutState workoutState = context.watch<WorkoutBloc>().state;
    final bool isActive = workoutState is ActiveWorkoutState;

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      exercise.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFF334155)),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(20),
                children: <Widget>[
                  ExerciseVideoPreview(exercise: exercise),
                  const SizedBox(height: 12),
                  ExerciseBiomechanicsCard(exercise: exercise),
                  const SizedBox(height: 16),
                  ExerciseCuesCard(exercise: exercise),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => _onActionButtonPressed(context),
                    icon: Icon(isActive ? Icons.add_task : Icons.play_arrow),
                    label: Text(
                      isActive
                          ? 'Log Set for ${exercise.name}'
                          : 'Start Workout with this Exercise',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
