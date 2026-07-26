import 'package:mistrix_backend/src/features/notifications/domain/entities/user_notification.dart';

abstract interface class NotificationRepository {
  Future<UserNotification> create(UserNotification notification);
  Future<List<UserNotification>> findByUserId(String userId);
  Future<UserNotification?> findById(String id);
  Future<void> markRead(String userId, String id);
  Future<void> markAllRead(String userId);
}
