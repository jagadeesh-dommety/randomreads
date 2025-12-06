import 'package:flutter/material.dart';
import 'package:randomreads/pagewidgets/my_home_page.dart';

class Thememode extends StatelessWidget {
  const Thememode({
    super.key,
    required this.widget,
    required this.theme,
  });

  final MyHomePage widget;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        theme.brightness == Brightness.dark
            ? Icons.light_mode_outlined
            : Icons.dark_mode_outlined,
      ),
      onPressed: widget.toggleTheme,
      tooltip: "Toggle theme",
    );
  }
}
//Thememode(widget: widget, theme: theme),