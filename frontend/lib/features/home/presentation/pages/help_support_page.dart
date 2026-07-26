import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mistrix/core/constants/app_constants.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help and support')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF3157D5), Color(0xFF5679EA)],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white24,
                    child: Icon(
                      Icons.support_agent_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'How can we help?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Find quick answers or contact our support team.',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 26),
            Text(
              'Frequently asked questions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 12),
            const Card(
              child: Column(
                children: [
                  _QuestionTile(
                    question: 'How do I reschedule a booking?',
                    answer:
                        'Open Bookings, select an upcoming booking, and choose Reschedule from its menu. Pick a new future date and time, then confirm the change.',
                  ),
                  Divider(height: 1, indent: 18, endIndent: 18),
                  _QuestionTile(
                    question: 'Can I cancel my booking?',
                    answer:
                        'Yes. Pending and confirmed bookings can be cancelled from the Bookings page. Once cancelled, the booking appears in your Cancelled section.',
                  ),
                  Divider(height: 1, indent: 18, endIndent: 18),
                  _QuestionTile(
                    question: 'How are technicians selected?',
                    answer:
                        'Mistrix lists local professionals with service details, availability, ratings, and customer review counts to help you make an informed choice.',
                  ),
                  Divider(height: 1, indent: 18, endIndent: 18),
                  _QuestionTile(
                    question: 'What if a technician does not arrive?',
                    answer:
                        'Contact Mistrix support with your booking details. Our team will review the issue and help you arrange the next appropriate step.',
                  ),
                  Divider(height: 1, indent: 18, endIndent: 18),
                  _QuestionTile(
                    question: 'Is the displayed price final?',
                    answer:
                        'Displayed prices are starting estimates. The technician should explain any additional parts or work and confirm the final amount before proceeding.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 26),
            Text(
              'Contact support',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Our support team is available Sunday–Friday, 8:00 AM–8:00 PM NPT.',
              style: TextStyle(color: Colors.blueGrey),
            ),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: [
                  _ContactTile(
                    icon: Icons.email_outlined,
                    title: 'Email us',
                    value: AppConstants.supportEmail,
                    onTap: () => _copy(
                      context,
                      AppConstants.supportEmail,
                      'Support email copied.',
                    ),
                  ),
                  const Divider(height: 1, indent: 64),
                  _ContactTile(
                    icon: Icons.phone_outlined,
                    title: 'Call support',
                    value: '+977 01-5970123',
                    onTap: () => _copy(
                      context,
                      '+977 01-5970123',
                      'Support number copied.',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'For faster assistance, include your booking ID and a short description of the issue.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.blueGrey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> _copy(
    BuildContext context,
    String value,
    String message,
  ) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _QuestionTile extends StatelessWidget {
  const _QuestionTile({required this.question, required this.answer});

  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 3),
      childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
      title: Text(
        question,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(answer, style: const TextStyle(height: 1.45)),
        ),
      ],
    );
  }
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: Icon(icon, color: Theme.of(context).colorScheme.primary),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(value),
      trailing: const Icon(Icons.copy_rounded, size: 20),
    );
  }
}
