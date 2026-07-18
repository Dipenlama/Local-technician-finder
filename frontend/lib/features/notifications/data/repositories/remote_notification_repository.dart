import 'package:mistrix/core/network/api_client.dart';
import 'package:mistrix/features/notifications/domain/entities/app_notification.dart';
import 'package:mistrix/features/notifications/domain/repositories/notification_repository.dart';

class RemoteNotificationRepository implements NotificationRepository {
  const RemoteNotificationRepository(this._client);

  final ApiClient _client;

  @override
  Future<List<AppNotification>> getNotifications() async {
    final data = await _client.get('/notifications/') as Map<String, dynamic>;
    return (data['items'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(
          (item) => AppNotification(
            id: item['id'] as String,
            title: item['title'] as String,
            message: item['message'] as String,
            type: item['type'] as String,
            bookingId: item['bookingId'] as String? ?? '',
            isRead: item['isRead'] as bool? ?? false,
            createdAt: DateTime.parse(item['createdAt'] as String).toLocal(),
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<void> markRead(String id) async {
    await _client.put('/notifications/$id/read', const {});
  }

  @override
  Future<void> markAllRead() async {
    await _client.put('/notifications/read-all', const {});
  }
}
