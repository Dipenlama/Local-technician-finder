import 'package:flutter/material.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.onEditPersonalInformation,
    required this.onLogout,
    super.key,
  });

  final String userName;
  final String userEmail;
  final String userPhone;
  final VoidCallback onEditPersonalInformation;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Text('Profile',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 34,
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    child: Text(
                      _initials(userName),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 27,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(userName,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 3),
                        Text(userEmail,
                            style: const TextStyle(color: Colors.blueGrey)),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: onEditPersonalInformation,
                    icon: const Icon(Icons.edit_outlined),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Card(
            child: Column(
              children: [
                _ProfileTile(
                    icon: Icons.person_outline,
                    title: 'Personal information',
                    onTap: onEditPersonalInformation),
                const Divider(height: 1, indent: 58),
                _ProfileTile(
                    icon: Icons.location_on_outlined,
                    title: 'Saved addresses',
                    onTap: () {}),
                const Divider(height: 1, indent: 58),
                _ProfileTile(
                    icon: Icons.payment_outlined,
                    title: 'Payment methods',
                    onTap: () {}),
                const Divider(height: 1, indent: 58),
                _ProfileTile(
                    icon: Icons.favorite_border_rounded,
                    title: 'Favourite technicians',
                    onTap: () {}),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Card(
            child: Column(
              children: [
                _ProfileTile(
                    icon: Icons.notifications_none_rounded,
                    title: 'Notifications',
                    onTap: () {}),
                const Divider(height: 1, indent: 58),
                _ProfileTile(
                    icon: Icons.help_outline_rounded,
                    title: 'Help and support',
                    onTap: () {}),
                const Divider(height: 1, indent: 58),
                _ProfileTile(
                    icon: Icons.info_outline_rounded,
                    title: 'About Mistrix',
                    onTap: () {}),
              ],
            ),
          ),
          const SizedBox(height: 18),
          OutlinedButton.icon(
            onPressed: onLogout,
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Sign out'),
            style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error),
          ),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return 'U';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile(
      {required this.icon, required this.title, required this.onTap});

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}
