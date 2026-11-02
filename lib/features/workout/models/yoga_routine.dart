import 'package:equatable/equatable.dart';

import 'asana_pose.dart';

/// Pre-structured yoga and mobility flow targeting recovery and joint prehab.
class YogaRoutine extends Equatable {
  const YogaRoutine({
    required this.id,
    required this.name,
    required this.targetBenefit,
    required this.recommendedAfterMuscles,
    required this.estimatedMinutes,
    required this.poses,
  });

  final String id;
  final String name;
  final String targetBenefit;
  final List<String> recommendedAfterMuscles;
  final int estimatedMinutes;
  final List<AsanaPose> poses;

  /// Default registry of functional mobility and yoga routines.
  static const List<YogaRoutine> allRoutines = <YogaRoutine>[
    spinalHipDecompression,
    shoulderThoracicPrehab,
    vinyasaCoreFlow,
  ];

  /// Routine for post-squat/deadlift lumbar and hip decompression.
  static const YogaRoutine spinalHipDecompression = YogaRoutine(
    id: 'routine_spine_hip_decompression',
    name: 'Spinal & Hip Decompression Flow',
    targetBenefit: 'Lumbar traction, glute release, and hip flexor lengthening',
    recommendedAfterMuscles: <String>['Legs', 'Back', 'Lower Back'],
    estimatedMinutes: 8,
    poses: <AsanaPose>[
      AsanaPose(
        name: "Child's Pose",
        sanskritName: 'Balasana',
        holdSeconds: 60,
        targetMuscles: 'Erector Spinae, Latissimus Dorsi, Hips',
        cues: 'Knees wide, big toes touching, walk fingertips forward, sink hips onto heels.',
        breathingPattern: '4s inhale into lower ribs, 6s slow mouth exhale.',
      ),
      AsanaPose(
        name: 'Downward-Facing Dog',
        sanskritName: 'Adho Mukha Svanasana',
        holdSeconds: 45,
        targetMuscles: 'Hamstrings, Calves, Thoracic Spine, Shoulders',
        cues: 'Push ground away, elevate sit bones toward ceiling, pedal heels gently.',
        breathingPattern: 'Equal 4s inhale, 4s exhale through nose.',
      ),
      AsanaPose(
        name: 'Pigeon Pose',
        sanskritName: 'Eka Pada Rajakapotasana',
        holdSeconds: 60,
        isBilateral: true,
        targetMuscles: 'Piriformis, Gluteus Medius, Psoas',
        cues: 'Front shin parallel to mat front, square hips to floor, fold forward over front knee.',
        breathingPattern: 'Deep diaphragmatic breathing into pelvis.',
      ),
      AsanaPose(
        name: 'Couch Stretch (Kneeling Hip Flexor)',
        sanskritName: 'Anjaneyasana Variation',
        holdSeconds: 45,
        isBilateral: true,
        targetMuscles: 'Rectus Femoris, Iliopsoas',
        cues: 'Tuck tailbone forward (posterior pelvic tilt), squeeze trailing glute hard.',
        breathingPattern:
            '4s slow inhale, 4s exhale with deeper glute squeeze.',
      ),
      AsanaPose(
        name: 'Supine Spinal Twist',
        sanskritName: 'Supta Matsyendrasana',
        holdSeconds: 45,
        isBilateral: true,
        targetMuscles: 'Quadratus Lumborum, Obliques, Chest',
        cues: 'Shoulders pinned flat to floor, drop knee across body, gaze toward opposite hand.',
        breathingPattern: 'Gentle relaxed breath cadence.',
      ),
    ],
  );

