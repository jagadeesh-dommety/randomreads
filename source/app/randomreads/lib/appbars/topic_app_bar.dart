// ============================================
// FILE: lib/pages/story_feed_screen.dart
// ============================================

import 'package:flutter/material.dart';

class TopicAppBar extends StatelessWidget {
  final String title;
  final ThemeData theme;
  final Function(String)? onSortSelected;  // Callback for sort selection (e.g., 'relevance', 'popular', 'newest', 'oldest')

  const TopicAppBar({
    super.key,
    required this.title,
    required this.theme,
    this.onSortSelected,
  });
  
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 0,
      pinned: false,
      backgroundColor: theme.colorScheme.surface.withOpacity(0.95),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),  // Back functionality: Pop to previous screen
      ),
      centerTitle: true, // Ensures the title is centered
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        )
      ),
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.sort),
          onSelected: onSortSelected ?? (_) {},  // Trigger callback with selected sort type
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'relevance',
              child: Row(
                children: [
                  Icon(Icons.recommend, size: 20),
                  SizedBox(width: 8),
                  Text('Relevance'),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'popular',
              child: Row(
                children: [
                  Icon(Icons.trending_up, size: 20),
                  SizedBox(width: 8),
                  Text('Popular'),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'newest',
              child: Row(
                children: [
                  Icon(Icons.date_range, size: 20),
                  SizedBox(width: 8),
                  Text('Newest'),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'oldest',
              child: Row(
                children: [
                  Icon(Icons.history, size: 20),
                  SizedBox(width: 8),
                  Text('Oldest'),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}
