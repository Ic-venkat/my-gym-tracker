import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../voice/speech_service.dart';
import '../../exercises/screens/exercise_library_screen.dart';
import '../../history/bloc/history_bloc.dart';
import '../../history/bloc/history_event.dart';
import '../../history/screens/history_screen.dart';
import '../../workout/screens/active_workout_screen.dart';
import '../../workout/widgets/voice_mic_button.dart';

/// Main scaffold hosting bottom navigation between Workout, Exercises, and History.
class HomeScreen extends StatefulWidget {
  const HomeScreen({required this.speechService, super.key});

  final SpeechService speechService;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const <Widget>[
    ActiveWorkoutScreen(),
    ExerciseLibraryScreen(),
    HistoryScreen(),
  ];

  void _onTabChanged(int index) {
    setState(() => _currentIndex = index);
    if (index == 2) {
      context.read<HistoryBloc>().add(const LoadWorkoutHistory());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      floatingActionButton: VoiceMicButton(speechService: widget.speechService),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onTabChanged,
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.fitness_center),
            label: 'Workout',
          ),
          NavigationDestination(icon: Icon(Icons.list_alt), label: 'Exercises'),
          NavigationDestination(icon: Icon(Icons.history), label: 'History'),
        ],
      ),
    );
  }
}
