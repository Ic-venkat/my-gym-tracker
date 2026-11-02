import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../exercises/screens/exercise_library_screen.dart';
import '../../history/bloc/history_bloc.dart';
import '../../history/bloc/history_event.dart';
import '../../history/screens/history_screen.dart';
import '../../workout/screens/active_workout_screen.dart';
import '../../workout/widgets/voice_mic_button.dart';

/// Main scaffold hosting bottom navigation between Workout, Exercises, and History.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ValueNotifier<int> _tabNotifier;

  final List<Widget> _pages = const <Widget>[
    ActiveWorkoutScreen(),
    ExerciseLibraryScreen(),
    HistoryScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _tabNotifier = ValueNotifier<int>(0);
  }

  @override
  void dispose() {
    _tabNotifier.dispose();
    super.dispose();
  }

  void _onTabChanged(BuildContext context, int index) {
    _tabNotifier.value = index;
    if (index == 2) {
      context.read<HistoryBloc>().add(const LoadWorkoutHistory());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _tabNotifier,
      builder: (BuildContext context, int currentIndex, _) {
        return Scaffold(
          body: IndexedStack(index: currentIndex, children: _pages),
          floatingActionButton: const VoiceMicButton(),
          bottomNavigationBar: NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: (int idx) => _onTabChanged(context, idx),
            destinations: const <NavigationDestination>[
              NavigationDestination(
                icon: Icon(Icons.fitness_center),
                label: 'Workout',
              ),
              NavigationDestination(
                icon: Icon(Icons.list_alt),
                label: 'Exercises',
              ),
              NavigationDestination(
                icon: Icon(Icons.history),
                label: 'History',
              ),
            ],
          ),
        );
      },
    );
  }
}
