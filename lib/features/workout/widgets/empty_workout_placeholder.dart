import 'package:flutter/material.dart';

/// Placeholder displayed when an active workout has no logged exercises yet.
class EmptyWorkoutPlaceholder extends StatelessWidget {
  const EmptyWorkoutPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Text(
          'No exercises logged yet.\nUse voice: "Log bench press 10 reps 80 kg"\nor select from Exercises tab.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF94A3B8), fontSize: 16),
        ),
      ),
    );
  }
}
