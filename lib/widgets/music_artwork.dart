import 'package:flutter/material.dart';

import '../models/music_item.dart';

class MusicArtwork extends StatelessWidget {
  final MusicItem item;
  final double size;
  final bool circle;

  const MusicArtwork({
    super.key,
    required this.item,
    required this.size,
    this.circle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: circle
            ? BoxShape.circle
            : BoxShape.rectangle,
        borderRadius: circle
            ? null
            : BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: circle
            ? BorderRadius.circular(size)
            : BorderRadius.circular(12),
        child: Image.asset(
          item.image,
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}