import 'package:flutter/material.dart';

import '../models/music_item.dart';
import '../widgets/artist_tile.dart';
import '../widgets/music_card.dart';
import '../widgets/promo_banner.dart';
import 'artist_page.dart';
import 'now_playing_page.dart';

class HomeContent extends StatefulWidget {
  final String fullname;
  final VoidCallback onSettings;

  const HomeContent({
    super.key,
    required this.fullname,
    required this.onSettings,
  });

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final _searchController = TextEditingController();

  int _selectedCategoryIndex = 0;

  bool _isSearching = false;

  String _query = '';

  // Music categories
  final _categories = const [
    'Artists',
    'Albums',
    'Podcasts',
    'Genres',
  ];

  // Songs
  final _songs = const [
    MusicItem(
      'Arti Untuk Cinta',
      'Ari Wibowo, Tiara Andini',
      'lib/assets/arti untuk cinta.jpg',
      Color(0xFFCE7B4D),
      duration: '3:47',
      lyrics: 'Kau datang membawa terang\nSaat dunia terasa kelam\nArti untuk cinta\nAda di setiap langkah kita',
    ),

    MusicItem(
      'Runtuh',
      'Feby Putri, Fiersa Besari',
      'lib/assets/runtuh.jpg',
      Color(0xFF6750A4),
      duration: '3:43',
      lyrics: 'Ku terima pesan singkatmu\nTak bisakah kau menunggu\nKu tahu ini berat untukmu\nNamun kau harus bertahan',
    ),

    MusicItem(
      'Blue Jeans',
      'GANGGA',
      'lib/assets/blue_jeans.jpg',
      Color(0xFF3178C6),
      duration: '3:34',
      lyrics: 'Blue jeans, white shirt\nWalked into the room you know you made my eyes burn',
    ),

    MusicItem(
      'Chris Brown',
      'Loyal',
      'lib/assets/chris_brown.jpg',
      Color(0xFFE0A419),
      duration: '3:28',
      lyrics: 'I gave you my heart\nAnd you gave me a reason to stay',
    ),
  ];

