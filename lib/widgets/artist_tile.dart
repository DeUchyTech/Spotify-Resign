import 'package:flutter/material.dart';

import '../models/music_item.dart';
import 'music_artwork.dart';

class ArtistTile extends StatelessWidget {
  final MusicItem item;
  final VoidCallback? onTap;

  const ArtistTile({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        vertical: 4,
      ),
      leading: MusicArtwork(
        item: item,
        size: 54,
        circle: true,
      ),
      title: Text(item.title),
      subtitle: Text(item.subtitle),
      trailing: const Icon(
        Icons.chevron_right,
      ),
      onTap: onTap,
    );
  }
}