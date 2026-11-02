import 'package:flutter/material.dart';

import '../models/yoga_routine.dart';
import '../services/yoga_timer_controller.dart';
import 'yoga_completed_view.dart';
import 'yoga_timer_body.dart';

/// Modal bottom sheet providing guided asana hold countdown timers and breath cadence.
class YogaHoldTimerSheet extends StatefulWidget {
  const YogaHoldTimerSheet({required this.routine, super.key});

  final YogaRoutine routine;

  /// Presents the guided yoga flow modal.
  static Future<void> show(BuildContext context, YogaRoutine routine) =>
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: const Color(0xFF0F172A),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (_) => YogaHoldTimerSheet(routine: routine),
      );

  @override
  State<YogaHoldTimerSheet> createState() => _YogaHoldTimerSheetState();
}

class _YogaHoldTimerSheetState extends State<YogaHoldTimerSheet> {
  late final YogaTimerController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = YogaTimerController(routine: widget.routine);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: ListenableBuilder(
        listenable: _ctrl,
        builder: (BuildContext ctx, Widget? _) {
          if (_ctrl.isCompleted) {
            return YogaCompletedView(onDone: () => Navigator.of(ctx).pop());
          }
          return YogaTimerBody(ctrl: _ctrl, routine: widget.routine);
        },
      ),
    );
  }
}
