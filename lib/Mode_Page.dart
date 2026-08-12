import 'package:flutter/material.dart';
import 'Sign_Up.dart';

class ModePage extends StatefulWidget {
  final Future<void> Function(bool isDark) onThemeChanged;

  const ModePage({
    super.key,
    required this.onThemeChanged,
  });

  @override
  State<ModePage> createState() => _ModePageState();
}

class _ModePageState extends State<ModePage> {
  bool isSelected = false;
  bool darkMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,

      body: Stack(
        fit: StackFit.expand,
        children: [

          // BACKGROUND IMAGE
          Image.asset(
            'lib/assets/background.png',
            fit: BoxFit.cover,
          ),

          // DARK OVERLAY
          Container(
            color: Colors.black.withOpacity(
              darkMode ? 0.50 : 0.20,
            ),
          ),

          // CONTENT
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 30,
                horizontal: 16,
              ),
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [

                  // TOP
                  Stack(
                    alignment: Alignment.center,
                    children: [

                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () async {
                            setState(() {
                              isSelected = true;
                            });

                            await Future.delayed(
                              const Duration(
                                milliseconds: 150,
                              ),
                            );

                            if (mounted &&
                                Navigator.canPop(context)) {
                              Navigator.pop(context);
                            }
                          },
                          child: AnimatedContainer(
                            duration:
                            const Duration(
                              milliseconds: 150,
                            ),
                            width: 33,
                            height: 33,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? Colors.white54
                                  : Colors.transparent,
                              border: Border.all(
                                color: Colors.white54,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.arrow_back_ios_new,
                                size: 18,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.white54,
                              ),
                            ),
                          ),
                        ),
                      ),

                      Image.asset(
                        'lib/assets/spotify_logo.png',
                        width: 160,
                        height: 40,
                      ),
                    ],
                  ),

                  // MODE CONTENT
                  Column(
                    children: [

                      const Text(
                        'Choose Mode',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                        children: [

                          // DARK MODE
                          GestureDetector(
                            onTap: () async {

                              setState(() {
                                darkMode = true;
                              });

                              await widget.onThemeChanged(true);
                            },

                            child: Column(
                              children: [

                                CircleAvatar(
                                  radius: 27,

                                  backgroundColor:
                                  darkMode
                                      ? Colors.green
                                      : Colors.white30,

                                  child: const Icon(
                                    Icons.dark_mode_outlined,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  'Dark Mode',
                                  style: TextStyle(
                                    color: darkMode
                                        ? Colors.white
                                        : Colors.white54,
                                    fontSize: 12,
                                    fontWeight: darkMode
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // LIGHT MODE
                          GestureDetector(
                            onTap: () async {

                              setState(() {
                                darkMode = false;
                              });

                              await widget.onThemeChanged(false);
                            },

                            child: Column(
                              children: [

                                CircleAvatar(
                                  radius: 27,

                                  backgroundColor:
                                  !darkMode
                                      ? Colors.green
                                      : Colors.white30,

                                  child: const Icon(
                                    Icons.light_mode_outlined,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  'Light Mode',
                                  style: TextStyle(
                                    color: !darkMode
                                        ? Colors.white
                                        : Colors.white54,
                                    fontSize: 12,
                                    fontWeight: !darkMode
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      SizedBox(
                        width: 250,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SignUp(
                                      onThemeChanged:
                                      widget.onThemeChanged,
                                    ),
                              ),
                            );
                          },
                          child: const Text(
                            'Continue',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight:
                                FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}