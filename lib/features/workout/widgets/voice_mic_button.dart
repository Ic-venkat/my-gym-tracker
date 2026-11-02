import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../voice/speech_service.dart';
import '../bloc/workout_bloc.dart';
import '../bloc/workout_event.dart';

/// Floating mic button that activates on-device voice recognition.
class VoiceMicButton extends StatefulWidget {
  const VoiceMicButton({required this.speechService, super.key});

  final SpeechService speechService;

  @override
  State<VoiceMicButton> createState() => _VoiceMicButtonState();
}

class _VoiceMicButtonState extends State<VoiceMicButton> {
  bool _isListening = false;

  Future<void> _toggleListening() async {
    if (_isListening) {
      await widget.speechService.stopListening();
      setState(() => _isListening = false);
    } else {
      setState(() => _isListening = true);
      await widget.speechService.startListening(
        onResult: (String text) {
          if (mounted) {
            setState(() => _isListening = false);
            context.read<WorkoutBloc>().add(VoiceCommandReceived(text));
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      heroTag: 'voice_mic_fab',
      onPressed: _toggleListening,
      backgroundColor: _isListening
          ? const Color(0xFFEF4444)
          : const Color(0xFF10B981),
      foregroundColor: Colors.black,
      icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
      label: Text(
        _isListening ? 'Listening...' : 'Voice Log',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
