import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:randomreads/pagewidgets/my_home_page.dart';
import 'package:app_links/app_links.dart';

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
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSub;

  Uri? _initialDeepLink;
  @override
  void initState() {
    super.initState();
    initDeepLinks();
  }

  Future<void> initDeepLinks() async {
    try {
      final initialLink = await _appLinks.getInitialLink();
      setState(() {
        _initialDeepLink = initialLink;
      });
    } on PlatformException {
      // Handle exception if needed
    }

    _linkSub = _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
       if (!mounted) return;
        setState(() {
          _initialDeepLink = uri;
        });
      }
    }, onError: (err) {
      // Handle error if needed
    });
  }

    @override
  void dispose() {
    _linkSub?.cancel();
    super.dispose();
  }

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
      theme: LightTheme(),
      // ---------- DARK THEME ----------
      darkTheme: DarkTheme(),
      home: MyHomePage(toggleTheme: toggleTheme, readDeepLink: _initialDeepLink),
    );
  }

  ThemeData DarkTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.grey,
        brightness: Brightness.dark,
      ).copyWith(
        surface: const Color(0xFF121212),
        surfaceContainer: const Color(0xFF1E1E1E),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
           fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
          height: 1.2,
          color: Color(0xFFE8E8E8),
        ),
        bodyLarge: TextStyle(
          fontSize: 14,
          height: 1.8,
          letterSpacing: 0.2,
          color: Color(0xFFE8E8E8),
        ),
      ),
    );
  }

  ThemeData LightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.grey,
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
    );
  }
}
