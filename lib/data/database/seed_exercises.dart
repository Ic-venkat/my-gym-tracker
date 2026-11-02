/// Pre-populated list of exercises across major muscle groups.
class SeedExercises {
  SeedExercises._();

  /// Default exercise dataset (id, name, muscleGroup, category).
  static const List<Map<String, String>> initialExercises =
      <Map<String, String>>[
        // Chest
        <String, String>{
          'id': 'ex_bench_press',
          'name': 'Barbell Bench Press',
          'muscleGroup': 'Chest',
          'category': 'Barbell',
        },
        <String, String>{
          'id': 'ex_incline_bench_press',
          'name': 'Incline Barbell Bench Press',
          'muscleGroup': 'Chest',
          'category': 'Barbell',
        },
        <String, String>{
          'id': 'ex_db_bench_press',
          'name': 'Dumbbell Bench Press',
          'muscleGroup': 'Chest',
          'category': 'Dumbbell',
        },
        <String, String>{
          'id': 'ex_incline_db_press',
          'name': 'Incline Dumbbell Press',
          'muscleGroup': 'Chest',
          'category': 'Dumbbell',
        },
        <String, String>{
          'id': 'ex_cable_fly',
          'name': 'Cable Chest Fly',
          'muscleGroup': 'Chest',
          'category': 'Cable',
        },
        <String, String>{
          'id': 'ex_dips_chest',
          'name': 'Chest Dips',
          'muscleGroup': 'Chest',
          'category': 'Bodyweight',
        },
        <String, String>{
          'id': 'ex_pushups',
          'name': 'Push-ups',
          'muscleGroup': 'Chest',
          'category': 'Bodyweight',
        },

        // Back
        <String, String>{
          'id': 'ex_deadlift',
          'name': 'Barbell Deadlift',
          'muscleGroup': 'Back',
          'category': 'Barbell',
        },
        <String, String>{
          'id': 'ex_barbell_row',
          'name': 'Barbell Bent-Over Row',
          'muscleGroup': 'Back',
          'category': 'Barbell',
        },
        <String, String>{
          'id': 'ex_lat_pulldown',
          'name': 'Lat Pulldown',
          'muscleGroup': 'Back',
          'category': 'Cable',
        },
        <String, String>{
          'id': 'ex_seated_cable_row',
          'name': 'Seated Cable Row',
          'muscleGroup': 'Back',
          'category': 'Cable',
        },
        <String, String>{
          'id': 'ex_pullups',
          'name': 'Pull-ups',
          'muscleGroup': 'Back',
          'category': 'Bodyweight',
        },
        <String, String>{
          'id': 'ex_chin_ups',
          'name': 'Chin-ups',
          'muscleGroup': 'Back',
          'category': 'Bodyweight',
        },
        <String, String>{
          'id': 'ex_db_row',
          'name': 'One-Arm Dumbbell Row',
          'muscleGroup': 'Back',
          'category': 'Dumbbell',
        },

        // Legs
        <String, String>{
          'id': 'ex_squat',
          'name': 'Barbell Back Squat',
          'muscleGroup': 'Legs',
          'category': 'Barbell',
        },
        <String, String>{
          'id': 'ex_front_squat',
          'name': 'Barbell Front Squat',
          'muscleGroup': 'Legs',
          'category': 'Barbell',
        },
        <String, String>{
          'id': 'ex_leg_press',
          'name': 'Leg Press',
          'muscleGroup': 'Legs',
          'category': 'Machine',
        },
        <String, String>{
          'id': 'ex_romanian_deadlift',
          'name': 'Romanian Deadlift',
          'muscleGroup': 'Legs',
          'category': 'Barbell',
        },
        <String, String>{
          'id': 'ex_leg_extension',
          'name': 'Leg Extension',
          'muscleGroup': 'Legs',
          'category': 'Machine',
        },
        <String, String>{
          'id': 'ex_leg_curl',
          'name': 'Lying Leg Curl',
          'muscleGroup': 'Legs',
          'category': 'Machine',
        },
        <String, String>{
          'id': 'ex_calf_raise',
          'name': 'Standing Calf Raise',
          'muscleGroup': 'Legs',
          'category': 'Machine',
        },
        <String, String>{
          'id': 'ex_bulgarian_split_squat',
          'name': 'Bulgarian Split Squat',
          'muscleGroup': 'Legs',
          'category': 'Dumbbell',
        },

        // Shoulders
        <String, String>{
          'id': 'ex_overhead_press',
          'name': 'Overhead Press',
          'muscleGroup': 'Shoulders',
          'category': 'Barbell',
        },
        <String, String>{
          'id': 'ex_db_shoulder_press',
          'name': 'Dumbbell Shoulder Press',
          'muscleGroup': 'Shoulders',
          'category': 'Dumbbell',
        },
        <String, String>{
          'id': 'ex_lateral_raise',
          'name': 'Dumbbell Lateral Raise',
          'muscleGroup': 'Shoulders',
          'category': 'Dumbbell',
        },
        <String, String>{
          'id': 'ex_face_pull',
          'name': 'Face Pull',
          'muscleGroup': 'Shoulders',
          'category': 'Cable',
        },
        <String, String>{
          'id': 'ex_rear_delt_fly',
          'name': 'Rear Delt Dumbbell Fly',
          'muscleGroup': 'Shoulders',
          'category': 'Dumbbell',
        },

        // Arms (Biceps & Triceps)
        <String, String>{
          'id': 'ex_barbell_curl',
          'name': 'Barbell Bicep Curl',
          'muscleGroup': 'Arms',
          'category': 'Barbell',
        },
        <String, String>{
          'id': 'ex_db_curl',
          'name': 'Dumbbell Hammer Curl',
          'muscleGroup': 'Arms',
          'category': 'Dumbbell',
        },
        <String, String>{
          'id': 'ex_tricep_pushdown',
          'name': 'Tricep Rope Pushdown',
          'muscleGroup': 'Arms',
          'category': 'Cable',
        },
        <String, String>{
          'id': 'ex_skull_crusher',
          'name': 'Skull Crusher',
          'muscleGroup': 'Arms',
          'category': 'Barbell',
        },
        <String, String>{
          'id': 'ex_preacher_curl',
          'name': 'Preacher Curl',
          'muscleGroup': 'Arms',
          'category': 'Machine',
        },

        // Core
        <String, String>{
          'id': 'ex_plank',
          'name': 'Plank',
          'muscleGroup': 'Core',
          'category': 'Bodyweight',
        },
        <String, String>{
          'id': 'ex_hanging_leg_raise',
          'name': 'Hanging Leg Raise',
          'muscleGroup': 'Core',
          'category': 'Bodyweight',
        },
        <String, String>{
          'id': 'ex_ab_wheel',
          'name': 'Ab Wheel Rollout',
          'muscleGroup': 'Core',
          'category': 'Bodyweight',
        },
        <String, String>{
          'id': 'ex_cable_crunch',
          'name': 'Cable Crunch',
          'muscleGroup': 'Core',
          'category': 'Cable',
        },
      ];
}
