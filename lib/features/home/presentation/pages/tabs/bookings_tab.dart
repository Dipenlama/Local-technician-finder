import 'package:flutter/material.dart';

class BookingsTab extends StatelessWidget {
  const BookingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My bookings',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 6),
            Text('Manage your upcoming and past services.',
                style: TextStyle(color: Colors.blueGrey.shade600)),
            const SizedBox(height: 24),
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 0, label: Text('Upcoming')),
                ButtonSegment(value: 1, label: Text('Completed')),
                ButtonSegment(value: 2, label: Text('Cancelled')),
              ],
              selected: const {0},
              onSelectionChanged: (_) {},
            ),
            const Spacer(),
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.calendar_month_outlined,
                      color: Theme.of(context).colorScheme.primary,
                      size: 58,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('No upcoming bookings',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  Text(
                    'Your booked services will appear here.',
                    style: TextStyle(color: Colors.blueGrey.shade600),
                  ),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
