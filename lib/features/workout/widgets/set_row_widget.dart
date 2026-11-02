import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/database/app_database.dart';
import '../bloc/workout_bloc.dart';
import '../bloc/workout_event.dart';

/// Single set row showing set number, weight, reps, and delete action.
class SetRowWidget extends StatelessWidget {
  const SetRowWidget({required this.set, super.key});

  final WorkoutSet set;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF334155),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'Set ${set.setNumber}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          Text(
            '${set.weight.toStringAsFixed(set.weight.truncateToDouble() == set.weight ? 0 : 1)} kg',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          Text(
            '${set.reps} reps',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          IconButton(
            icon: const Icon(
              Icons.delete_outline,
              size: 20,
              color: Color(0xFF94A3B8),
            ),
            onPressed: () {
              context.read<WorkoutBloc>().add(DeleteSetEvent(set.id));
            },
          ),
        ],
      ),
    );
  }
}
