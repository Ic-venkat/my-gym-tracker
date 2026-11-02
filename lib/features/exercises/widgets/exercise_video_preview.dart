import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/logger/app_logger.dart';
import '../../../data/models/models.dart';
import 'video_thumbnail_overlay.dart';

/// Card showing YouTube Shorts video preview thumbnail with one-tap launcher.
class ExerciseVideoPreview extends StatelessWidget {
  const ExerciseVideoPreview({required this.exercise, super.key});

  final Exercise exercise;

  Future<void> _launchShorts(BuildContext context) async {
    final String? videoId = exercise.youtubeVideoId;
    if (videoId == null || videoId.isEmpty) return;

    final String sanitizedId = Uri.encodeComponent(videoId.trim());
    final Uri url = Uri.parse('https://www.youtube.com/shorts/$sanitizedId');
    try {
      final bool launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open YouTube link')),
        );
      }
    } catch (e, stack) {
      AppLogger.e(
        'Failed to launch YouTube Shorts: $url',
        error: e,
        stackTrace: stack,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Unable to open video')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? videoId = exercise.youtubeVideoId;
    if (videoId == null || videoId.isEmpty) {
      return const SizedBox.shrink();
    }

    final String thumbnailUrl =
        'https://img.youtube.com/vi/$videoId/hqdefault.jpg';

    return InkWell(
      onTap: () => _launchShorts(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 160,
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFF1E293B),
        ),
        clipBehavior: Clip.antiAlias,
        child: VideoThumbnailOverlay(thumbnailUrl: thumbnailUrl),
      ),
    );
  }
}
