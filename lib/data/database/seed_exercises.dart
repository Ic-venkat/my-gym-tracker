import 'seeds/arms_core_calisthenics_seeds.dart';
import 'seeds/chest_back_seeds.dart';
import 'seeds/legs_shoulders_seeds.dart';
import 'seeds/mobility_stretches_cardio_seeds.dart';
import 'seeds/seed_model.dart';

/// Pre-populated master registry of exercises across major muscle groups.
class SeedExercises {
  SeedExercises._();

  /// Comprehensive exercise dataset with biomechanics, posture cues and video guidance.
  static const List<SeedExerciseData> allSeeds = <SeedExerciseData>[
    ...chestBackSeeds,
    ...legsShouldersSeeds,
    ...armsCoreCalisthenicsSeeds,
    ...mobilityStretchesCardioSeeds,
  ];

  /// Backward-compatible representation for simple map consumption.
  static List<Map<String, String>> get initialExercises =>
      allSeeds.map((SeedExerciseData s) {
        return <String, String>{
          'id': s.id,
          'name': s.name,
          'muscleGroup': s.muscleGroup,
          'category': s.category,
        };
      }).toList();
}
