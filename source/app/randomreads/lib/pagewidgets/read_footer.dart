import 'package:flutter/material.dart';
import 'package:randomreads/pagewidgets/my_home_page.dart';

class ReadFooter extends StatefulWidget {
  const ReadFooter({
    super.key,
    required this.theme,
    required bool isSaved,
  }) : _isSaved = isSaved;

  final ThemeData theme;
  final bool _isSaved;

  @override
  State<ReadFooter> createState() => _ReadFooterState();
}

class _ReadFooterState extends State<ReadFooter> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Enjoyed this read?",
          style: widget.theme.textTheme.bodyMedium?.copyWith(
            color: widget.theme.colorScheme.onSurface
                .withOpacity(0.7),
          ),
        ),
        IconButton.filled(
          icon: Icon(
            widget._isSaved
                ? Icons.favorite
                : Icons.favorite_border,
          ),
          onPressed: (){},
          style: IconButton.styleFrom(
            backgroundColor: widget._isSaved
                ? Colors.red.shade400
                : widget.theme.colorScheme.primaryContainer,
            foregroundColor: widget._isSaved
                ? Colors.white
                : widget.theme.colorScheme.onPrimaryContainer,
          ),
        ),
      ],
    );
  }
}
