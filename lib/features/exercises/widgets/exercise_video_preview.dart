import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/logger/app_logger.dart';
import '../../../data/models/models.dart';

/// Card showing YouTube Shorts video preview thumbnail with one-tap launcher.
class ExerciseVideoPreview extends StatelessWidget {
  const ExerciseVideoPreview({required this.exercise, super.key});

  final Exercise exercise;

  Future<void> _launchShorts(BuildContext context) async {
    final String? videoId = exercise.youtubeVideoId;
    if (videoId == null || videoId.isEmpty) return;

    final Uri url = Uri.parse('https://www.youtube.com/shorts/$videoId');
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
        'Failed to launch YouTube Shorts URL: $url',
        error: e,
        stackTrace: stack,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error launching video: $e')));
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
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image.network(
              thumbnailUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const Center(
                child: Icon(Icons.videocam_off, color: Colors.grey, size: 40),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Colors.black.withValues(alpha: 0.2),
                    Colors.black.withValues(alpha: 0.75),
                  ],
                ),
              ),
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
            const Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Row(
                children: <Widget>[
                  Icon(Icons.video_library, size: 16, color: Colors.white70),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Watch Form Demonstration (Shorts)',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Icon(Icons.open_in_new, size: 14, color: Colors.white70),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
