import 'package:flutter/material.dart';

/// Renders the YouTube thumbnail with play icon and gradient overlay.
class VideoThumbnailOverlay extends StatelessWidget {
  const VideoThumbnailOverlay({required this.thumbnailUrl, super.key});

  final String thumbnailUrl;

  @override
  Widget build(BuildContext context) {
    return Stack(
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
            child: const Icon(Icons.play_arrow, color: Colors.white, size: 28),
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
    );
  }
}