  // Artists
  final _artists = const [
    MusicItem(
      'Adele',
      '43,577,516 monthly listeners',
      'lib/assets/adele.jpg',
      Color(0xFFB85C5C),
      isArtist: true,
      monthlyListeners: '43,6M',
    ),
    MusicItem(
      'Tiara Andini',
      '38,782,341 monthly listeners',
      'lib/assets/Tiara Andini.jpg',
      Color(0xFF6554AF),
      isArtist: true,
      monthlyListeners: '38,8M',
    ),
    MusicItem(
      'Mahalini',
      '35,120,000 monthly listeners',
      'lib/assets/Mahalini.jpg',
      Color(0xFFE08A54),
      isArtist: true,
      monthlyListeners: '35,1M',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Show a message
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        18,
        12,
        18,
        24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(scheme),

          const SizedBox(height: 22),

          // Search results or home content
          if (_isSearching)
            _searchResults()
          else
            _buildHomeContent(scheme),
        ],
      ),
    );
  }

  // Header with search, logo and settings
  Widget _buildHeader(ColorScheme scheme) {
    if (_isSearching) {
      return TextField(
        controller: _searchController,
        autofocus: true,
        onChanged: (value) {
          setState(() {
            _query = value.trim().toLowerCase();
          });
        },
        decoration: InputDecoration(
          hintText: 'Songs, artists, albums',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              _searchController.clear();

              setState(() {
                _query = '';
                _isSearching = false;
              });
            },
          ),
          filled: true,
          fillColor: scheme.surfaceContainerHighest,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      );
    }

    return Row(
      children: [
        // Search button
        SizedBox(
          width: 44,
          child: IconButton(
            padding: EdgeInsets.zero,
            alignment: Alignment.centerLeft,
            onPressed: () {
              setState(() {
                _isSearching = true;
              });
            },
            icon: const Icon(Icons.search),
            tooltip: 'Search',
          ),
        ),

        // Spotify logo
        Expanded(
          child: Center(
            child: Image.asset(
              'lib/assets/spotify_logo.png',
              width: 120,
              height: 34,
              fit: BoxFit.contain,
            ),
          ),
        ),

        // Settings button
        SizedBox(
          width: 44,
          child: IconButton(
            padding: EdgeInsets.zero,
            alignment: Alignment.centerRight,
            onPressed: widget.onSettings,
            icon: const Icon(
              Icons.settings_outlined,
            ),
            tooltip: 'Settings',
          ),
        ),
      ],
    );
  }

  // Main home content
  Widget _buildHomeContent(ColorScheme scheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // // Welcome message
        // Text(
        //   widget.fullname.isEmpty
        //       ? 'Welcome'
        //       : 'Welcome, ${widget.fullname}',
        //   style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        //
        // const SizedBox(height: 16),

        // Promotional banner
        PromoBanner(
          onTap: () {
            _openSong(const MusicItem('Sisa Rasa', 'Mahalini', 'lib/assets/sisa rasa.jpg', Color(0xFFE8A7B0), duration: '4:10', lyrics: 'Masih jelas teringat\nPelukannya yang hangat\nSeakan semua tak mungkin menghilang\nKini hanya kenangan yang telah kau tinggalkan\n\nTak sanggup lagi waktu bersama\nMeninggalkan sisa rasa di dada'));
          },
        ),

        const SizedBox(height: 24),

        // Today's hits title
        Text(
          "Today's hits",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        // Horizontal song list
        SizedBox(
          height: 162,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _songs.length,
            separatorBuilder: (_, __) {
              return const SizedBox(width: 12);
            },
            itemBuilder: (_, index) {
              return MusicCard(
                item: _songs[index],
                onTap: () {
                  _openSong(_songs[index]);
                },
              );
            },
          ),
        ),

        const SizedBox(height: 16),

        // Music categories
        // Music category tabs
        SizedBox(
          height: 48,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final isSelected =
                  _selectedCategoryIndex == index;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategoryIndex = index;
                  });
                },
                child: Container(
                  width: 120,
                  margin: const EdgeInsets.only(right: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        _categories[index],
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 20,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF9E9E9E),
                        ),
                      ),

                      const SizedBox(height: 5),

                      // Green curved indicator
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: isSelected ? 18 : 0,
                        height: isSelected ? 6 : 0,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1ED760),
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 12),

        // Selected category
        Text(
          _categories[_selectedCategoryIndex],
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 6),

        // Artist list
        ..._artists.map(
              (artist) {
            return ArtistTile(
              item: artist,
              onTap: () {
                _openArtist(artist);
              },
            );
          },
        ),
      ],
    );
  }

  // Search results
  Widget _searchResults() {
    final results = [
      ..._songs,
      ..._artists,
    ]
        .where(
          (item) =>
      item.title.toLowerCase().contains(_query) ||
          item.subtitle.toLowerCase().contains(_query),
    )
        .toList();

    // Empty search
    if (_query.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(36),
          child: Text(
            'Start typing to find music.',
          ),
        ),
      );
    }

    // No results
    if (results.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(36),
          child: Text(
            'No music found.',
          ),
        ),
      );
    }

    // Display results
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Column(
        children: results.map(
              (item) {
            return ArtistTile(
              item: item,
              onTap: () {
                item.isArtist ? _openArtist(item) : _openSong(item);
              },
            );
          },
        ).toList(),
      ),
    );
  }

  void _openSong(MusicItem song) => Navigator.of(context).push(MaterialPageRoute(builder: (_) => NowPlayingPage(song: song)));

  void _openArtist(MusicItem artist) {
    final songs = _songs.where((song) => song.subtitle.toLowerCase().contains(artist.title.toLowerCase())).toList();
    final fallbackSongs = songs.isEmpty ? _songs.take(3).toList() : songs;
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => ArtistPage(artist: artist, songs: fallbackSongs)));
  }
}
