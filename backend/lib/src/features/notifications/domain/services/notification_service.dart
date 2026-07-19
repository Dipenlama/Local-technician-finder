import 'package:mistrix_backend/src/core/utils/id_generator.dart';
import 'package:mistrix_backend/src/features/notifications/domain/entities/user_notification.dart';
import 'package:mistrix_backend/src/features/notifications/domain/repositories/notification_repository.dart';

class NotificationService {
  const NotificationService({
    required this.repository,
    required this.idGenerator,
  });

  final NotificationRepository repository;
  final IdGenerator idGenerator;

  Future<void> send({
    required String userId,
    required String title,
    required String message,
    required String type,
    required String bookingId,
  }) async {
    await repository.create(
      UserNotification(
        id: idGenerator('ntf'),
        userId: userId,
        title: title,
        message: message,
        type: type,
        bookingId: bookingId,
        isRead: false,
        createdAt: DateTime.now().toUtc(),
      ),
    );
  }
}
