import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({
    super.key,
  });

  final List<Map<String, String>> _today = const [
    {
      'title': 'Happiers',
      'subtitle': 'Playlist',
      'image': 'lib/assets/Happiers.jpg',
    },
    {
      'title': 'Dekat Di Hati',
      'subtitle': 'RAN',
      'image': 'lib/assets/dekat_di_hati.jpg',
    },
    {
      'title': 'Remaja',
      'subtitle': 'Hivi!',
      'image': 'lib/assets/remaja.jpg',
    },
  ];

  final List<Map<String, String>> _yesterday = const [
    {
      'title': 'Sadness',
      'subtitle': 'Playlist',
      'image': 'lib/assets/runtuh.jpg',
    },
    {
      'title': 'Bigger Than The Whole...',
      'subtitle': 'Taylor Swift',
      'image': 'lib/assets/taylor_swift.jpg',
    },
    {
      'title': 'Matilda',
      'subtitle': 'Harry Styles',
      'image': 'lib/assets/matilda.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),

            Expanded(
              child: SingleChildScrollView(
                physics:
                const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  20,
                  12,
                  20,
                  30,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    _buildDaySection(
                      context,
                      title: 'Today',
                      songs: _today,
                      showArrow: false,
                    ),

                    const SizedBox(height: 24),

                    _buildDaySection(
                      context,
                      title: 'Yesterday',
                      songs: _yesterday,
                      showArrow: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      height: 58,
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? Colors.black
            : theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              theme.brightness == Brightness.dark
                  ? 0.35
                  : 0.08,
            ),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            'History',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 19,
            ),
          ),

          Positioned(
            right: 16,
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 32,
                minHeight: 32,
              ),
              onPressed: () {
                _showHistoryMenu(context);
              },
              icon: const Icon(
                Icons.more_horiz,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaySection(
      BuildContext context, {
        required String title,
        required List<Map<String, String>> songs,
        required bool showArrow,
      }) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),

            if (showArrow)
              Icon(
                Icons.chevron_right,
                size: 28,
                color: Theme.of(context)
                    .iconTheme
                    .color,
              ),
          ],
        ),

        const SizedBox(height: 10),

        ...songs.map(
              (song) => _buildHistoryItem(
            context,
            title: song['title']!,
            subtitle: song['subtitle']!,
            image: song['image']!,
          ),
        ),

        const SizedBox(height: 7),

        _buildSeeAllButton(
          context,
        ),
      ],
    );
  }

  Widget _buildHistoryItem(
      BuildContext context, {
        required String title,
        required String subtitle,
        required String image,
      }) {
    final ThemeData theme =
    Theme.of(context);

    return SizedBox(
      height: 62,
      child: Row(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              borderRadius:
              BorderRadius.circular(9),
              color: theme.brightness ==
                  Brightness.dark
                  ? const Color(0xFF292929)
                  : const Color(0xFFE7E7E7),
            ),
            clipBehavior:
            Clip.antiAlias,
            child: Image.asset(
              image,
              fit: BoxFit.cover,
              errorBuilder: (
                  BuildContext context,
                  Object error,
                  StackTrace? stackTrace,
                  ) {
                return Container(
                  color: theme.brightness ==
                      Brightness.dark
                      ? const Color(0xFF292929)
                      : const Color(0xFFE7E7E7),
                  child: Icon(
                    Icons.music_note,
                    color: theme
                        .iconTheme
                        .color
                        ?.withOpacity(0.5),
                  ),
                );
              },
            ),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.center,
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: theme
                      .textTheme
                      .bodyLarge
                      ?.copyWith(
                    fontWeight:
                    FontWeight.w600,
                    fontSize: 14.5,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  subtitle,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: theme
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                    fontSize: 12.5,
                    color: theme
                        .textTheme
                        .bodyMedium
                        ?.color
                        ?.withOpacity(0.65),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            width: 28,
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints:
              const BoxConstraints(
                minWidth: 28,
                minHeight: 28,
              ),
              onPressed: () {
                _showSongMenu(
                  context,
                  title,
                );
              },
              icon: const Icon(
                Icons.more_vert,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeeAllButton(
      BuildContext context,
      ) {
    final ThemeData theme =
    Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
        top: 1,
      ),
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize:
              MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context)
                  .showSnackBar(
                const SnackBar(
                  content: Text(
                    'Showing all 28 played songs',
                  ),
                  behavior:
                  SnackBarBehavior.floating,
                ),
              );
            },
            child: Text(
              'See all 28 played',
              style: theme
                  .textTheme
                  .bodySmall
                  ?.copyWith(
                fontSize: 11,
                fontWeight:
                FontWeight.w500,
              ),
            ),
          ),

          IconButton(
            padding: EdgeInsets.zero,
            constraints:
            const BoxConstraints(
              minWidth: 28,
              minHeight: 28,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context)
                  .showSnackBar(
                const SnackBar(
                  content: Text(
                    'Showing all 28 played songs',
                  ),
                  behavior:
                  SnackBarBehavior.floating,
                ),
              );
            },
            icon: const Icon(
              Icons.more_vert,
              size: 17,
            ),
          ),
        ],
      ),
    );
  }

  void _showSongMenu(
      BuildContext context,
      String title,
      ) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize:
            MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.play_arrow,
                ),
                title: const Text(
                  'Play',
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.queue_music,
                ),
                title: const Text(
                  'Add to playlist',
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.close,
                ),
                title: const Text(
                  'Remove from history',
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showHistoryMenu(
      BuildContext context,
      ) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize:
            MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.delete_outline,
                ),
                title: const Text(
                  'Clear history',
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}