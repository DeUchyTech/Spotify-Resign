import 'package:flutter/material.dart';
import '../models/music_item.dart';

class LyricsPage extends StatelessWidget {
  final MusicItem song;
  const LyricsPage({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    final lyrics = song.lyrics.isEmpty ? 'Lyrics are not available for this song yet.' : song.lyrics;
    return Scaffold(backgroundColor: const Color(0xFF4B3537), body: Stack(children: [
      Positioned.fill(child: Opacity(opacity: .28, child: Image.asset(song.image, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const SizedBox()))),
      SafeArea(child: Column(children: [
        Padding(padding: const EdgeInsets.fromLTRB(22, 12, 22, 8), child: Row(children: [CircleAvatar(radius: 16, backgroundColor: Colors.black26, child: IconButton(padding: EdgeInsets.zero, icon: const Icon(Icons.chevron_left, color: Colors.white, size: 20), onPressed: () => Navigator.pop(context))), Expanded(child: Center(child: Text(song.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)))), const SizedBox(width: 32)])),
        Expanded(child: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(42, 24, 42, 110), child: Text(lyrics, style: const TextStyle(color: Colors.white, fontSize: 15, height: 2.0, fontWeight: FontWeight.w500)))),
        Container(color: const Color(0xE5333333), padding: const EdgeInsets.fromLTRB(20, 10, 20, 16), child: Row(children: [ClipRRect(borderRadius: BorderRadius.circular(5), child: Image.asset(song.image, width: 42, height: 42, fit: BoxFit.cover)), const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(song.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), Text(song.subtitle, style: const TextStyle(color: Colors.white70, fontSize: 11))])), const Icon(Icons.favorite, color: Color(0xFF1ED760)), const SizedBox(width: 14), const CircleAvatar(radius: 17, backgroundColor: Color(0xFF1ED760), child: Icon(Icons.pause, color: Colors.white))]))
      ]))
    ]));
  }
}
