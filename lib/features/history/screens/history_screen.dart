import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/database/app_database.dart';
import '../bloc/history_bloc.dart';
import '../bloc/history_event.dart';
import '../bloc/history_state.dart';
import '../widgets/history_workout_card.dart';

/// Screen displaying user's completed workout logs and history.
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout History')),
      body: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (BuildContext context, HistoryState state) {
          return switch (state) {
            HistoryLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            HistoryLoaded(workouts: final List<Workout> list) =>
              list.isEmpty
                  ? const Center(
                      child: Text(
                        'No completed workouts yet.\nComplete a workout to see it here!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 16,
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        context.read<HistoryBloc>().add(
                          const LoadWorkoutHistory(),
                        );
                      },
                      child: ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (BuildContext context, int index) {
                          final Workout w = list[index];
                          return HistoryWorkoutCard(
                            key: ValueKey<String>(w.id),
                            workout: w,
                          );
                        },
                      ),
                    ),
            HistoryError(message: final String msg) => Center(child: Text(msg)),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}
