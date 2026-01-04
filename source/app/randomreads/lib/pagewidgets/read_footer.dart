import 'package:flutter/material.dart';
import 'package:randomreads/common/activity_manager.dart';
import 'package:randomreads/pagewidgets/story_feed_screen.dart';
import 'package:share_plus/share_plus.dart';

class ReadFooter extends StatefulWidget {
  const ReadFooter({
    super.key, required this.theme, required this.readStats, required this.activityManager,
    required this.onDoubleTap
  });

  final ThemeData theme;
  final ReadStats readStats;
  final ActivityManager activityManager;
  final VoidCallback onDoubleTap;

  @override
  State<ReadFooter> createState() => _ReadFooterState();
}

class _ReadFooterState extends State<ReadFooter> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _actionItem(
          icon: widget.readStats.hasliked ? Icons.favorite : Icons.favorite_border,
          count: widget.readStats.likescount,
          color: widget.readStats.hasliked ? Colors.redAccent : widget.theme.iconTheme.color,
          onTap: widget.onDoubleTap
        ),

        _actionItem(
          icon: Icons.ios_share,
          count: widget.readStats.shareCount,
          onTap: () {
            SharePlus.instance.share(
  ShareParams(text: 'check this read')
);
          widget.activityManager.setShared(true);
          widget.readStats.hasshared = true;
          widget.readStats.shareCount +=1;
          },
        ),

        _actionItem(
          icon: Icons.flag_outlined,
          onTap: () {
            _showReportModal(context);
            
          },
        ),
      ],
    );
  }

Widget _actionItem({
  required IconData icon,
  int? count,
  String? labelIfNoCount,
  Color? color,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    behavior: HitTestBehavior.opaque,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 22,
            color: color ?? widget.theme.iconTheme.color,
          ),
          if (count != null || labelIfNoCount != null) ...[
            const SizedBox(width: 6),
            Text(
              count != null ? _formatCount(count) : labelIfNoCount!,
              style: widget.theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: widget.theme.colorScheme.onSurface.withOpacity(0.75),
              ),
            ),
          ],
        ],
      ),
    ),
  );
}

String _formatCount(int count) {
  if (count >= 1000000) {
    return "${(count / 1000000).toStringAsFixed(1)}M";
  }
  if (count >= 1000) {
    return "${(count / 1000).toStringAsFixed(1)}K";
  }
  return count.toString();
}

  void _showReportModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Report this content",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),

              _reportTile(context, "Factually wrong information"),
              _reportTile(context, "Hurt sentiments"),
              _reportTile(context, "Foul language"),
              _reportTile(context, "I didn’t like this"),

              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _reportTile(BuildContext context, String title) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        widget.activityManager.setReported(true);
          widget.readStats.hasreported = true;
          widget.readStats.reportscount +=1;
      },
    );
  }
}
