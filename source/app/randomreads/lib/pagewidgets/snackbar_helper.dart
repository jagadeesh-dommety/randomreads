// ============================================
// FILE: lib/pages/home_page.dart
// ============================================

import 'package:flutter/material.dart';

class SnackbarHelper {
  static void showQuick(BuildContext context, String message) {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Text(
            message,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
            ),
          ),
        ])
        ,
        duration: const Duration(milliseconds: 600),
        behavior: SnackBarBehavior.floating,
        backgroundColor: theme.colorScheme.surface,
        margin: EdgeInsets.symmetric(horizontal:  MediaQuery.of(context).size.width * 0.3,  vertical: 12,
),
        
        elevation: 6.0,
      ),
    );
  }

  static void showWithIcon(BuildContext context, String message, IconData icon) {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: IntrinsicWidth(
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: theme.colorScheme.onSurface, size: 20),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    message,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        duration: const Duration(milliseconds: 800),
        behavior: SnackBarBehavior.floating,
        backgroundColor: theme.colorScheme.surface,
        margin: EdgeInsets.symmetric(horizontal:  MediaQuery.of(context).size.width * 0.3,  vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 6.0,
      ),
    );
  }

  static void showSuccess(BuildContext context, String message) {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: IntrinsicWidth(
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    message,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green.shade600,
        margin: EdgeInsets.symmetric(horizontal:  MediaQuery.of(context).size.width * 0.3,  vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 6.0,
      ),
    );
  }

  static void showError(BuildContext context, String message) {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: IntrinsicWidth(
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    message,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red.shade600,
        margin: EdgeInsets.symmetric(horizontal:  MediaQuery.of(context).size.width * 0.3,  vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 6.0,
      ),
    );
  }

  static void showInfo(BuildContext context, String message) {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: IntrinsicWidth(
          child: Center(
            child: Text(
              message,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ),
        duration: const Duration(milliseconds: 1000),
        behavior: SnackBarBehavior.floating,
        backgroundColor: theme.colorScheme.surface,
        margin: EdgeInsets.symmetric(horizontal:  MediaQuery.of(context).size.width * 0.3,  vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 6.0,
      ),
    );
  }
}