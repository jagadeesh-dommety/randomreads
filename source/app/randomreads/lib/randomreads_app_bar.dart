import 'package:flutter/material.dart';

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
            onPressed: () {}, icon: const Icon(Icons.favorite_border_outlined)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.search_outlined)),
        const SizedBox(width: 4),
      ],
    );
  }
}
