import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify_redesign/pages/Settings_Page.dart';

import 'Settings_Page.dart';

class ProfilePage extends StatefulWidget {
  final String fullname;
  final String email;
  final VoidCallback onLogout;

  const ProfilePage({
    super.key,
    required this.fullname,
    required this.email,
    required this.onLogout,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _imagePicker = ImagePicker();

  late String _name;
  late String _email;

  String _profileImage = '';

  int _followers = 129;
  int _following = 238;

  @override
  void initState() {
    super.initState();

    _name = widget.fullname;
    _email = widget.email;

    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      _name = prefs.getString('profile_name') ?? widget.fullname;
      _email = prefs.getString('profile_email') ?? widget.email;
      _profileImage = prefs.getString('profile_image') ?? '';
      _followers = prefs.getInt('profile_followers') ?? 129;
      _following = prefs.getInt('profile_following') ?? 238;
    });
  }

  Future<void> _saveProfile({
    required String name,
    required String email,
    String? image,
  }) async {
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    await prefs.setString('profile_name', name);
    await prefs.setString('profile_email', email);

    if (image != null && image.isNotEmpty) {
      await prefs.setString('profile_image', image);
    }

    if (!mounted) return;

    setState(() {
      _name = name;
      _email = email;

      if (image != null && image.isNotEmpty) {
        _profileImage = image;
      }
    });
  }

