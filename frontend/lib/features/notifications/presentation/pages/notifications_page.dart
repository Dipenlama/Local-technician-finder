import 'package:flutter/material.dart';
import 'package:mistrix/features/notifications/domain/entities/app_notification.dart';
import 'package:mistrix/features/notifications/presentation/controllers/notification_controller.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({required this.controller, super.key});

  final NotificationController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          ListenableBuilder(
            listenable: controller,
            builder: (context, _) => controller.unreadCount == 0
                ? const SizedBox.shrink()
                : TextButton(
                    onPressed: controller.markAllRead,
                    child: const Text('Mark all read'),
                  ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            if (controller.isLoading && controller.notifications.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.errorMessage != null &&
                controller.notifications.isEmpty) {
              return Center(
                child: FilledButton.icon(
                  onPressed: controller.load,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Try again'),
                ),
              );
            }
            if (controller.notifications.isEmpty) {
              return const _EmptyNotifications();
            }
            return RefreshIndicator(
              onRefresh: controller.load,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
                itemCount: controller.notifications.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final notification = controller.notifications[index];
                  return _NotificationCard(
                    notification: notification,
                    onTap: notification.isRead
                        ? null
                        : () => controller.markRead(notification.id),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.notification, required this.onTap});

  final AppNotification notification;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = _colorFor(notification.type);
    return Card(
      color: notification.isRead
          ? null
          : Theme.of(context).colorScheme.primaryContainer.withValues(
                alpha: 0.45,
              ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(14),
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.14),
          child: Icon(_iconFor(notification.type), color: color),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                notification.title,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
            if (!notification.isRead)
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(notification.message),
              const SizedBox(height: 7),
              Text(
                _formatTime(notification.createdAt),
                style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconFor(String type) => switch (type) {
        'booking_completed' => Icons.task_alt_rounded,
        'booking_cancelled' => Icons.event_busy_rounded,
        'booking_rescheduled' => Icons.update_rounded,
        'booking_confirmed' => Icons.event_available_rounded,
        _ => Icons.home_repair_service_rounded,
      };

  Color _colorFor(String type) => switch (type) {
        'booking_completed' => Colors.green,
        'booking_cancelled' => Colors.red,
        'booking_rescheduled' => Colors.orange,
        'booking_confirmed' => Colors.blue,
        _ => const Color(0xFF3157D5),
      };

  String _formatTime(DateTime value) {
    final difference = DateTime.now().difference(value);
    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inHours < 1) return '${difference.inMinutes} min ago';
    if (difference.inDays < 1) return '${difference.inHours} hr ago';
    if (difference.inDays < 7) return '${difference.inDays} days ago';
    return '${value.year}-${value.month.toString().padLeft(2, '0')}-'
        '${value.day.toString().padLeft(2, '0')}';
  }
}

class _EmptyNotifications extends StatelessWidget {
  const _EmptyNotifications();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.notifications_none_rounded, size: 68),
          SizedBox(height: 16),
          Text('No notifications yet', style: TextStyle(fontSize: 18)),
          SizedBox(height: 6),
          Text('Booking updates will appear here.'),
        ],
      ),
    );
  }
}
