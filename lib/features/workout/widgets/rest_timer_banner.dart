import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/workout_bloc.dart';
import '../bloc/workout_event.dart';

/// Floating banner showing active rest timer countdown and skip control.
class RestTimerBanner extends StatelessWidget {
  const RestTimerBanner({required this.remainingSeconds, super.key});

  final int remainingSeconds;

  String _formatTime(int totalSec) {
    final int minutes = totalSec ~/ 60;
    final int seconds = totalSec % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF59E0B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(Icons.timer, color: Colors.black, size: 22),
              const SizedBox(width: 8),
              Text(
                'Rest: ${_formatTime(remainingSeconds)}',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              context.read<WorkoutBloc>().add(const TriggerRestTimer(0));
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.white.withValues(alpha: 0.3),
            ),
            child: const Text('Skip'),
          ),
        ],
      ),
    );
  }
}
