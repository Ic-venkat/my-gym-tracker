import 'calisthenics_ladder.dart';
import 'calisthenics_step.dart';

/// Pre-populated calisthenics skill progressions.
const List<CalisthenicsLadder> defaultCalisthenicsLadders =
    <CalisthenicsLadder>[
      pullUpLadder,
      planchePushUpLadder,
      handstandPushUpLadder,
      frontLeverLadder,
    ];

const CalisthenicsLadder pullUpLadder = CalisthenicsLadder(
  id: 'ladder_pull_up',
  name: 'Pull-up to Muscle-up Progression',
  targetGoal: 'Strict Bar Muscle-Up & Vertical Pulling Mastery',
  steps: <CalisthenicsStep>[
    CalisthenicsStep(
      step: 1,
      exerciseId: 'ex_body_row',
      name: 'Australian Bodyweight Row',
      targetSets: 3,
      targetReps: 12,
      formCues: 'Bar at chest height, body straight, pull chest to bar.',
    ),
    CalisthenicsStep(
      step: 2,
      exerciseId: 'ex_scapular_pull',
      name: 'Scapular Pulls & Active Hang',
      targetSets: 3,
      targetReps: 30,
      isHoldSeconds: true,
      formCues: 'Depress scapula downward without bending elbows.',
    ),
    CalisthenicsStep(
      step: 3,
      exerciseId: 'ex_negative_pull_up',
      name: 'Negative Slow Eccentric Pull-ups',
      targetSets: 3,
      targetReps: 6,
      formCues: 'Jump up to chin over bar, lower for 4-5 seconds strictly.',
    ),
    CalisthenicsStep(
      step: 4,
      exerciseId: 'ex_pullups',
      name: 'Strict Dead-Hang Pull-ups',
      targetSets: 3,
      targetReps: 10,
      formCues: 'Full extension at bottom, chin clearing bar with zero kick.',
    ),
    CalisthenicsStep(
      step: 5,
      exerciseId: 'ex_l_sit_pull_up',
      name: 'L-Sit Pull-ups',
      targetSets: 3,
      targetReps: 8,
      formCues: 'Legs locked straight at 90 degrees throughout all reps.',
    ),
    CalisthenicsStep(
      step: 6,
      exerciseId: 'ex_muscle_up',
      name: 'Strict Bar Muscle-up',
      targetSets: 3,
      targetReps: 5,
      formCues: 'Explosive high pull to sternum, transition both arms simultaneously.',
    ),
  ],
);

const CalisthenicsLadder planchePushUpLadder = CalisthenicsLadder(
  id: 'ladder_planche',
  name: 'Push-up to Planche Progression',
  targetGoal: 'Straight-Arm Pushing & Planche Mastery',
  steps: <CalisthenicsStep>[
    CalisthenicsStep(
      step: 1,
      exerciseId: 'ex_incline_push_up',
      name: 'Incline Push-ups',
      targetSets: 3,
      targetReps: 15,
      formCues: 'Hands on bench, core braced, full lockout.',
    ),
    CalisthenicsStep(
      step: 2,
      exerciseId: 'ex_pushups',
      name: 'Standard Floor Push-ups',
      targetSets: 3,
      targetReps: 20,
      formCues: 'Chest touches floor, elbows at 45 degrees, posterior tilt.',
    ),
    CalisthenicsStep(
      step: 3,
      exerciseId: 'ex_diamond_push_up',
      name: 'Diamond Push-ups',
      targetSets: 3,
      targetReps: 15,
      formCues: 'Hands touching under sternum, full tricep extension.',
    ),
    CalisthenicsStep(
      step: 4,
      exerciseId: 'ex_pseudo_planche',
      name: 'Pseudo Planche Push-ups',
      targetSets: 3,
      targetReps: 10,
      formCues:
          'Hands turned outward, shoulders leaned far forward past wrists.',
    ),
    CalisthenicsStep(
      step: 5,
      exerciseId: 'ex_tuck_planche',
      name: 'Tuck Planche Isometric Hold',
      targetSets: 3,
      targetReps: 20,
      isHoldSeconds: true,
      formCues: 'Knees tucked into chest, arms locked, protract scapula.',
    ),
  ],
);