  Future<String?> _pickProfileImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image == null) {
        return null;
      }

      return image.path;
    } catch (e) {
      if (!mounted) return null;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to select image: $e'),
        ),
      );

      return null;
    }
  }

  Future<void> _editProfile() async {
    final TextEditingController nameController =
    TextEditingController(text: _name);

    final TextEditingController emailController =
    TextEditingController(text: _email);

    String selectedImage = _profileImage;

    final bool? saved = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (
              BuildContext context,
              StateSetter setDialogState,
              ) {
            final ThemeData theme = Theme.of(context);

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              title: const Text(
                'Edit Profile',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final String? image =
                        await _pickProfileImage();

                        if (image != null) {
                          setDialogState(() {
                            selectedImage = image;
                          });
                        }
                      },
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            width: 90,
                            height: 90,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: _profileImageWidget(
                              selectedImage,
                              90,
                            ),
                          ),
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    TextField(
                      controller: nameController,
                      textCapitalization:
                      TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        prefixIcon: const Icon(
                          Icons.person_outline,
                        ),
                        border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: emailController,
                      keyboardType:
                      TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                        ),
                        border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop(false);
                  },
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    final String name =
                    nameController.text.trim();

                    final String email =
                    emailController.text.trim();

                    if (name.isEmpty || email.isEmpty) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Name and email cannot be empty',
                          ),
                        ),
                      );
                      return;
                    }

                    Navigator.of(dialogContext).pop(true);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );

    if (saved == true) {
      await _saveProfile(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        image: selectedImage,
      );
    }

    nameController.dispose();
    emailController.dispose();
  }

  Widget _profileImageWidget(
      String? imagePath,
      double size,
      ) {
    if (imagePath != null && imagePath.isNotEmpty) {
      return Image.file(
        File(imagePath),
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (
            BuildContext context,
            Object error,
            StackTrace? stackTrace,
            ) {
          return _defaultProfileImage(size);
        },
      );
    }

    return _defaultProfileImage(size);
  }

  Widget _defaultProfileImage(double size) {
    return Container(
      width: size,
      height: size,
      color: Colors.grey.shade700,
      child: Icon(
        Icons.person,
        size: size * 0.55,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final bool dark =
        theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _buildProfileHeader(context, dark),
                    const SizedBox(height: 15),
                    _buildActionButtons(context),
                    const SizedBox(height: 25),
                    _buildMostlyPlayed(context),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return SizedBox(
      height: 55,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            'Profile',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Positioned(
            right: 15,
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 32,
                minHeight: 32,
              ),
              onPressed: () {
                _showProfileMenu(context);
              },
              icon: const Icon(
                Icons.more_horiz,
                size: 21,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(
      BuildContext context,
      bool dark,
      ) {
    final ThemeData theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        25,
      ),
      decoration: BoxDecoration(
        color: dark
            ? const Color(0xFF303030)
            : const Color(0xFFE9E9E9),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(38),
          bottomRight: Radius.circular(38),
        ),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: _editProfile,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 86,
                  height: 86,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: _profileImageWidget(
                    _profileImage,
                    86,
                  ),
                ),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.edit,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _name,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            _email,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatistic(
                context,
                'Followers',
                _followers.toString(),
              ),
              _buildStatistic(
                context,
                'Following',
                _following.toString(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatistic(
      BuildContext context,
      String label,
      String value,
      ) {
    return SizedBox(
      width: 100,
      child: Column(
        children: [
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
      BuildContext context,
      ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildActionButton(
          context,
          icon: Icons.person_add_alt_1,
          label: 'Find friend',
          onTap: () {
            _showFindFriend(context);
          },
        ),
        const SizedBox(width: 55),
        _buildActionButton(
          context,
          icon: Icons.share_outlined,
          label: 'Share',
          onTap: () {
            _shareProfile(context);
          },
        ),
      ],
    );
  }

  Widget _buildActionButton(
      BuildContext context, {
        required IconData icon,
        required String label,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 75,
        child: Column(
          children: [
            Icon(
              icon,
              size: 27,
            ),
            const SizedBox(height: 5),
            Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMostlyPlayed(
      BuildContext context,
      ) {
    final List<Map<String, String>> songs = [
      {
        'title': 'Dekat Di Hati',
        'artist': 'RAN',
        'image': 'lib/assets/dekat_di_hati.jpg',
      },
      {
        'title': 'Bigger Than The Whole...',
        'artist': 'Taylor Swift',
        'image': 'lib/assets/taylor_swift.jpg',
      },
      {
        'title': 'Matilda',
        'artist': 'Harry Styles',
        'image': 'lib/assets/matilda.jpg',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            'Mostly played',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 11),
          ...songs.map(
                (song) {
              return _buildMostlyPlayedItem(
                context,
                title: song['title']!,
                artist: song['artist']!,
                image: song['image']!,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMostlyPlayedItem(
      BuildContext context, {
        required String title,
        required String artist,
        required String image,
      }) {
    return SizedBox(
      height: 58,
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              image,
              fit: BoxFit.cover,
              errorBuilder: (
                  BuildContext context,
                  Object error,
                  StackTrace? stackTrace,
                  ) {
                return Container(
                  color: Colors.grey.shade700,
                  child: const Icon(
                    Icons.music_note,
                    color: Colors.white,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 10),
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
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  artist,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 25,
              minHeight: 25,
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
        ],
      ),
    );
  }

  void _showFindFriend(
      BuildContext context,
      ) {
    final TextEditingController searchController =
    TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (BuildContext sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: MediaQuery.of(sheetContext)
                .viewInsets
                .bottom +
                20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              const Text(
                'Find friend',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search by name',
                  prefixIcon: const Icon(
                    Icons.search,
                  ),
                  border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(14),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    final String query =
                    searchController.text.trim();

                    Navigator.of(sheetContext).pop();

                    if (query.isNotEmpty && mounted) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        SnackBar(
                          content: Text(
                            'Searching for $query',
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text('Search'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _shareProfile(
      BuildContext context,
      ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Share $_name\'s profile',
        ),
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
      builder: (BuildContext sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.play_arrow,
                ),
                title: const Text('Play'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
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
                  Navigator.of(sheetContext).pop();
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.remove_circle_outline,
                ),
                title: const Text(
                  'Remove from mostly played',
                ),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showProfileMenu(
      BuildContext context,
      ) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (BuildContext sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.edit_outlined,
                ),
                title: const Text(
                  'Edit profile',
                ),
                onTap: () {
                  Navigator.of(sheetContext).pop();

                  Future.delayed(
                    const Duration(
                      milliseconds: 150,
                    ),
                        () {
                      if (mounted) {
                        _editProfile();
                      }
                    },
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.settings_outlined,
                ),
                title: const Text(
                  'Settings',
                ),
                onTap: () {
                  Navigator.of(sheetContext).pop();

                  Future.delayed(
                    const Duration(
                      milliseconds: 150,
                    ),
                        () {
                      if (mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const SettingsPage(),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.logout,
                ),
                title: const Text(
                  'Logout',
                ),
                onTap: () {
                  Navigator.of(sheetContext).pop();

                  widget.onLogout();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}