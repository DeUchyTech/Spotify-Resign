import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Log_In.dart';
import 'pages/history_page.dart';
import 'pages/home_page.dart';
import 'pages/playlist_page.dart';
import 'pages/profile_page.dart';

class HomePage extends StatefulWidget {
  final Future<void> Function(bool isDark)? onThemeChanged;

  const HomePage({
    super.key,
    this.onThemeChanged,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedBottomIndex = 0;

  bool _notificationsEnabled = true;

  String _fullname = '';
  String _email = '';

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Load saved user information
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      _fullname = prefs.getString('fullname') ?? '';
      _email = prefs.getString('email') ?? '';

      _notificationsEnabled =
          prefs.getBool('notificationsEnabled') ?? true;
    });
  }

  // Logout user
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('isLoggedIn', false);

    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => LogIn(
          onThemeChanged: widget.onThemeChanged,
        ),
      ),
          (_) => false,
    );
  }

  // Change notification setting
  Future<void> _setNotifications(bool enabled) async {
    setState(() {
      _notificationsEnabled = enabled;
    });

    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(
      'notificationsEnabled',
      enabled,
    );
  }

  // Change theme
  Future<void> _setTheme(bool isDark) async {
    await widget.onThemeChanged?.call(isDark);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  // Show settings
  void _showSettings() {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor:
      Theme.of(context).colorScheme.surface,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              4,
              16,
              20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Settings',
                  style: Theme.of(sheetContext)
                      .textTheme
                      .titleLarge,
                ),

                const SizedBox(height: 8),

                SwitchListTile.adaptive(
                  value: _notificationsEnabled,
                  onChanged: _setNotifications,
                  secondary: const Icon(
                    Icons.notifications_outlined,
                  ),
                  title: const Text(
                    'Notifications',
                  ),
                  subtitle: const Text(
                    'Get updates about new music',
                  ),
                ),

                SwitchListTile.adaptive(
                  value: isDark,
                  onChanged: widget.onThemeChanged == null
                      ? null
                      : _setTheme,
                  secondary: Icon(
                    isDark
                        ? Icons.dark_mode_outlined
                        : Icons.light_mode_outlined,
                  ),
                  title: const Text(
                    'Dark mode',
                  ),
                  subtitle: Text(
                    isDark
                        ? 'Using the dark appearance'
                        : 'Using the light appearance',
                  ),
                ),

                ListTile(
                  leading: const Icon(
                    Icons.help_outline,
                  ),
                  title: const Text(
                    'Help',
                  ),
                  onTap: () {
                    Navigator.pop(sheetContext);

                    showAboutDialog(
                      context: context,
                      applicationName:
                      'Spotify Redesign',
                      applicationVersion:
                      '1.0.0',
                      children: const [
                        Text(
                          'Search music, browse your playlists, '
                              'and manage your listening history '
                              'from the navigation bar.',
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
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
    final pages = [
      HomeContent(
        fullname: _fullname,
        onSettings: _showSettings,
      ),

      const PlaylistPage(),

      const HistoryPage(),

      ProfilePage(
        fullname: _fullname,
        email: _email,
        onLogout: _logout,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(
            milliseconds: 180,
          ),
          child: pages[_selectedBottomIndex],
        ),
      ),

      bottomNavigationBar:
      _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return SizedBox(
      width: double.infinity,
      height: 92,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: 10,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF303030),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _bottomNavItem(
                      icon: Icons.home_outlined,
                      selectedIcon: Icons.home,
                      label: 'Home',
                      index: 0,
                    ),
                  ),

                  Expanded(
                    child: _bottomNavItem(
                      icon: Icons.queue_music_outlined,
                      selectedIcon: Icons.queue_music,
                      label: 'Playlist',
                      index: 1,
                    ),
                  ),

                  const SizedBox(
                    width: 70,
                  ),

                  Expanded(
                    child: _bottomNavItem(
                      icon: Icons.history_outlined,
                      selectedIcon: Icons.history,
                      label: 'History',
                      index: 2,
                    ),
                  ),

                  Expanded(
                    child: _bottomNavItem(
                      icon: Icons.person_outline,
                      selectedIcon: Icons.person,
                      label: 'Profile',
                      index: 3,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: -14,
            child: GestureDetector(
              onTap: () {
                _showMessage('Spotify');
              },
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black,
                    width: 5,
                  ),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'lib/assets/Spotify_icon.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomNavItem({
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required int index,
  }) {
    final bool isSelected =
        _selectedBottomIndex == index;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          _selectedBottomIndex = index;
        });
      },
      child: SizedBox(
        height: 86,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: isSelected ? 38 : 0,
              height: isSelected ? 6 : 0,
              decoration: BoxDecoration(
                color: const Color(0xFF25D366),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Icon(
              isSelected ? selectedIcon : icon,
              size: 25,
              color: isSelected
                  ? const Color(0xFF25D366)
                  : Colors.white54,
            ),

            const SizedBox(height: 3),

            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected
                    ? FontWeight.w600
                    : FontWeight.normal,
                color: isSelected
                    ? const Color(0xFF25D366)
                    : Colors.white54,
              ),
            ),

            const SizedBox(height: 5),


          ],
        ),
      ),
    );
  }
}