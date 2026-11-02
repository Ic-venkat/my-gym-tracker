import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/models/models.dart';

/// Card showing completed workout summary (title, date, duration, total volume).
class HistoryWorkoutCard extends StatelessWidget {
  const HistoryWorkoutCard({required this.workout, super.key});

  final Workout workout;

  String _formatDuration(int seconds) {
    final int minutes = seconds ~/ 60;
    return '$minutes mins';
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('EEE, MMM d, yyyy • h:mm a');
    final String formattedDate = formatter.format(workout.startedAt);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              workout.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              formattedDate,
              style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildStat(
                  'Volume',
                  '${workout.totalVolume.toStringAsFixed(0)} kg',
                ),
                _buildStat(
                  'Duration',
                  _formatDuration(workout.durationSeconds),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ],
    );
  }
}
