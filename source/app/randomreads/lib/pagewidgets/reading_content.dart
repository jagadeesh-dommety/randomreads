// ============================================
// FILE: lib/pages/home_page.dart
// ============================================

import 'package:flutter/material.dart';
import 'package:randomreads/common/activity_manager.dart';
import 'package:randomreads/models/read_stats.dart';
import 'package:randomreads/models/readitem.dart';
import 'package:randomreads/pagewidgets/read_footer.dart';
import 'package:randomreads/pagewidgets/read_title_widget.dart';
import 'package:randomreads/pagewidgets/story_feed_screen.dart';

class ReadingContent extends StatefulWidget {
  final double contentWidth;
  final ReadItem currentReadItem;
  final ReadStats currentReadStats;
  final double fontSize;
  final double lineHeight;
  final ThemeData theme;
  final ActivityManager activityManager;
  final VoidCallback onSingleTap;
  final VoidCallback onDoubleTap;
  final Function(DragEndDetails) onHorizontalDragEnd;

  const ReadingContent({
    super.key,
    required this.contentWidth,
    required this.currentReadItem,
    required this.currentReadStats,
    required this.fontSize,
    required this.lineHeight,
    required this.theme,
    required this.activityManager,
    required this.onDoubleTap,
    required this.onSingleTap,
    required this.onHorizontalDragEnd, 
  });

  @override
  State<ReadingContent> createState() => _ReadingContentState();
}

class _ReadingContentState extends State<ReadingContent> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onSingleTap,
      onDoubleTap: widget.onDoubleTap,
      onHorizontalDragEnd: widget.onHorizontalDragEnd,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: widget.contentWidth,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReadTitleWidget(
              theme: widget.theme,
              currentread: widget.currentReadItem,
            ),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              style: widget.theme.textTheme.bodyLarge!.copyWith(
                fontSize: widget.fontSize,
                height: widget.lineHeight,
              ),
              child: Text(
                widget.currentReadItem.content,
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(height: 24),
            Divider(
              height: 1,
              color: widget.theme.colorScheme.onSurface.withOpacity(0.1),
            ),
            const SizedBox(height: 16),
            ReadFooter(theme: widget.theme, 
            readStats: widget.currentReadStats,
            activityManager: widget.activityManager,
            onDoubleTap: widget.onDoubleTap
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
