import 'package:flutter/material.dart';

/// Completion view displayed when all postures in a yoga routine have finished.
class YogaCompletedView extends StatelessWidget {
  const YogaCompletedView({required this.onDone, super.key});

  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 64),
        const SizedBox(height: 16),
        const Text(
          'Flow Complete! Namaste 🙏',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        ElevatedButton(onPressed: onDone, child: const Text('Done')),
      ],
    );
  }
}
