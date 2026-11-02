import 'package:flutter/material.dart';

import '../data/default_templates.dart';
import '../models/workout_template.dart';
import 'template_card_item.dart';

/// Modal bottom sheet allowing selection from scientific workout split templates.
class TemplatePickerSheet extends StatelessWidget {
  const TemplatePickerSheet({required this.onSelect, super.key});

  final ValueChanged<WorkoutTemplate> onSelect;

  /// Shows the template selection bottom sheet.
  static Future<void> show(
    BuildContext context, {
    required ValueChanged<WorkoutTemplate> onSelect,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => TemplatePickerSheet(onSelect: onSelect),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (BuildContext _, ScrollController scrollController) {
        return Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF475569),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                'Choose a Workout Split',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(color: Color(0xFF334155), height: 1),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: defaultWorkoutTemplates.length,
                itemBuilder: (BuildContext ctx, int index) {
                  final WorkoutTemplate t = defaultWorkoutTemplates[index];
                  return TemplateCardItem(
                    key: ValueKey<String>(t.id),
                    template: t,
                    onTap: () {
                      Navigator.of(ctx).pop();
                      onSelect(t);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
