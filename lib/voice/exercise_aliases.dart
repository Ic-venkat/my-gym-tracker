/// Maps common lifter aliases and abbreviations to canonical names.
String normalizeExerciseName(String raw) {
  final String trimmed = raw.trim().toLowerCase();
  return switch (trimmed) {
    'bench' || 'flat bench' || 'bench press' => 'barbell bench press',
    'incline bench' => 'incline barbell bench press',
    'incline db' || 'incline db press' => 'incline dumbbell press',
    'squat' || 'squats' => 'barbell back squat',
    'deadlift' || 'deadlifts' => 'barbell deadlift',
    'ohp' || 'military press' => 'overhead press',
    'rdl' => 'romanian deadlift',
    'pullups' || 'pull ups' => 'pull-ups',
    'chinups' || 'chin ups' => 'chin-ups',
    'pushups' || 'push ups' => 'push-ups',
    'curls' || 'bicep curls' => 'barbell bicep curl',
    _ => trimmed,
  };
}
