import 'package:flutter/material.dart';
import 'package:mistrix/core/widgets/mistrix_logo.dart';

class AboutMistrixPage extends StatelessWidget {
  const AboutMistrixPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Mistrix')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 30),
          children: [
            const Center(child: MistrixLogo()),
            const SizedBox(height: 12),
            const Text(
              'Trusted local help, when you need it.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 28),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Our mission',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Mistrix connects customers with dependable technicians in their local area. We make it easier to discover professionals, compare services, schedule appointments, and follow every booking from one simple application.',
                      style: TextStyle(height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Why choose Mistrix?',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 12),
            const _ValueCard(
              icon: Icons.verified_user_outlined,
              title: 'Trusted professionals',
              description:
                  'Review technician skills, availability, ratings, and service history before booking.',
            ),
            const SizedBox(height: 10),
            const _ValueCard(
              icon: Icons.event_available_outlined,
              title: 'Booking control',
              description:
                  'Schedule, reschedule, cancel, and track service appointments from one place.',
            ),
            const SizedBox(height: 10),
            const _ValueCard(
              icon: Icons.location_on_outlined,
              title: 'Built for local communities',
              description:
                  'Find nearby expertise while supporting skilled professionals in your community.',
            ),
            const SizedBox(height: 22),
            Card(
              child: Column(
                children: [
                  const ListTile(
                    leading: Icon(Icons.info_outline_rounded),
                    title: Text('App version'),
                    trailing: Text(
                      '1.0.0',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const Divider(height: 1, indent: 58),
                  ListTile(
                    leading: const Icon(Icons.description_outlined),
                    title: const Text('Terms of service'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => _showLegalText(
                      context,
                      title: 'Terms of service',
                      text:
                          'By using Mistrix, you agree to provide accurate account and booking information, communicate respectfully with service professionals, and use the platform only for lawful service requests. Service scope and final pricing should be confirmed before work begins.',
                    ),
                  ),
                  const Divider(height: 1, indent: 58),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip_outlined),
                    title: const Text('Privacy policy'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => _showLegalText(
                      context,
                      title: 'Privacy policy',
                      text:
                          'Mistrix uses account, contact, booking, and service-location information to provide and improve the application. Personal information is not sold. Access is limited to authorized services and people who need it to complete or support a booking.',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '© 2026 Mistrix. All rights reserved.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.blueGrey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  void _showLegalText(
    BuildContext context, {
    required String title,
    required String text,
  }) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 4, 22, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 12),
              Text(text, style: const TextStyle(height: 1.5)),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ValueCard extends StatelessWidget {
  const _ValueCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: const TextStyle(color: Colors.blueGrey, height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
