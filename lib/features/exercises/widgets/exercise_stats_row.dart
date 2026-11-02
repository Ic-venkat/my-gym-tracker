import 'package:flutter/material.dart';

/// Row displaying target rep range, rest interval, and load increment.
class ExerciseStatsRow extends StatelessWidget {
  const ExerciseStatsRow({
    required this.repRange,
    required this.restSeconds,
    required this.incrementKg,
    super.key,
  });

  final String repRange;
  final int restSeconds;
  final double incrementKg;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _buildItem('Rep Range', repRange, Icons.repeat),
        _buildItem('Rest', '${restSeconds}s', Icons.timer_outlined),
        _buildItem('Increment', '+$incrementKg kg', Icons.fitness_center),
      ],
    );
  }

  Widget _buildItem(String label, String value, IconData icon) {
    return Column(
      children: <Widget>[
        Icon(icon, size: 16, color: const Color(0xFF94A3B8)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        Text(
          label,
          style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
        ),
      ],
    );
  }
}
