import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Splash_Screen.dart';
import 'Log_In.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Developer mode
  // true  = always start from Splash Screen
  // false = use normal app startup
  static const bool developerMode = false;

  // Current theme
  ThemeMode themeMode = ThemeMode.dark;

  @override
  void initState() {
    super.initState();
    loadTheme();
  }

  // Load saved theme
  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();

    final bool isDark =
        prefs.getBool('isDarkMode') ?? true;

    if (!mounted) return;

    setState(() {
      themeMode =
      isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  // Change theme
  Future<void> changeTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(
      'isDarkMode',
      isDark,
    );

    if (!mounted) return;

    setState(() {
      themeMode =
      isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // Theme mode
      themeMode: themeMode,

      // Light theme
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,

        // Montserrat font
        textTheme: GoogleFonts.montserratTextTheme(),

        scaffoldBackgroundColor:
        const Color(0xFFF8FAF8),

        colorScheme: const ColorScheme.light(
          primary: Color(0xFF168A4A),
          onPrimary: Colors.white,
          primaryContainer: Color(0xFFD9F4E2),
          onPrimaryContainer: Color(0xFF06351B),
          secondary: Color(0xFF4B6354),
          surface: Color(0xFFFFFFFF),
          onSurface: Color(0xFF18211B),
          surfaceContainerHighest: Color(0xFFE9F0EA),
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF8FAF8),
          foregroundColor: Color(0xFF18211B),
          elevation: 0,
        ),

        // Text fields
        inputDecorationTheme:
        const InputDecorationTheme(
          labelStyle: TextStyle(
            color: Colors.black54,
          ),
          hintStyle: TextStyle(
            color: Colors.black54,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black54,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.green,
              width: 2,
            ),
          ),
        ),

        // General text
        primaryTextTheme: GoogleFonts.montserratTextTheme(
          const TextTheme(
            bodyLarge: TextStyle(
              color: Colors.black,
            ),
            bodyMedium: TextStyle(
              color: Colors.black,
            ),
            bodySmall: TextStyle(
              color: Colors.black54,
            ),
          ),
        ),
      ),

      // Dark theme
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,

        // Montserrat font
        textTheme: GoogleFonts.montserratTextTheme(
          ThemeData.dark().textTheme,
        ),

        scaffoldBackgroundColor:
        const Color(0xFF101411),

        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6FE39A),
          onPrimary: Color(0xFF003919),
          primaryContainer: Color(0xFF075C30),
          onPrimaryContainer: Color(0xFFB4F7C8),
          secondary: Color(0xFFB3CCB8),
          surface: Color(0xFF171C18),
          onSurface: Color(0xFFE0E5DE),
          surfaceContainerHighest: Color(0xFF2B322C),
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
        ),

        // Text fields
        inputDecorationTheme:
        const InputDecorationTheme(
          labelStyle: TextStyle(
            color: Colors.white54,
          ),
          hintStyle: TextStyle(
            color: Colors.white54,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white54,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.green,
              width: 2,
            ),
          ),
        ),

        // General text
        primaryTextTheme: GoogleFonts.montserratTextTheme(
          const TextTheme(
            bodyLarge: TextStyle(
              color: Colors.white,
            ),
            bodyMedium: TextStyle(
              color: Colors.white,
            ),
            bodySmall: TextStyle(
              color: Colors.white54,
            ),
          ),
        ),
      ),

      // Starting page
      home: developerMode
          ? SplashScreen(
        onThemeChanged: changeTheme,
      )
          : LogIn(
        onThemeChanged: changeTheme,
      ),
    );
  }
}