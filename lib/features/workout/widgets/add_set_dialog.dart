import 'package:flutter/material.dart';

/// Modal dialog for manually logging a set with weight and reps.
class AddSetDialog extends StatefulWidget {
  const AddSetDialog({
    required this.exerciseName,
    required this.onLog,
    super.key,
  });

  final String exerciseName;
  final void Function(int reps, double weight) onLog;

  @override
  State<AddSetDialog> createState() => _AddSetDialogState();
}

class _AddSetDialogState extends State<AddSetDialog> {
  final TextEditingController _weightCtrl = TextEditingController(text: '60');
  final TextEditingController _repsCtrl = TextEditingController(text: '10');

  @override
  void dispose() {
    _weightCtrl.dispose();
    _repsCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final double? weight = double.tryParse(_weightCtrl.text);
    final int? reps = int.tryParse(_repsCtrl.text);
    if (weight != null && reps != null && reps > 0) {
      widget.onLog(reps, weight);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Log Set: ${widget.exerciseName}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: _weightCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Weight (kg)'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _repsCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Reps'),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(onPressed: _submit, child: const Text('Log Set')),
      ],
    );
  }
}
