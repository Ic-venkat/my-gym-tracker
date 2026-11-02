import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/voice/command_parser.dart';
import 'package:gym_tracker/voice/voice_command.dart';

void main() {
  group('CommandParser', () {
    test('parses StartWorkoutCommand with default title', () {
      final VoiceCommand result = CommandParser.parse('start workout');
      expect(result, isA<StartWorkoutCommand>());
      expect((result as StartWorkoutCommand).title, 'Workout');
    });

    test('parses StartWorkoutCommand with custom title', () {
      final VoiceCommand result = CommandParser.parse(
        'start workout chest day',
      );
      expect(result, isA<StartWorkoutCommand>());
      expect((result as StartWorkoutCommand).title, 'Chest day');
    });

    test('parses EndWorkoutCommand', () {
      expect(CommandParser.parse('end workout'), isA<EndWorkoutCommand>());
      expect(CommandParser.parse('finish workout'), isA<EndWorkoutCommand>());
      expect(CommandParser.parse('complete workout'), isA<EndWorkoutCommand>());
    });

    test('parses RestTimerCommand with seconds', () {
      final VoiceCommand result = CommandParser.parse('rest 90 seconds');
      expect(result, isA<RestTimerCommand>());
      expect((result as RestTimerCommand).seconds, 90);
    });

    test('parses RestTimerCommand with minutes', () {
      final VoiceCommand result = CommandParser.parse('timer 2 minutes');
      expect(result, isA<RestTimerCommand>());
      expect((result as RestTimerCommand).seconds, 120);
    });

    test('parses AddExerciseCommand', () {
      final VoiceCommand result = CommandParser.parse(
        'add exercise barbell squat',
      );
      expect(result, isA<AddExerciseCommand>());
      expect((result as AddExerciseCommand).exerciseName, 'barbell squat');
    });

    test('parses LogSetCommand with 3 sets 10 reps 80 kilos', () {
      final VoiceCommand result = CommandParser.parse(
        'log bench press 3 sets 10 reps 80 kilos',
      );
      expect(result, isA<LogSetCommand>());
      final LogSetCommand cmd = result as LogSetCommand;
      expect(cmd.exerciseName, 'bench press');
      expect(cmd.sets, 3);
      expect(cmd.reps, 10);
      expect(cmd.weight, 80.0);
    });

    test('parses LogSetCommand shorthand (10 reps at 100 kg)', () {
      final VoiceCommand result = CommandParser.parse(
        'squat 10 reps at 100 kg',
      );
      expect(result, isA<LogSetCommand>());
      final LogSetCommand cmd = result as LogSetCommand;
      expect(cmd.exerciseName, 'squat');
      expect(cmd.reps, 10);
      expect(cmd.weight, 100.0);
    });

    test('returns UnknownCommand for gibberish', () {
      final VoiceCommand result = CommandParser.parse('hello how are you');
      expect(result, isA<UnknownCommand>());
    });
  });
}
