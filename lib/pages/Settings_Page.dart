import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
  });

  @override
  State<SettingsPage> createState() =>
      _SettingsPageState();
}

class _SettingsPageState
    extends State<SettingsPage> {
  bool _isDarkMode = true;
  bool _notificationsEnabled = true;
  bool _autoplayEnabled = true;
  bool _dataSaverEnabled = false;
  bool _highQualityAudio = true;
  bool _hapticFeedback = true;
  bool _recentlyPlayedEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      _isDarkMode =
          prefs.getBool('isDarkMode') ?? true;

      _notificationsEnabled =
          prefs.getBool('notificationsEnabled') ??
              true;

      _autoplayEnabled =
          prefs.getBool('autoplayEnabled') ?? true;

      _dataSaverEnabled =
          prefs.getBool('dataSaverEnabled') ?? false;

      _highQualityAudio =
          prefs.getBool('highQualityAudio') ?? true;

      _hapticFeedback =
          prefs.getBool('hapticFeedback') ?? true;

      _recentlyPlayedEnabled =
          prefs.getBool('recentlyPlayedEnabled') ??
              true;
    });
  }

  Future<void> _saveBool(
      String key,
      bool value,
      ) async {
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    await prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor:
      theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor:
        theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 19,
          ),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          20,
          5,
          20,
          35,
        ),
        children: [
          _buildSettingsIntro(context),
          const SizedBox(height: 25),
          _buildSectionTitle(
            context,
            'Appearance',
          ),
          const SizedBox(height: 8),
          _buildSettingsCard(
            context,
            children: [
              _buildSwitchTile(
                context,
                icon: _isDarkMode
                    ? Icons.dark_mode_outlined
                    : Icons.light_mode_outlined,
                title: 'Dark mode',
                subtitle: _isDarkMode
                    ? 'Dark theme is active'
                    : 'Light theme is active',
                value: _isDarkMode,
                onChanged: _changeDarkMode,
              ),
            ],
          ),
          const SizedBox(height: 22),
          _buildSectionTitle(
            context,
            'Playback',
          ),
          const SizedBox(height: 8),
          _buildSettingsCard(
            context,
            children: [
              _buildSwitchTile(
                context,
                icon: Icons.play_circle_outline,
                title: 'Autoplay',
                subtitle:
                'Continue playing similar songs',
                value: _autoplayEnabled,
                onChanged: (value) {
                  setState(() {
                    _autoplayEnabled = value;
                  });

                  _saveBool(
                    'autoplayEnabled',
                    value,
                  );
                },
              ),
              _buildDivider(context),
              _buildSwitchTile(
                context,
                icon: Icons.high_quality_outlined,
                title: 'High-quality audio',
                subtitle:
                'Use higher audio quality when available',
                value: _highQualityAudio,
                onChanged: (value) {
                  setState(() {
                    _highQualityAudio = value;
                  });

                  _saveBool(
                    'highQualityAudio',
                    value,
                  );
                },
              ),
              _buildDivider(context),
              _buildSwitchTile(
                context,
                icon:
                Icons.data_saver_off_outlined,
                title: 'Data Saver',
                subtitle:
                'Reduce mobile data usage',
                value: _dataSaverEnabled,
                onChanged: (value) {
                  setState(() {
                    _dataSaverEnabled = value;
                  });

                  _saveBool(
                    'dataSaverEnabled',
                    value,
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 22),
          _buildSectionTitle(
            context,
            'Notifications',
          ),
          const SizedBox(height: 8),
          _buildSettingsCard(
            context,
            children: [
              _buildSwitchTile(
                context,
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                subtitle:
                'Receive music and app notifications',
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });

                  _saveBool(
                    'notificationsEnabled',
                    value,
                  );
                },
              ),
              _buildDivider(context),
              _buildSwitchTile(
                context,
                icon: Icons.vibration_outlined,
                title: 'Haptic feedback',
                subtitle:
                'Feel a small vibration when interacting',
                value: _hapticFeedback,
                onChanged: (value) {
                  setState(() {
                    _hapticFeedback = value;
                  });

                  _saveBool(
                    'hapticFeedback',
                    value,
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 22),
          _buildSectionTitle(
            context,
            'Library',
          ),
          const SizedBox(height: 8),
          _buildSettingsCard(
            context,
            children: [
              _buildSwitchTile(
                context,
                icon: Icons.history,
                title: 'Recently played',
                subtitle:
                'Keep your listening history',
                value: _recentlyPlayedEnabled,
                onChanged: (value) {
                  setState(() {
                    _recentlyPlayedEnabled = value;
                  });

                  _saveBool(
                    'recentlyPlayedEnabled',
                    value,
                  );
                },
              ),
              _buildDivider(context),
              _buildActionTile(
                context,
                icon: Icons.delete_outline,
                title: 'Clear recently played',
                subtitle:
                'Remove your listening history',
                destructive: true,
                onTap: _clearRecentlyPlayed,
              ),
            ],
          ),
          const SizedBox(height: 22),
          _buildSectionTitle(
            context,
            'App',
          ),
          const SizedBox(height: 8),
          _buildSettingsCard(
            context,
            children: [
              _buildActionTile(
                context,
                icon: Icons.restore,
                title: 'Reset settings',
                subtitle:
                'Restore all settings to default',
                onTap: _resetSettings,
              ),
              _buildDivider(context),
              _buildActionTile(
                context,
                icon: Icons.info_outline,
                title: 'About',
                subtitle: 'Spotify Redesign',
                onTap: _showAbout,
              ),
            ],
          ),
          const SizedBox(height: 30),
          Center(
            child: Text(
              'Spotify Redesign',
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 11,
                color: theme.textTheme.bodySmall?.color
                    ?.withOpacity(0.45),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text(
              'Version 1.0.0',
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 10,
                color: theme.textTheme.bodySmall?.color
                    ?.withOpacity(0.35),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsIntro(
      BuildContext context,
      ) {
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary
            .withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.primary
              .withOpacity(0.08),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary
                  .withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.settings_outlined,
              color: theme.colorScheme.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'Customize your experience',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Make small changes to the way your music app works.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 10,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(
      BuildContext context,
      String title,
      ) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleSmall
            ?.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(
      BuildContext context, {
        required List<Widget> children,
      }) {
    final ThemeData theme = Theme.of(context);

    final bool dark =
        theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: dark
            ? const Color(0xFF202020)
            : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: dark
              ? Colors.white.withOpacity(0.05)
              : Colors.black.withOpacity(0.05),
        ),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSwitchTile(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required bool value,
        required ValueChanged<bool> onChanged,
      }) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 11,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary
                  .withOpacity(0.10),
              borderRadius:
              BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 21,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 10,
                    height: 1.3,
                    color: theme
                        .textTheme
                        .bodySmall
                        ?.color
                        ?.withOpacity(0.60),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor:
            theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required VoidCallback onTap,
        bool destructive = false,
      }) {
    final ThemeData theme = Theme.of(context);

    final Color iconColor = destructive
        ? Colors.redAccent
        : theme.colorScheme.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color:
                iconColor.withOpacity(0.10),
                borderRadius:
                BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 21,
                color: iconColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color:
                      destructive
                          ? Colors.redAccent
                          : null,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 10,
                      color: theme
                          .textTheme
                          .bodySmall
                          ?.color
                          ?.withOpacity(0.60),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 20,
              color: theme.iconTheme.color
                  ?.withOpacity(0.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(
      BuildContext context,
      ) {
    final bool dark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return Divider(
      height: 1,
      indent: 66,
      endIndent: 14,
      color: dark
          ? Colors.white.withOpacity(0.05)
          : Colors.black.withOpacity(0.05),
    );
  }

  Future<void> _changeDarkMode(
      bool value,
      ) async {
    setState(() {
      _isDarkMode = value;
    });

    await _saveBool(
      'isDarkMode',
      value,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          value
              ? 'Dark mode enabled'
              : 'Light mode enabled',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _clearRecentlyPlayed() async {
    final bool? confirm =
    await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Clear recently played?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'This will remove your recently played history from the app.',
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
                backgroundColor: Colors.redAccent,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );

    if (confirm != true) {
      return;
    }

    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    await prefs.remove('recentlyPlayed');

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Recently played cleared',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _resetSettings() async {
    final bool? confirm =
    await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Reset settings?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'All app preferences will return to their default values. Your profile and playlists will not be deleted.',
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
                backgroundColor: Colors.redAccent,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );

    if (confirm != true) {
      return;
    }

    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    await prefs.setBool('isDarkMode', true);
    await prefs.setBool(
      'notificationsEnabled',
      true,
    );
    await prefs.setBool(
      'autoplayEnabled',
      true,
    );
    await prefs.setBool(
      'dataSaverEnabled',
      false,
    );
    await prefs.setBool(
      'highQualityAudio',
      true,
    );
    await prefs.setBool(
      'hapticFeedback',
      true,
    );
    await prefs.setBool(
      'recentlyPlayedEnabled',
      true,
    );

    if (!mounted) return;

    setState(() {
      _isDarkMode = true;
      _notificationsEnabled = true;
      _autoplayEnabled = true;
      _dataSaverEnabled = false;
      _highQualityAudio = true;
      _hapticFeedback = true;
      _recentlyPlayedEnabled = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Settings restored to default',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showAbout() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        final ThemeData theme =
        Theme.of(context);

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary
                      .withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.music_note,
                  size: 32,
                  color:
                  theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Spotify Redesign',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'A Spotify-inspired Flutter music application.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              Text(
                'Version 1.0.0',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme
                      .textTheme
                      .bodySmall
                      ?.color
                      ?.withOpacity(0.55),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}