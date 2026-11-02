import 'package:flutter/material.dart';

import '../models/workout_template.dart';

/// Card item presenting a workout template overview with exercise count and duration.
class TemplateCardItem extends StatelessWidget {
  const TemplateCardItem({
    required this.template,
    required this.onTap,
    super.key,
  });

  final WorkoutTemplate template;
  final VoidCallback onTap;

  Color _categoryColor(String cat) {
    return switch (cat.toLowerCase()) {
      'ppl' => const Color(0xFF38BDF8),
      'calisthenics' => const Color(0xFFA855F7),
      'mobility' => const Color(0xFF10B981),
      _ => const Color(0xFF94A3B8),
    };
  }

  @override
  Widget build(BuildContext context) {
    final Color color = _categoryColor(template.category);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: color.withValues(alpha: 0.4)),
              ),
              child: Text(
                template.category,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                template.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            '${template.exercises.length} exercises • ~${template.estimatedMinutes} mins\n${template.description}',
            style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
        onTap: onTap,
      ),
    );
  }
}
