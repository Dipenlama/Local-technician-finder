import 'package:flutter/material.dart';
import 'package:mistrix/core/theme/app_colors.dart';
import 'package:mistrix/features/home/presentation/pages/about_mistrix_page.dart';
import 'package:mistrix/features/home/presentation/pages/help_support_page.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.onEditPersonalInformation,
    required this.onFavoriteTechnicians,
    required this.onLogout,
    super.key,
  });

  final String userName;
  final String userEmail;
  final String userPhone;
  final VoidCallback onEditPersonalInformation;
  final VoidCallback onFavoriteTechnicians;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        children: [
          Text('Profile', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(19),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  blurRadius: 22,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 34,
                  backgroundColor: Colors.white.withValues(alpha: 0.18),
                  child: Text(
                    _initials(userName),
                    style: const TextStyle(
                      color: Colors.white,
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
                      Text(
                        userName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        userEmail,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onEditPersonalInformation,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.15),
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.edit_outlined, size: 20),
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          const _GroupLabel('Account and preferences'),
          const SizedBox(height: 10),
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
                    onTap: onFavoriteTechnicians),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const _GroupLabel('Support and information'),
          const SizedBox(height: 10),
          Card(
            child: Column(
              children: [
                _ProfileTile(
                    icon: Icons.help_outline_rounded,
                    title: 'Help and support',
                    onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (context) => const HelpSupportPage(),
                          ),
                        )),
                const Divider(height: 1, indent: 58),
                _ProfileTile(
                    icon: Icons.info_outline_rounded,
                    title: 'About Mistrix',
                    onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (context) => const AboutMistrixPage(),
                          ),
                        )),
              ],
            ),
          ),
          const SizedBox(height: 22),
          OutlinedButton.icon(
            onPressed: onLogout,
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Sign out'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.danger,
              backgroundColor: AppColors.surface,
            ),
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
      visualDensity: const VisualDensity(vertical: -2),
      leading: Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: AppColors.primarySoft,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.inkMuted,
      ),
      onTap: onTap,
    );
  }
}

class _GroupLabel extends StatelessWidget {
  const _GroupLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(
        color: AppColors.inkMuted,
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.8,
      ),
    );
  }
}
