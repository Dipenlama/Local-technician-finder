import 'package:flutter/foundation.dart';
import 'package:mistrix/features/notifications/domain/entities/app_notification.dart';
import 'package:mistrix/features/notifications/domain/repositories/notification_repository.dart';

class NotificationController extends ChangeNotifier {
  NotificationController(this._repository);

  final NotificationRepository _repository;

  List<AppNotification> notifications = const [];
  bool isLoading = false;
  String? errorMessage;

  int get unreadCount =>
      notifications.where((notification) => !notification.isRead).length;

  Future<void> load() async {
    isLoading = true;
    notifyListeners();
    try {
      notifications = await _repository.getNotifications();
      errorMessage = null;
    } on Exception catch (error) {
      errorMessage = error.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markRead(String id) async {
    await _repository.markRead(id);
    notifications = notifications
        .map((item) => item.id == id ? item.copyWith(isRead: true) : item)
        .toList(growable: false);
    notifyListeners();
  }

  Future<void> markAllRead() async {
    await _repository.markAllRead();
    notifications = notifications
        .map((item) => item.copyWith(isRead: true))
        .toList(growable: false);
    notifyListeners();
  }
}
