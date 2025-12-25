// ============================================
// FILE: lib/pages/home_page.dart
// ============================================
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:randomreads/models/readitem.dart';
import 'package:randomreads/appbars/randomreads_app_bar.dart';
import 'package:randomreads/pagewidgets/reading_content.dart';
import 'package:randomreads/pagewidgets/reading_progress_indicator.dart';
import 'package:randomreads/pagewidgets/snackbar_helper.dart';
import 'package:randomreads/pagewidgets/story_feed_screen.dart';
import 'package:randomreads/services/getreadsservice.dart';
class MyHomePage extends StatefulWidget {
  final VoidCallback toggleTheme;

  const MyHomePage({super.key, required this.toggleTheme});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return StoryFeedScreen(title: "RandomReads",
    toggleTheme: widget.toggleTheme,);
  }
}



