import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:randomreads/my_home_page.dart';

void main() {
  runApp(const RandomReadsApp());
}

class RandomReadsApp extends StatefulWidget {
  const RandomReadsApp({super.key});

  @override
  State<RandomReadsApp> createState() => _RandomReadsAppState();
}

class _RandomReadsAppState extends State<RandomReadsApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void toggleTheme() {
    HapticFeedback.lightImpact();
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random Reads',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,

      // ---------- LIGHT THEME ----------
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ).copyWith(
          surface: const Color(0xFFFAF9F6),
          surfaceContainer: Colors.white,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            height: 1.2,
          ),
          bodyLarge: TextStyle(
            fontSize: 14,
            height: 1.8,
            letterSpacing: 0.2,
            color: Color(0xFF333333),
          ),
        ),
      ),

      // ---------- DARK THEME ----------
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ).copyWith(
          surface: const Color(0xFF121212),
          surfaceContainer: const Color(0xFF1E1E1E),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
            height: 1.2,
            color: Color(0xFFE8E8E8),
          ),
          bodyLarge: TextStyle(
            fontSize: 14,
            height: 1.8,
            letterSpacing: 0.2,
            color: Color(0xFF333333),
          ),
        ),
      ),

      home: MyHomePage(toggleTheme: toggleTheme),
    );
  }
}
