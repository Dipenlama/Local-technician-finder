import 'package:mistrix_backend/src/core/errors/api_exception.dart';
import 'package:mistrix_backend/src/core/http/api_response.dart';
import 'package:mistrix_backend/src/features/auth/domain/services/auth_service.dart';
import 'package:mistrix_backend/src/features/notifications/domain/repositories/notification_repository.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class NotificationHandler {
  const NotificationHandler({
    required this.authService,
    required this.repository,
  });

  final AuthService authService;
  final NotificationRepository repository;

  Router get router {
    final router = Router();
    router.get('/', _findMine);
    router.put('/read-all', _markAllRead);
    router.put('/<id>/read', _markRead);
    return router;
  }

  Future<Response> _findMine(Request request) async {
    final user = await authService.userFromRequest(request);
    final items = await repository.findByUserId(user.id);
    return successResponse({
      'items': items.map((item) => item.toJson()).toList(growable: false),
      'unreadCount': items.where((item) => !item.isRead).length,
    });
  }

  Future<Response> _markRead(Request request, String id) async {
    final user = await authService.userFromRequest(request);
    final notification = await repository.findById(id);
    if (notification == null || notification.userId != user.id) {
      throw const ApiException(404, 'Notification not found.');
    }
    await repository.markRead(user.id, id);
    return successResponse({'id': id, 'isRead': true});
  }

  Future<Response> _markAllRead(Request request) async {
    final user = await authService.userFromRequest(request);
    await repository.markAllRead(user.id);
    return successResponse({'isRead': true});
  }
}
