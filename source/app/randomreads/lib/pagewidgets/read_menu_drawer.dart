import 'package:flutter/material.dart';

class ReadMenuDrawer extends StatelessWidget {
  final String username;
  final VoidCallback onToggleTheme;
  final VoidCallback onSubmitRead;
  final VoidCallback onUserActivity;
  final VoidCallback onLogout;

  const ReadMenuDrawer({
    super.key,
    required this.username,
    required this.onToggleTheme,
    required this.onSubmitRead,
    required this.onUserActivity,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(username: username),
            const Divider(),

            _MenuItem(
              icon: Icons.brightness_6_outlined,
              title: 'Dark / Light mode',
              onTap: onToggleTheme,
            ),
            _MenuItem(
              icon: Icons.edit_outlined,
              title: 'Submit a read story line',
              onTap: onSubmitRead,
            ),
            _MenuItem(
              icon: Icons.bar_chart_outlined,
              title: 'User Activity',
              onTap: onUserActivity,
            ),

            const Spacer(),
            const Divider(),

            _MenuItem(
              icon: Icons.logout_outlined,
              title: 'Logout',
              onTap: onLogout,
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }
}


class _Header extends StatelessWidget {
  final String username;

  const _Header({required this.username});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            username,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            'No email',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive
        ? Colors.grey
        : Theme.of(context).iconTheme.color;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      onTap: onTap,
    );
  }
}
