import 'package:mistrix_backend/src/core/database/mongo_database.dart';
import 'package:mistrix_backend/src/features/notifications/domain/entities/user_notification.dart';
import 'package:mistrix_backend/src/features/notifications/domain/repositories/notification_repository.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoNotificationRepository implements NotificationRepository {
  const MongoNotificationRepository(this._database);

  final MongoDatabase _database;

  @override
  Future<UserNotification> create(UserNotification notification) async {
    await _database.notifications.insertOne(_toDocument(notification));
    return notification;
  }

  @override
  Future<List<UserNotification>> findByUserId(String userId) async {
    final documents =
        await _database.notifications.find(where.eq('userId', userId)).toList();
    final items = documents.map(_fromDocument).toList();
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items;
  }

  @override
  Future<UserNotification?> findById(String id) async {
    final document = await _database.notifications.findOne(where.eq('_id', id));
    return document == null ? null : _fromDocument(document);
  }

  @override
  Future<void> markRead(String userId, String id) async {
    await _database.notifications.updateOne(
      where.eq('_id', id).eq('userId', userId),
      modify.set('isRead', true),
    );
  }

  @override
  Future<void> markAllRead(String userId) async {
    await _database.notifications.updateMany(
      where.eq('userId', userId),
      modify.set('isRead', true),
    );
  }

  UserNotification _fromDocument(Map<String, dynamic> document) =>
      UserNotification(
        id: document['_id'] as String,
        userId: document['userId'] as String,
        title: document['title'] as String,
        message: document['message'] as String,
        type: document['type'] as String,
        bookingId: document['bookingId'] as String? ?? '',
        isRead: document['isRead'] as bool? ?? false,
        createdAt: (document['createdAt'] as DateTime).toUtc(),
      );

  Map<String, dynamic> _toDocument(UserNotification notification) => {
    '_id': notification.id,
    'userId': notification.userId,
    'title': notification.title,
    'message': notification.message,
    'type': notification.type,
    'bookingId': notification.bookingId,
    'isRead': notification.isRead,
    'createdAt': notification.createdAt,
  };
}
