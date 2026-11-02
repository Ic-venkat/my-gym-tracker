import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../voice/speech_service.dart';
import '../bloc/workout_bloc.dart';
import '../bloc/workout_event.dart';

/// Floating mic button that reacts to speech listening state.
class VoiceMicButton extends StatelessWidget {
  const VoiceMicButton({required this.speechService, super.key});

  final SpeechService speechService;

  Future<void> _toggleListening(BuildContext context) async {
    if (speechService.isListening) {
      await speechService.stopListening();
    } else {
      await speechService.startListening(
        onResult: (String text) {
          context.read<WorkoutBloc>().add(VoiceCommandReceived(text));
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: speechService.isListeningStream,
      initialData: speechService.isListening,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        final bool isListening = snapshot.data ?? false;
        return FloatingActionButton.extended(
          heroTag: 'voice_mic_fab',
          onPressed: () => _toggleListening(context),
          backgroundColor: isListening
              ? const Color(0xFFEF4444)
              : const Color(0xFF10B981),
          foregroundColor: Colors.black,
          icon: Icon(isListening ? Icons.mic : Icons.mic_none),
          label: Text(
            isListening ? 'Listening...' : 'Voice Log',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }
}
