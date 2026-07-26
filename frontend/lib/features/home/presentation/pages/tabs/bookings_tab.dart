import 'package:flutter/material.dart';
import 'package:mistrix/core/theme/app_colors.dart';
import 'package:mistrix/features/bookings/domain/entities/booking.dart';
import 'package:mistrix/features/bookings/presentation/controllers/booking_controller.dart';
import 'package:mistrix/features/technicians/presentation/widgets/technician_avatar.dart';

class BookingsTab extends StatefulWidget {
  const BookingsTab({
    required this.controller,
    this.onNotificationsChanged,
    super.key,
  });

  final BookingController controller;
  final VoidCallback? onNotificationsChanged;

  @override
  State<BookingsTab> createState() => _BookingsTabState();
}

class _BookingsTabState extends State<BookingsTab> {
  BookingStatus _selectedStatus = BookingStatus.confirmed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text(
                'YOUR SERVICE JOURNEY',
                style: TextStyle(
                  color: AppColors.primaryDark,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text('My bookings',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 6),
            const Text(
              'Manage your upcoming and past services.',
              style: TextStyle(color: AppColors.inkMuted),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.outline),
              ),
              child: SizedBox(
                width: double.infinity,
                child: SegmentedButton<BookingStatus>(
                  segments: const [
                    ButtonSegment(
                      value: BookingStatus.confirmed,
                      label: Text('Upcoming'),
                    ),
                    ButtonSegment(
                      value: BookingStatus.completed,
                      label: Text('Completed'),
                    ),
                    ButtonSegment(
                      value: BookingStatus.cancelled,
                      label: Text('Cancelled'),
                    ),
                  ],
                  selected: {_selectedStatus},
                  onSelectionChanged: (selection) {
                    setState(() => _selectedStatus = selection.first);
                  },
                ),
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: ListenableBuilder(
                listenable: widget.controller,
                builder: (context, _) => _buildContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (widget.controller.status == BookingLoadStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (widget.controller.status == BookingLoadStatus.failure) {
      return Center(
        child: FilledButton(
          onPressed: widget.controller.load,
          child: const Text('Try again'),
        ),
      );
    }

    final bookings = widget.controller.bookings
        .where((booking) => _selectedStatus == BookingStatus.confirmed
            ? booking.status == BookingStatus.pending ||
                booking.status == BookingStatus.confirmed
            : booking.status == _selectedStatus)
        .toList(growable: false);
    if (bookings.isEmpty) return _EmptyBookings(status: _selectedStatus);

    return RefreshIndicator(
      onRefresh: widget.controller.load,
      child: ListView.separated(
        padding: const EdgeInsets.only(bottom: 24),
        itemCount: bookings.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return _BookingCard(
            booking: booking,
            isUpdating: widget.controller.updatingBookingId == booking.id,
            onAction: (action) => _handleAction(booking, action),
          );
        },
      ),
    );
  }

  Future<void> _handleAction(Booking booking, String action) async {
    if (action == 'reschedule') {
      final scheduledAt = await _pickSchedule(booking.scheduledAt);
      if (scheduledAt == null) return;
      final successful = await widget.controller.reschedule(
        booking,
        scheduledAt,
      );
      if (!mounted) return;
      _showResult(
        successful,
        successMessage: 'Booking rescheduled successfully.',
      );
      if (successful) widget.onNotificationsChanged?.call();
      return;
    }

    final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            icon: const Icon(Icons.cancel_outlined, color: Colors.red),
            title: const Text('Cancel booking?'),
            content: Text(
              'Your booking with ${booking.technicianName} will be cancelled.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Keep booking'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: FilledButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Cancel booking'),
              ),
            ],
          ),
        ) ??
        false;
    if (!confirmed) return;

    final successful = await widget.controller.cancel(booking);
    if (!mounted) return;
    if (successful) {
      setState(() => _selectedStatus = BookingStatus.cancelled);
      widget.onNotificationsChanged?.call();
    }
    _showResult(successful, successMessage: 'Booking cancelled.');
  }

  Future<DateTime?> _pickSchedule(DateTime current) async {
    final now = DateTime.now();
    final initial =
        current.isAfter(now) ? current : now.add(const Duration(days: 1));
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return null;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (time == null || !mounted) return null;
    final scheduledAt = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    if (!scheduledAt.isAfter(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choose a future date and time.')),
      );
      return null;
    }
    return scheduledAt;
  }

  void _showResult(bool successful, {required String successMessage}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          successful
              ? successMessage
              : widget.controller.errorMessage ?? 'Could not update booking.',
        ),
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  const _BookingCard({
    required this.booking,
    required this.isUpdating,
    required this.onAction,
  });

  final Booking booking;
  final bool isUpdating;
  final ValueChanged<String> onAction;

  @override
  Widget build(BuildContext context) {
    final displayName = booking.technicianName.trim().isEmpty
        ? 'Technician'
        : booking.technicianName;
    final statusColor = switch (booking.status) {
      BookingStatus.pending => Colors.orange,
      BookingStatus.confirmed => Colors.green,
      BookingStatus.completed => Colors.blue,
      BookingStatus.cancelled => Colors.red,
    };
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                TechnicianAvatar(
                  name: displayName,
                  imageUrl: booking.technicianImageUrl,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        booking.service,
                        style: const TextStyle(
                          color: AppColors.inkMuted,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        booking.status.name,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    if (booking.status == BookingStatus.pending ||
                        booking.status == BookingStatus.confirmed)
                      isUpdating
                          ? const Padding(
                              padding: EdgeInsets.only(top: 10, right: 8),
                              child: SizedBox.square(
                                dimension: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          : PopupMenuButton<String>(
                              tooltip: 'Manage booking',
                              onSelected: onAction,
                              itemBuilder: (context) => const [
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
              ],
            ),
            const Divider(height: 30),
            _BookingDetail(
              icon: Icons.calendar_today_outlined,
              text: _formatSchedule(context, booking.scheduledAt),
            ),
            const SizedBox(height: 9),
            _BookingDetail(
              icon: Icons.location_on_outlined,
              text: booking.address,
            ),
            if (booking.notes.isNotEmpty) ...[
              const SizedBox(height: 9),
              _BookingDetail(
                icon: Icons.notes_rounded,
                text: booking.notes,
              ),
            ],
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
    final time = TimeOfDay.fromDateTime(date).format(context);
    return '${months[date.month - 1]} ${date.day}, ${date.year} at $time';
  }
}

class _BookingDetail extends StatelessWidget {
  const _BookingDetail({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: AppColors.primarySoft,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 17, color: AppColors.primary),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: AppColors.inkMuted, height: 1.35),
          ),
        ),
      ],
    );
  }
}

class _EmptyBookings extends StatelessWidget {
  const _EmptyBookings({required this.status});

  final BookingStatus status;

  @override
  Widget build(BuildContext context) {
    final title = switch (status) {
      BookingStatus.pending => 'No pending bookings',
      BookingStatus.confirmed => 'No upcoming bookings',
      BookingStatus.completed => 'No completed bookings',
      BookingStatus.cancelled => 'No cancelled bookings',
    };
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: const BoxDecoration(
              color: AppColors.primarySoft,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.calendar_month_outlined,
              color: AppColors.primary,
              size: 58,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your booked services will appear here.',
            style: TextStyle(color: AppColors.inkMuted),
          ),
        ],
      ),
    );
  }
}
