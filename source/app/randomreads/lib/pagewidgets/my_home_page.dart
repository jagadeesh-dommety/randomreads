// ============================================
// FILE: lib/pages/home_page.dart
// ============================================
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:randomreads/models/TokenResponse.dart';
import 'package:randomreads/pagewidgets/story_feed_screen.dart';
import 'package:randomreads/services/auth_storage_service.dart';
import 'package:randomreads/services/userservice.dart';
import 'package:uuid/uuid.dart';

class MyHomePage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final Uri? readDeepLink;
  const MyHomePage({super.key, required this.toggleTheme, this.readDeepLink});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool initialized = false;
  @override
  void initState()  {
    super.initState();
    initializeUser();
    }

  Future<void> initializeUser() async {
    String? accessToken = await AuthStorageService.getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      String newUserId = const Uuid().v4();
      TokenResponse? tokenResponse = await UserService().createUser(newUserId);
      if (tokenResponse != null) {
        await AuthStorageService.saveUserId(newUserId);
        await AuthStorageService.saveTokens(
          accessToken: tokenResponse.token,
          accessTokenExpiry: tokenResponse.expiresAt,
        );
      }
    }
    setState(() {
      initialized = true;
    });
  }
  @override
  Widget build(BuildContext context) {
    if (!initialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return StoryFeedScreen(title: "RandomReads",
    toggleTheme: widget.toggleTheme,likedscreen:false, readDeepLink: widget.readDeepLink,);
  }
}



