import 'package:mistrix_backend/src/features/notifications/domain/entities/user_notification.dart';
import 'package:mistrix_backend/src/features/notifications/domain/repositories/notification_repository.dart';

class InMemoryNotificationRepository implements NotificationRepository {
  final List<UserNotification> _notifications = [];

  @override
  Future<UserNotification> create(UserNotification notification) async {
    _notifications.insert(0, notification);
    return notification;
  }

  @override
  Future<List<UserNotification>> findByUserId(String userId) async {
    final items =
        _notifications.where((item) => item.userId == userId).toList();
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items;
  }

  @override
  Future<UserNotification?> findById(String id) async {
    for (final notification in _notifications) {
      if (notification.id == id) return notification;
    }
    return null;
  }

  @override
  Future<void> markRead(String userId, String id) async {
    final index = _notifications.indexWhere(
      (item) => item.id == id && item.userId == userId,
    );
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
    }
  }

  @override
  Future<void> markAllRead(String userId) async {
    for (var index = 0; index < _notifications.length; index++) {
      if (_notifications[index].userId == userId) {
        _notifications[index] = _notifications[index].copyWith(isRead: true);
      }
    }
  }
}