const CalisthenicsLadder handstandPushUpLadder = CalisthenicsLadder(
  id: 'ladder_hspu',
  name: 'Handstand Push-up Progression',
  targetGoal: 'Vertical Overhead Bodyweight Pressing Mastery',
  steps: <CalisthenicsStep>[
    CalisthenicsStep(
      step: 1,
      exerciseId: 'ex_pike_push_up',
      name: 'Pike Push-ups',
      targetSets: 3,
      targetReps: 12,
      formCues:
          'Hips high in V-shape, head travels forward of hands to tripod.',
    ),
    CalisthenicsStep(
      step: 2,
      exerciseId: 'ex_elevated_pike_push_up',
      name: 'Feet-Elevated Pike Push-ups',
      targetSets: 3,
      targetReps: 10,
      formCues: 'Feet on box, torso vertical, lower head controlled.',
    ),
    CalisthenicsStep(
      step: 3,
      exerciseId: 'ex_wall_handstand_hold',
      name: 'Chest-to-Wall Handstand Hold',
      targetSets: 3,
      targetReps: 45,
      isHoldSeconds: true,
      formCues: 'Nose to wall, push tall through shoulders, point toes.',
    ),
    CalisthenicsStep(
      step: 4,
      exerciseId: 'ex_wall_hspu',
      name: 'Wall Handstand Push-up',
      targetSets: 3,
      targetReps: 8,
      formCues:
          'Touch crown of head to mat lightly, press back to full lockout.',
    ),
    CalisthenicsStep(
      step: 5,
      exerciseId: 'ex_freestanding_hspu',
      name: 'Freestanding Handstand Push-up',
      targetSets: 3,
      targetReps: 5,
      formCues:
          'Balance via fingertips and palm pressure without wall support.',
    ),
  ],
);

const CalisthenicsLadder frontLeverLadder = CalisthenicsLadder(
  id: 'ladder_front_lever',
  name: 'Front Lever Progression',
  targetGoal: 'Horizontal Back & Straight-Arm Core Strength',
  steps: <CalisthenicsStep>[
    CalisthenicsStep(
      step: 1,
      exerciseId: 'ex_hollow_body_hold',
      name: 'Hollow Body Hold',
      targetSets: 3,
      targetReps: 45,
      isHoldSeconds: true,
      formCues: 'Lower back pinned to floor, arms overhead, toes pointed.',
    ),
    CalisthenicsStep(
      step: 2,
      exerciseId: 'ex_hanging_leg_raise',
      name: 'Hanging Leg Raise (Strict)',
      targetSets: 3,
      targetReps: 12,
      formCues: 'Dead hang, raise toes to bar without swinging.',
    ),
    CalisthenicsStep(
      step: 3,
      exerciseId: 'ex_tuck_front_lever',
      name: 'Tuck Front Lever Hold',
      targetSets: 3,
      targetReps: 20,
      isHoldSeconds: true,
      formCues: 'Knees to chest, pull down on bar with straight arms.',
    ),
    CalisthenicsStep(
      step: 4,
      exerciseId: 'ex_advanced_tuck_lever',
      name: 'Advanced Tuck Front Lever Hold',
      targetSets: 3,
      targetReps: 15,
      isHoldSeconds: true,
      formCues: 'Hips opened to 90 degrees, back flat parallel to floor.',
    ),
    CalisthenicsStep(
      step: 5,
      exerciseId: 'ex_full_front_lever',
      name: 'Full Front Lever Hold',
      targetSets: 3,
      targetReps: 10,
      isHoldSeconds: true,
      formCues: 'Entire body straight and rigid parallel to floor.',
    ),
  ],
);
