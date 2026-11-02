import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../voice/bloc/voice_cubit.dart';
import '../../../voice/bloc/voice_state.dart';
import '../bloc/workout_bloc.dart';
import '../bloc/workout_event.dart';

/// Floating mic button that activates voice recognition via [VoiceCubit].
class VoiceMicButton extends StatelessWidget {
  const VoiceMicButton({super.key});

  void _toggleListening(BuildContext context, bool isListening) {
    final VoiceCubit voiceCubit = context.read<VoiceCubit>();
    if (isListening) {
      voiceCubit.stopListening();
    } else {
      voiceCubit.startListening(
        onResult: (String text) {
          context.read<WorkoutBloc>().add(VoiceCommandReceived(text));
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VoiceCubit, VoiceState>(
      builder: (BuildContext context, VoiceState state) {
        final bool isListening = state is VoiceListening;
        return FloatingActionButton.extended(
          heroTag: 'voice_mic_fab',
          onPressed: () => _toggleListening(context, isListening),
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
