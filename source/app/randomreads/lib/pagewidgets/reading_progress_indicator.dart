// ============================================
// FILE: lib/pages/home_page.dart
// ============================================

import 'package:flutter/material.dart';

class ReadingProgressIndicator extends StatelessWidget {
  final double progress;
  final ThemeData theme;

  const ReadingProgressIndicator({
    super.key,
    required this.progress,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: LinearProgressIndicator(
        value: progress,
        backgroundColor: Colors.transparent,
        minHeight: 3,
        valueColor: AlwaysStoppedAnimation<Color>(
          theme.colorScheme.primary,
        ),
      ),
    );
  }
}
