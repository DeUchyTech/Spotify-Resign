import 'package:flutter/material.dart';

import '../models/music_item.dart';
import 'lyrics_page.dart';
import 'artist_page.dart';

class NowPlayingPage extends StatefulWidget {
  final MusicItem song;

  const NowPlayingPage({super.key, required this.song});

  @override
  State<NowPlayingPage> createState() => _NowPlayingPageState();
}

class _NowPlayingPageState extends State<NowPlayingPage> {
  bool _liked = false;
  bool _playing = true;
  double _progress = .46;

  @override
  Widget build(BuildContext context) {
    final song = widget.song;
    return Scaffold(
      backgroundColor: const Color(0xFF303030),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 18),
          child: Column(
            children: [
              Row(children: [
                _roundButton(Icons.chevron_left, () => Navigator.pop(context)),
                const Expanded(child: Center(child: Text('Now Playing', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)))),
                const SizedBox(width: 36),
              ]),
              const Spacer(flex: 2),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset(song.image, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: song.color, child: const Icon(Icons.music_note, size: 80))),
                ),
              ),
              const Spacer(),
              Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(song.title, style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () => _openArtist(song),
                    child: Text(song.subtitle, style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600)),
                  ),
                ])),
                IconButton(onPressed: () => setState(() => _liked = !_liked), icon: Icon(_liked ? Icons.favorite : Icons.favorite_border, color: const Color(0xFF1ED760), size: 28)),
              ]),
              const SizedBox(height: 12),
              SliderTheme(data: SliderTheme.of(context).copyWith(trackHeight: 3, thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 4), overlayShape: SliderComponentShape.noOverlay), child: Slider(value: _progress, activeColor: Colors.white, inactiveColor: Colors.white24, onChanged: (value) => setState(() => _progress = value))),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(_time(_progress * _seconds(song.duration)), style: const TextStyle(color: Colors.white54, fontSize: 10)), Text('-${_time((1 - _progress) * _seconds(song.duration))}', style: const TextStyle(color: Colors.white54, fontSize: 10))]),
              const SizedBox(height: 8),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                _control(Icons.repeat, 20), _control(Icons.skip_previous, 28),
                GestureDetector(onTap: () => setState(() => _playing = !_playing), child: CircleAvatar(radius: 26, backgroundColor: const Color(0xFF1ED760), child: Icon(_playing ? Icons.pause : Icons.play_arrow, color: Colors.white, size: 31))),
                _control(Icons.skip_next, 28), _control(Icons.shuffle, 20),
              ]),
              const SizedBox(height: 15),
              TextButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LyricsPage(song: song))), icon: const Icon(Icons.keyboard_arrow_up, color: Colors.white70), label: const Text('Lyrics', style: TextStyle(color: Colors.white70))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _roundButton(IconData icon, VoidCallback onTap) => InkResponse(onTap: onTap, child: CircleAvatar(radius: 16, backgroundColor: Colors.white12, child: Icon(icon, color: Colors.white, size: 20)));
  Widget _control(IconData icon, double size) => IconButton(onPressed: () {}, icon: Icon(icon, color: Colors.white70, size: size));
  int _seconds(String duration) { final parts = duration.split(':'); return (int.tryParse(parts.first) ?? 3) * 60 + (int.tryParse(parts.length > 1 ? parts[1] : '') ?? 40); }
  String _time(double seconds) { final total = seconds.round(); return '${total ~/ 60}:${(total % 60).toString().padLeft(2, '0')}'; }

  void _openArtist(MusicItem song) {
    final artistName = song.subtitle.split(',').first.trim();
    final artist = MusicItem(
      artistName,
      '${artistName == 'Mahalini' ? '35,120,000' : '12,700,000'} monthly listeners',
      artistName == 'Mahalini' ? 'lib/assets/Mahalini.jpg' : song.image,
      song.color,
      isArtist: true,
      monthlyListeners: artistName == 'Mahalini' ? '35,1M' : '12,7M',
    );
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ArtistPage(artist: artist, songs: [song]),
    ));
  }
}
