import 'package:mistrix/features/notifications/domain/entities/app_notification.dart';
import 'package:mistrix/features/notifications/domain/repositories/notification_repository.dart';

class InMemoryNotificationRepository implements NotificationRepository {
  final List<AppNotification> _items = [];

  @override
  Future<List<AppNotification>> getNotifications() async =>
      List.unmodifiable(_items);

  @override
  Future<void> markRead(String id) async {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) _items[index] = _items[index].copyWith(isRead: true);
  }

  @override
  Future<void> markAllRead() async {
    for (var index = 0; index < _items.length; index++) {
      _items[index] = _items[index].copyWith(isRead: true);
    }
  }
}
