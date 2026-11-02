import 'package:equatable/equatable.dart';

import 'calisthenics_data.dart';
import 'calisthenics_step.dart';

/// A structured progressive ladder for bodyweight gymnastic skills.
class CalisthenicsLadder extends Equatable {
  const CalisthenicsLadder({
    required this.id,
    required this.name,
    required this.targetGoal,
    required this.steps,
  });

  final String id;
  final String name;
  final String targetGoal;
  final List<CalisthenicsStep> steps;

  /// Finds step index by exercise identifier or name.
  int? findStepIndex(String identifier) {
    final String clean = identifier.toLowerCase().trim();
    for (int i = 0; i < steps.length; i++) {
      if (steps[i].exerciseId.toLowerCase() == clean ||
          steps[i].name.toLowerCase() == clean) {
        return i;
      }
    }
    return null;
  }

  /// Registry of official scientific bodyweight progression ladders.
  static List<CalisthenicsLadder> get allLadders => defaultCalisthenicsLadders;

  @override
  List<Object?> get props => <Object?>[id, name, targetGoal, steps];
}
