import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/music_item.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({super.key});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  static const String _prefsKey = 'saved_playlists';

  bool _isSearching = false;
  bool _isLoading = true;

  final TextEditingController _searchController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  List<MusicItem> _playlists = const [
    MusicItem(
      'Arti Untuk Cinta',
      'Ari Wibowo, Tiara Andini',
      'lib/assets/Tiara Andini.jpg',
      Color(0xFFCE7B4D),
      songCount: 12,
    ),
    MusicItem(
      'Runtuh',
      'Feby Putri, Fiersa Besari',
      'lib/assets/runtuh.jpg',
      Color(0xFF6750A4),
      songCount: 8,
    ),
    MusicItem(
      'Blue Jeans',
      'GANGGA',
      'lib/assets/blue_jeans.jpg',
      Color(0xFF3178C6),
      songCount: 5,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadPlaylists();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MusicItem> get _filteredPlaylists {
    final String query = _searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      return _playlists;
    }

    return _playlists
        .where(
          (item) => item.title.toLowerCase().contains(query),
    )
        .toList();
  }

  Future<void> _loadPlaylists() async {
    try {
      final SharedPreferences prefs =
      await SharedPreferences.getInstance();

      final String? raw = prefs.getString(_prefsKey);

      if (raw != null && raw.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;

        final List<MusicItem> loaded = decoded
            .map(
              (e) => MusicItem.fromJson(
            e as Map<String, dynamic>,
          ),
        )
            .toList();

        if (mounted) {
          setState(() {
            _playlists = loaded;
            _isLoading = false;
          });

          return;
        }
      }
    } catch (_) {
      // Fall through to defaults if storage read/parse fails.
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      unawaited(_savePlaylists());
    }
  }

  Future<void> _savePlaylists() async {
    try {
      final SharedPreferences prefs =
      await SharedPreferences.getInstance();

      final String raw = jsonEncode(
        _playlists.map((e) => e.toJson()).toList(),
      );

      await prefs.setString(_prefsKey, raw);
    } catch (_) {
      // Saving is best-effort.
    }
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _closeSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
    });
  }

  Future<void> _showAddPlaylistDialog() async {
    final TextEditingController nameController =
    TextEditingController();

    final String? playlistName = await showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Create Playlist',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: TextField(
            controller: nameController,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                Navigator.of(dialogContext).pop(value.trim());
              }
            },
            decoration: InputDecoration(
              hintText: 'Playlist name',
              prefixIcon: const Icon(Icons.queue_music),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(null);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final String name =
                nameController.text.trim();

                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please enter a playlist name',
                      ),
                    ),
                  );

                  return;
                }

                Navigator.of(dialogContext).pop(name);
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );

    nameController.dispose();

    if (!mounted ||
        playlistName == null ||
        playlistName.trim().isEmpty) {
      return;
    }

    final String trimmedName = playlistName.trim();

    await Future.delayed(
      const Duration(milliseconds: 300),
    );

    if (!mounted) return;

    String? savedImagePath;

    try {
      final XFile? pickedImage =
      await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (pickedImage != null) {
        savedImagePath =
        await _persistPickedImage(pickedImage);
      }
    } catch (_) {
      savedImagePath = null;
    }

    if (!mounted) return;

    const List<Color> palette = [
      Color(0xFFCE7B4D),
      Color(0xFF6750A4),
      Color(0xFF3178C6),
      Color(0xFF3A8E5C),
      Color(0xFFB0466E),
    ];

    final Color color =
    palette[_playlists.length % palette.length];

    final MusicItem newPlaylist = MusicItem(
      trimmedName,
      'Your playlist',
      savedImagePath ?? '',
      color,
      songCount: 0,
    );

    setState(() {
      _playlists = [
        ..._playlists,
        newPlaylist,
      ];
    });

    await _savePlaylists();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$trimmedName playlist created',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _deletePlaylist(
      MusicItem item,
      ) async {
    final bool? confirmed =
    await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Delete Playlist?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to delete '
                '"${item.title}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) {
      return;
    }

    setState(() {
      _playlists = _playlists
          .where(
            (playlist) => playlist != item,
      )
          .toList();
    });

    await _savePlaylists();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${item.title} deleted',
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () async {
            setState(() {
              _playlists = [
                ..._playlists,
                item,
              ];
            });

            await _savePlaylists();
          },
        ),
      ),
    );
  }

  Future<String?> _persistPickedImage(
      XFile pickedImage,
      ) async {
    try {
      final Directory appDir =
      await getApplicationDocumentsDirectory();

      final Directory coversDir = Directory(
        '${appDir.path}/playlist_covers',
      );

      if (!await coversDir.exists()) {
        await coversDir.create(
          recursive: true,
        );
      }

      final String extension =
          pickedImage.path.split('.').last;

      final String fileName =
          'cover_${DateTime.now().millisecondsSinceEpoch}.$extension';

      final String newPath =
          '${coversDir.path}/$fileName';

      final File savedFile =
      await File(pickedImage.path).copy(newPath);

      return savedFile.path;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme =
    Theme.of(context);

    return Scaffold(
      backgroundColor:
      theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            18,
            20,
            18,
            8,
          ),
          child: Column(
            children: [
              _buildHeader(context),

              const SizedBox(height: 18),

              Expanded(
                child: _isLoading
                    ? const Center(
                  child:
                  CircularProgressIndicator(),
                )
                    : _buildPlaylistGrid(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final ThemeData theme =
    Theme.of(context);

    if (_isSearching) {
      return Row(
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: _closeSearch,
            icon: const Icon(
              Icons.arrow_back_ios_new,
              size: 20,
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: TextField(
              controller: _searchController,
              autofocus: true,
              onChanged: (_) {
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: 'Search playlists',
                prefixIcon:
                const Icon(Icons.search),
                suffixIcon:
                _searchController.text.isNotEmpty
                    ? IconButton(
                  onPressed: () {
                    setState(() {
                      _searchController
                          .clear();
                    });
                  },
                  icon: const Icon(
                    Icons.close,
                  ),
                )
                    : null,
                filled: true,
                fillColor:
                theme.brightness ==
                    Brightness.dark
                    ? const Color(0xFF202020)
                    : const Color(0xFFF1F1F1),
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          IconButton(
            onPressed:
            _showAddPlaylistDialog,
            icon: const Icon(Icons.add),
            tooltip: 'Add playlist',
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 44,
          child: IconButton(
            padding: EdgeInsets.zero,
            alignment:
            Alignment.centerLeft,
            onPressed: _startSearch,
            icon: const Icon(Icons.search),
            tooltip: 'Search',
          ),
        ),

        Text(
          'Playlists',
          style: theme
              .textTheme
              .headlineSmall
              ?.copyWith(
            fontWeight:
            FontWeight.bold,
          ),
        ),

        SizedBox(
          width: 44,
          child: IconButton(
            padding: EdgeInsets.zero,
            alignment:
            Alignment.centerRight,
            onPressed:
            _showAddPlaylistDialog,
            icon: const Icon(Icons.add),
            tooltip: 'Add playlist',
          ),
        ),
      ],
    );
  }

  Widget _buildPlaylistGrid(
      BuildContext context,
      ) {
    final List<MusicItem> playlists =
        _filteredPlaylists;

    if (playlists.isEmpty) {
      return _buildEmptyState(context);
    }

    return GridView.builder(
      physics:
      const BouncingScrollPhysics(),
      padding:
      const EdgeInsets.only(bottom: 20),
      itemCount: playlists.length,
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 18,
        mainAxisSpacing: 18,
        childAspectRatio: 0.78,
      ),
      itemBuilder: (context, index) {
        return _buildPlaylistCard(
          context,
          playlists[index],
        );
      },
    );
  }

  Widget _buildPlaylistCard(
      BuildContext context,
      MusicItem item,
      ) {
    final ThemeData theme =
    Theme.of(context);

    final bool hasImage =
        item.image.isNotEmpty;

    final bool isUserImage =
        hasImage &&
            !item.image.startsWith('lib/');

    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content:
            Text('Opening ${item.title}'),
            behavior:
            SnackBarBehavior.floating,
          ),
        );
      },

      onLongPress: () {
        _deletePlaylist(item);
      },

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: item.color,
                borderRadius:
                BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black
                        .withOpacity(0.12),
                    blurRadius: 6,
                    offset:
                    const Offset(0, 3),
                  ),
                ],
              ),
              clipBehavior:
              Clip.antiAlias,
              child: !hasImage
                  ? _imagePlaceholder(item)
                  : (isUserImage
                  ? Image.file(
                File(item.image),
                width:
                double.infinity,
                height:
                double.infinity,
                fit: BoxFit.cover,
                errorBuilder:
                    (
                    context,
                    error,
                    stackTrace,
                    ) =>
                    _imagePlaceholder(
                      item,
                    ),
              )
                  : Image.asset(
                item.image,
                width:
                double.infinity,
                height:
                double.infinity,
                fit: BoxFit.cover,
                errorBuilder:
                    (
                    context,
                    error,
                    stackTrace,
                    ) =>
                    _imagePlaceholder(
                      item,
                    ),
              )),
            ),
          ),

          const SizedBox(height: 7),

          Text(
            item.title,
            maxLines: 1,
            overflow:
            TextOverflow.ellipsis,
            style: theme
                .textTheme
                .bodyMedium
                ?.copyWith(
              fontWeight:
              FontWeight.w600,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            item.songCount == 1
                ? '1 song'
                : '${item.songCount} songs',
            maxLines: 1,
            overflow:
            TextOverflow.ellipsis,
            style: theme
                .textTheme
                .bodySmall
                ?.copyWith(
              color: theme
                  .textTheme
                  .bodySmall
                  ?.color
                  ?.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imagePlaceholder(
      MusicItem item,
      ) {
    return Container(
      color: item.color,
      alignment: Alignment.center,
      child: const Icon(
        Icons.music_note_rounded,
        color: Colors.white,
        size: 40,
      ),
    );
  }

  Widget _buildEmptyState(
      BuildContext context,
      ) {
    final ThemeData theme =
    Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 55,
            color: theme
                .textTheme
                .bodyMedium
                ?.color
                ?.withOpacity(0.45),
          ),

          const SizedBox(height: 12),

          Text(
            'No playlists found',
            style: theme
                .textTheme
                .titleMedium
                ?.copyWith(
              fontWeight:
              FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            'Try searching for another playlist',
            style: theme
                .textTheme
                .bodyMedium
                ?.copyWith(
              color: theme
                  .textTheme
                  .bodyMedium
                  ?.color
                  ?.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}