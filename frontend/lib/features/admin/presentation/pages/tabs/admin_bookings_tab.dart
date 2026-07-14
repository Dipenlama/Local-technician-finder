import 'package:flutter/material.dart';
import 'package:mistrix/features/admin/domain/entities/admin_booking.dart';
import 'package:mistrix/features/admin/presentation/controllers/admin_controller.dart';

class AdminBookingsTab extends StatelessWidget {
  const AdminBookingsTab({required this.controller, super.key});

  final AdminController controller;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListenableBuilder(
        listenable: controller,
        builder: (context, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bookings',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${controller.bookings.length} customer bookings',
                    style: const TextStyle(color: Colors.blueGrey),
                  ),
                ],
              ),
            ),
            Expanded(
              child: controller.bookings.isEmpty
                  ? const _EmptyBookings()
                  : RefreshIndicator(
                      onRefresh: controller.load,
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
                        itemCount: controller.bookings.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) => _AdminBookingCard(
                          booking: controller.bookings[index],
                          onAction: (action) => _handleAction(
                            context,
                            controller.bookings[index],
                            action,
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleAction(
    BuildContext context,
    AdminBooking booking,
    String action,
  ) async {
    if (action == 'reschedule') {
      final scheduledAt = await _pickSchedule(context, booking.scheduledAt);
      if (scheduledAt != null) {
        await controller.updateBooking(
          booking.copyWith(scheduledAt: scheduledAt),
        );
        if (context.mounted) _showMessage(context, 'Booking rescheduled.');
      }
      return;
    }

    final status = action == 'complete' ? 'completed' : 'cancelled';
    final approved = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            icon: Icon(
              status == 'completed'
                  ? Icons.check_circle_outline_rounded
                  : Icons.cancel_outlined,
              color: status == 'completed' ? Colors.green : Colors.red,
            ),
            title: Text(
              status == 'completed'
                  ? 'Mark booking as complete?'
                  : 'Cancel booking?',
            ),
            content: Text(
              '${booking.customerName} will see this booking as $status.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Back'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: status == 'cancelled'
                    ? FilledButton.styleFrom(backgroundColor: Colors.red)
                    : null,
                child: Text(
                  status == 'completed' ? 'Mark complete' : 'Cancel',
                ),
              ),
            ],
          ),
        ) ??
        false;
    if (!approved) return;

    await controller.updateBooking(booking.copyWith(status: status));
    if (context.mounted) {
      _showMessage(context, 'Booking marked as $status.');
    }
  }

  Future<DateTime?> _pickSchedule(
    BuildContext context,
    DateTime current,
  ) async {
    final now = DateTime.now();
    final initialDate =
        current.isAfter(now) ? current : now.add(const Duration(days: 1));
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date == null || !context.mounted) return null;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(current),
    );
    if (time == null) return null;
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _AdminBookingCard extends StatelessWidget {
  const _AdminBookingCard({required this.booking, required this.onAction});

  final AdminBooking booking;
  final ValueChanged<String> onAction;

  @override
  Widget build(BuildContext context) {
    final statusColor = switch (booking.status) {
      'confirmed' => Colors.green,
      'cancelled' => Colors.red,
      'completed' => Colors.blue,
      _ => Colors.orange,
    };
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  child: Text(
                    booking.customerName.isEmpty
                        ? 'C'
                        : booking.customerName[0].toUpperCase(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.customerName,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      Text(
                        booking.customerEmail,
                        style: const TextStyle(color: Colors.blueGrey),
                      ),
                    ],
                  ),
                ),
                if (booking.status != 'completed' &&
                    booking.status != 'cancelled')
                  PopupMenuButton<String>(
                    onSelected: onAction,
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: 'complete',
                        child: Text('Mark as complete'),
                      ),
                      PopupMenuItem(
                        value: 'reschedule',
                        child: Text('Reschedule'),
                      ),
                      PopupMenuItem(
                        value: 'cancel',
                        child: Text('Cancel booking'),
                      ),
                    ],
                  ),
              ],
            ),
            const Divider(height: 28),
            Text(
              booking.service,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 5),
            Text('Technician: ${booking.technicianName}'),
            const SizedBox(height: 8),
            _Detail(
              icon: Icons.calendar_today_outlined,
              text: _formatSchedule(context, booking.scheduledAt),
            ),
            const SizedBox(height: 7),
            _Detail(icon: Icons.location_on_outlined, text: booking.address),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                booking.status.toUpperCase(),
                style: TextStyle(
                  color: statusColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatSchedule(BuildContext context, DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year} at '
        '${TimeOfDay.fromDateTime(date).format(context)}';
  }
}

class _Detail extends StatelessWidget {
  const _Detail({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(child: Text(text)),
      ],
    );
  }
}

class _EmptyBookings extends StatelessWidget {
  const _EmptyBookings();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.event_busy_outlined, size: 64, color: Colors.blueGrey),
          SizedBox(height: 14),
          Text('No bookings found', style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
