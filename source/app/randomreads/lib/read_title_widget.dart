import 'package:flutter/material.dart';

class ReadTitleWidget extends StatelessWidget {
  const ReadTitleWidget({
    super.key,
    required this.theme,
  });

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        
        // Story Title
        Text(
          "The Endless Chase for Pi",
          style: theme.textTheme.displayLarge,
        ),
        
        const SizedBox(height: 4),
        
        // Metadata
        Row(
          children: [
            Icon(
              Icons.access_time,
              size: 16,
              color:
                  theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            const SizedBox(width: 6),
            Text(
              "3 min read",
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface
                    .withOpacity(0.6),
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "History",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Divider
        Container(
          height: 1,
          color: theme.colorScheme.onSurface.withOpacity(0.1),
        ),
        
        const SizedBox(height: 16),
      ],
    );
  }
}
