import 'package:flutter/material.dart';

import '../models/music_item.dart';
import 'now_playing_page.dart';

class ArtistPage extends StatefulWidget {
  final MusicItem artist;
  final List<MusicItem> songs;
  const ArtistPage({super.key, required this.artist, required this.songs});

  @override
  State<ArtistPage> createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage> {
  bool _following = false;

  @override
  Widget build(BuildContext context) {
    final artist = widget.artist;
    final image = artist.artistImage.isNotEmpty ? artist.artistImage : artist.image;
    final albums = widget.songs.take(3).toList();
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: CustomScrollView(slivers: [
          SliverToBoxAdapter(child: SizedBox(height: 205, child: Stack(fit: StackFit.expand, children: [
            Image.asset(image, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: artist.color)),
            DecoratedBox(decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black]))),
            Positioned(left: 14, top: 10, child: CircleAvatar(radius: 16, backgroundColor: Colors.black38, child: IconButton(padding: EdgeInsets.zero, icon: const Icon(Icons.chevron_left, color: Colors.white, size: 20), onPressed: () => Navigator.pop(context))),),
            Positioned(right: 15, top: 11, child: Row(children: [OutlinedButton(onPressed: () => setState(() => _following = !_following), style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10), minimumSize: const Size(0, 27), side: const BorderSide(color: Colors.white), foregroundColor: Colors.white), child: Text(_following ? 'Following' : 'Follow', style: const TextStyle(fontSize: 10))), const SizedBox(width: 6), const Icon(Icons.more_horiz, color: Colors.white)])),
            Positioned(left: 18, bottom: 12, child: Text(artist.title, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold))),
          ]))),
          SliverToBoxAdapter(child: Container(height: 46, decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF181818), Colors.black], begin: Alignment.topCenter, end: Alignment.bottomCenter)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [_stat('Followers', '12,7K'), _stat('Monthly listeners', artist.monthlyListeners.isEmpty ? '35,1M' : artist.monthlyListeners)]))),
          SliverPadding(padding: const EdgeInsets.fromLTRB(18, 15, 18, 100), sliver: SliverList(delegate: SliverChildListDelegate([
            const Text('Albums', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SizedBox(height: 118, child: ListView.separated(scrollDirection: Axis.horizontal, itemCount: albums.length, separatorBuilder: (_, __) => const SizedBox(width: 12), itemBuilder: (_, index) { final song = albums[index]; return GestureDetector(onTap: () => _open(song), child: SizedBox(width: 88, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ClipRRect(borderRadius: BorderRadius.circular(6), child: Image.asset(song.image, width: 88, height: 88, fit: BoxFit.cover)), const SizedBox(height: 4), Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600))]))); })),
            const SizedBox(height: 15),
            const Text('Songs', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            ...widget.songs.map((song) => ListTile(contentPadding: EdgeInsets.zero, onTap: () => _open(song), leading: ClipRRect(borderRadius: BorderRadius.circular(5), child: Image.asset(song.image, width: 48, height: 48, fit: BoxFit.cover)), title: Text(song.title, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)), subtitle: Text(song.subtitle, style: const TextStyle(color: Colors.white60, fontSize: 11)), trailing: const Icon(Icons.more_vert, color: Colors.white70, size: 18))),
          ])))
        ]),
      ),
    );
  }
  Widget _stat(String label, String value) => Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(label, style: const TextStyle(color: Colors.white54, fontSize: 8)), Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))]);
  void _open(MusicItem song) => Navigator.push(context, MaterialPageRoute(builder: (_) => NowPlayingPage(song: song)));
}
