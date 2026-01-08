import 'package:flutter/material.dart';
import 'package:randomreads/pagewidgets/search_topic_screen.dart';
import 'package:randomreads/pagewidgets/story_feed_screen.dart';
import 'package:randomreads/pagewidgets/topic_feed_screen.dart';

class RandomreadsAppBar extends StatelessWidget {
  const RandomreadsAppBar({
    super.key,
    required this.theme,
  });

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 0,
      pinned: false,
      backgroundColor: theme.colorScheme.surface.withOpacity(0.95),
      elevation: 0,
      leading: const Icon(Icons.menu),
      centerTitle: true, // Ensures the title is centered
      title: Text(
        "RandomReads",
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        IconButton(
            onPressed: () {
              Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const StoryFeedScreen(title: "Liked Posts", likedscreen: true)),
            );
            }, icon: const Icon(Icons.favorite_border_outlined)),
        IconButton(onPressed: () async {
          final selectedTopic = await Navigator.of(context).push<String>(
            MaterialPageRoute(builder: (context) => const SearchTopicScreen()),
          );
          if (selectedTopic != null) {
            // Handle the selected topic (e.g., navigate to topic feed)
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => TopicFeedScreen(topicName: selectedTopic)),
            );
          }
        }, icon: const Icon(Icons.search_outlined)),
        const SizedBox(width: 4),
      ],
    );
  }
}

