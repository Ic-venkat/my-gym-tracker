import '../models/template_exercise.dart';
import '../models/workout_template.dart';

/// Pre-populated master list of scientific training splits and mobility flows.
const List<WorkoutTemplate> defaultWorkoutTemplates = <WorkoutTemplate>[
  pushDayTemplate,
  pullDayTemplate,
  legDayTemplate,
  calisthenicsUpperTemplate,
  yogaDecompressionTemplate,
];

const WorkoutTemplate pushDayTemplate = WorkoutTemplate(
  id: 'template_ppl_push',
  name: 'Push Day (Chest, Delts & Triceps)',
  category: 'PPL',
  description:
      'Compound and isolation horizontal/vertical pushing hypertrophy.',
  estimatedMinutes: 55,
  exercises: <TemplateExercise>[
    TemplateExercise(
      exerciseId: 'ex_bench',
      exerciseName: 'Barbell Bench Press',
      targetSets: 3,
      targetRepRange: '8-12',
      targetRestSeconds: 120,
      notes: 'Heavy compound: 45-degree elbow tuck, pause on chest.',
    ),
    TemplateExercise(
      exerciseId: 'ex_incline_db_press',
      exerciseName: 'Incline Dumbbell Press',
      targetSets: 3,
      targetRepRange: '8-12',
      targetRestSeconds: 90,
      notes: 'Upper chest emphasis: bench at 30 degrees.',
    ),
    TemplateExercise(
      exerciseId: 'ex_overhead_press',
      exerciseName: 'Overhead Press (OHP)',
      targetSets: 3,
      targetRepRange: '6-10',
      targetRestSeconds: 120,
      notes: 'Lock out overhead with active traps.',
    ),
    TemplateExercise(
      exerciseId: 'ex_lateral_raise',
      exerciseName: 'Dumbbell Lateral Raise',
      targetSets: 4,
      targetRepRange: '12-15',
      targetRestSeconds: 60,
      notes: 'Lead with elbows, slight forward torso lean.',
    ),
    TemplateExercise(
      exerciseId: 'ex_tricep_pushdown',
      exerciseName: 'Tricep Rope Pushdown',
      targetSets: 3,
      targetRepRange: '10-15',
      targetRestSeconds: 60,
      notes: 'Flare rope outward at full extension.',
    ),
  ],
);

const WorkoutTemplate pullDayTemplate = WorkoutTemplate(
  id: 'template_ppl_pull',
  name: 'Pull Day (Back, Traps & Biceps)',
  category: 'PPL',
  description:
      'Vertical and horizontal pulling targeting lat width and back thickness.',
  estimatedMinutes: 55,
  exercises: <TemplateExercise>[
    TemplateExercise(
      exerciseId: 'ex_deadlift',
      exerciseName: 'Barbell Deadlift',
      targetSets: 3,
      targetRepRange: '5-8',
      targetRestSeconds: 150,
      notes: 'Hip hinge: pack lats, drive floor away.',
    ),
    TemplateExercise(
      exerciseId: 'ex_pullups',
      exerciseName: 'Strict Pull-Ups',
      targetSets: 3,
      targetRepRange: '6-10',
      targetRestSeconds: 90,
      notes: 'Full hang stretch to chin clearing bar.',
    ),
    TemplateExercise(
      exerciseId: 'ex_barbell_row',
      exerciseName: 'Bent-Over Barbell Row',
      targetSets: 3,
      targetRepRange: '8-12',
      targetRestSeconds: 90,
      notes: 'Torso hinged at 45 degrees, pull toward naval.',
    ),
    TemplateExercise(
      exerciseId: 'ex_barbell_curl',
      exerciseName: 'Barbell Bicep Curl',
      targetSets: 3,
      targetRepRange: '10-12',
      targetRestSeconds: 60,
      notes: 'Strict form without lower back swing.',
    ),
  ],
);

const WorkoutTemplate legDayTemplate = WorkoutTemplate(
  id: 'template_ppl_legs',
  name: 'Leg Day (Quads, Hamstrings & Glutes)',
  category: 'PPL',
  description:
      'High-threshold lower body development with quad and posterior emphasis.',
  estimatedMinutes: 60,
  exercises: <TemplateExercise>[
    TemplateExercise(
      exerciseId: 'ex_squats',
      exerciseName: 'Barbell Back Squat',
      targetSets: 4,
      targetRepRange: '6-10',
      targetRestSeconds: 150,
      notes: 'Hit parallel depth, knees track over toes.',
    ),
    TemplateExercise(
      exerciseId: 'ex_rdl',
      exerciseName: 'Romanian Deadlift (RDL)',
      targetSets: 3,
      targetRepRange: '8-12',
      targetRestSeconds: 90,
      notes: 'Push hips backward until hamstring stretch.',
    ),
    TemplateExercise(
      exerciseId: 'ex_hanging_leg_raise',
      exerciseName: 'Hanging Leg Raise',
      targetSets: 3,
      targetRepRange: '10-15',
      targetRestSeconds: 60,
      notes: 'Curl pelvis without pendulum swing.',
    ),
  ],
);

const WorkoutTemplate calisthenicsUpperTemplate = WorkoutTemplate(
  id: 'template_calisthenics_upper',
  name: 'Calisthenics Bodyweight Track',
  category: 'Calisthenics',
  description: 'Gymnastic upper body strength, leverage control, and core stabilization.',
  estimatedMinutes: 45,
  exercises: <TemplateExercise>[
    TemplateExercise(
      exerciseId: 'ex_pullups',
      exerciseName: 'Strict Dead-Hang Pull-ups',
      targetSets: 3,
      targetRepRange: '8-12',
      targetRestSeconds: 90,
      notes: 'Tier 4 pull-up ladder benchmark.',
    ),
    TemplateExercise(
      exerciseId: 'ex_pushups',
      exerciseName: 'Standard Floor Push-ups',
      targetSets: 3,
      targetRepRange: '15-20',
      targetRestSeconds: 60,
      notes: 'Tier 2 planche progression.',
    ),
    TemplateExercise(
      exerciseId: 'ex_plank',
      exerciseName: 'Plank',
      targetSets: 3,
      targetRepRange: '30-60s',
      targetRestSeconds: 60,
      notes: 'Posterior pelvic tilt, active elbow depression.',
    ),
  ],
);

const WorkoutTemplate yogaDecompressionTemplate = WorkoutTemplate(
  id: 'template_yoga_decompression',
  name: 'Post-Lift Spinal & Hip Decompression',
  category: 'Mobility',
  description: 'Parasympathetic down-regulation, lumbar relief, and deep hip flexor mobility.',
  estimatedMinutes: 15,
  exercises: <TemplateExercise>[
    TemplateExercise(
      exerciseId: 'ex_cat_cow',
      exerciseName: 'Cat-Cow Mobility',
      targetSets: 2,
      targetRepRange: '10-12',
      targetRestSeconds: 30,
      notes: 'Synchronize arch with inhale, curl with exhale.',
    ),
    TemplateExercise(
      exerciseId: 'ex_hip_opener',
      exerciseName: 'Hip 90/90 Flow',
      targetSets: 2,
      targetRepRange: '8-10',
      targetRestSeconds: 45,
      notes: 'Tall spine, fold over front knee.',
    ),
  ],
);
