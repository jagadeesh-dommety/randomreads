import 'package:flutter/material.dart';

class SearchTopicSliverAppBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onClear;

  const SearchTopicSliverAppBar({
    super.key,
    required this.controller,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverAppBar(
      pinned: true,
      floating: true,
      snap: true,
      elevation: 0,
      backgroundColor: theme.colorScheme.surface,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: SizedBox(
          height: 42,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Search topics',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: onClear,
                    )
                  : null,
              filled: true,
              fillColor: Colors.grey.shade100,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
