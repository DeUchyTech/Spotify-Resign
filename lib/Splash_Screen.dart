import 'package:flutter/material.dart';
import 'Mode_Page.dart';

class SplashScreen extends StatefulWidget {
  final Future<void> Function(bool isDark) onThemeChanged;

  const SplashScreen({
    super.key,
    required this.onThemeChanged,
  });

  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  void getStarted() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ModePage(
          onThemeChanged: widget.onThemeChanged,
        ),
      ),
    );
  }

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
            color: Colors.black.withOpacity(0.45),
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

                  // Spotify logo
                  Image.asset(
                    'lib/assets/spotify_logo.png',
                    width: 160,
                    height: 40,
                  ),

                  Column(
                    children: [

                      const Text(
                        'Music for Everyone',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        'Nulla Lorem mollit cupidatat irure. '
                            'Laborum magna nulla duis ullamco cillum dolor. '
                            'Voluptate exercitation incididunt aliquip '
                            'deserunt reprehenderit elit laborum.',
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 1.5,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 40),

                      SizedBox(
                        width: 250,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: getStarted,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Get Started',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
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