  /// Routine for shoulder mobility, thoracic extension, and scapular health.
  static const YogaRoutine shoulderThoracicPrehab = YogaRoutine(
    id: 'routine_shoulder_thoracic_prehab',
    name: 'Shoulder & Thoracic Spine Prehab',
    targetBenefit:
        'Rotator cuff health, overhead reach, and thoracic extension',
    recommendedAfterMuscles: <String>['Chest', 'Shoulders', 'Arms'],
    estimatedMinutes: 6,
    poses: <AsanaPose>[
      AsanaPose(
        name: 'Cat-Cow Flow',
        sanskritName: 'Marjaryasana-Bitilasana',
        holdSeconds: 45,
        targetMuscles: 'Thoracolumbar Fascia, Cervical & Thoracic Spine',
        cues: 'Inhale arch and lift chin, exhale tuck pelvis and dome spine.',
        breathingPattern: 'Synchronized with spinal movement.',
      ),
      AsanaPose(
        name: 'Thread the Needle',
        sanskritName: 'Parsva Balasana',
        holdSeconds: 45,
        isBilateral: true,
        targetMuscles: 'Rhomboids, Posterior Deltoid, Thoracic Rotators',
        cues: 'Slide arm beneath chest palm up, rest ear on mat, breathe into back of shoulder.',
        breathingPattern:
            '4s inhale expanding ribcage, 4s exhale releasing tension.',
      ),
      AsanaPose(
        name: 'Puppy Pose (Melting Heart)',
        sanskritName: 'Uttana Shishosana',
        holdSeconds: 45,
        targetMuscles: 'Lats, Triceps, Upper Thoracic Spine',
        cues: 'Hips stacked above knees, walk hands forward, melt chest toward mat.',
        breathingPattern: 'Slow, deep thoracic breathing.',
      ),
      AsanaPose(
        name: 'Cobra Pose',
        sanskritName: 'Bhujangasana',
        holdSeconds: 30,
        targetMuscles: 'Pectoralis Major, Anterior Deltoids, Abdominals',
        cues: 'Elbows tight to ribs, peel chest off mat using back muscles, shoulders away from ears.',
        breathingPattern: 'Inhale lift chest, exhale hold posture.',
      ),
    ],
  );

  /// Active recovery day flow for core control and balance.
  static const YogaRoutine vinyasaCoreFlow = YogaRoutine(
    id: 'routine_vinyasa_core',
    name: 'Vinyasa Balance & Core Flow',
    targetBenefit: 'Active recovery, hip stability, and core activation',
    recommendedAfterMuscles: <String>['Core', 'Full Body'],
    estimatedMinutes: 7,
    poses: <AsanaPose>[
      AsanaPose(
        name: 'Warrior II',
        sanskritName: 'Virabhadrasana II',
        holdSeconds: 45,
        isBilateral: true,
        targetMuscles: 'Quadriceps, Adductors, Shoulders',
        cues: 'Front knee tracked over ankle, arms horizontal parallel to floor, steady gaze forward.',
        breathingPattern: 'Grounding 4-4 breath count.',
      ),
      AsanaPose(
        name: 'Extended Triangle Pose',
        sanskritName: 'Utthita Trikonasana',
        holdSeconds: 45,
        isBilateral: true,
        targetMuscles: 'Hamstrings, Groin, Spine, Lateral Torso',
        cues: 'Hips open, reach forward before dropping hand to shin, stack upper shoulder.',
        breathingPattern: 'Continuous rhythmic breathing.',
      ),
      AsanaPose(
        name: 'Boat Pose',
        sanskritName: 'Navasana',
        holdSeconds: 30,
        targetMuscles: 'Rectus Abdominis, Hip Flexors, Erector Spinae',
        cues: 'Balance on sit bones, lift shins parallel to floor, spine long without rounding.',
        breathingPattern: 'Short controlled breaths through nose.',
      ),
      AsanaPose(
        name: 'Bridge Pose',
        sanskritName: 'Setu Bandha Sarvangasana',
        holdSeconds: 45,
        targetMuscles: 'Gluteus Maximus, Hamstrings, Spinal Extensors',
        cues: 'Feet hip-width, press through heels, lift pelvis and interlace fingers under back.',
        breathingPattern: 'Deep belly expansion on inhale.',
      ),
    ],
  );

  @override
  List<Object?> get props => <Object?>[
    id,
    name,
    targetBenefit,
    recommendedAfterMuscles,
    estimatedMinutes,
    poses,
  ];
}
