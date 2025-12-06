// ============================================
// FILE: lib/pages/home_page.dart
// ============================================

import 'package:flutter/material.dart';
import 'package:randomreads/models/readitem.dart';
import 'package:randomreads/pagewidgets/read_footer.dart';
import 'package:randomreads/pagewidgets/read_title_widget.dart';

class ReadingContent extends StatelessWidget {
  final double contentWidth;
  final ReadItem currentReadItem;
  final double fontSize;
  final double lineHeight;
  final bool isSaved;
  final ThemeData theme;
  final VoidCallback onSingleTap;
  final VoidCallback onDoubleTap;
  final Function(DragEndDetails) onHorizontalDragEnd;

  const ReadingContent({
    super.key,
    required this.contentWidth,
    required this.currentReadItem,
    required this.fontSize,
    required this.lineHeight,
    required this.isSaved,
    required this.theme,
    required this.onSingleTap,
    required this.onDoubleTap,
    required this.onHorizontalDragEnd,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSingleTap,
      onDoubleTap: onDoubleTap,
      onHorizontalDragEnd: onHorizontalDragEnd,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: contentWidth,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReadTitleWidget(
              theme: theme,
              currentread: currentReadItem,
            ),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              style: theme.textTheme.bodyLarge!.copyWith(
                fontSize: fontSize,
                height: lineHeight,
              ),
              child: Text(
                currentReadItem.content,
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(height: 24),
            Divider(
              height: 1,
              color: theme.colorScheme.onSurface.withOpacity(0.1),
            ),
            const SizedBox(height: 16),
            ReadFooter(theme: theme, isSaved: isSaved),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
