import 'package:mistrix_backend/src/core/config/app_config.dart';
import 'package:mistrix_backend/src/core/database/mongo_database.dart';
import 'package:mistrix_backend/src/core/http/api_response.dart';
import 'package:mistrix_backend/src/core/http/middleware.dart';
import 'package:mistrix_backend/src/core/utils/id_generator.dart';
import 'package:mistrix_backend/src/features/auth/data/repositories/in_memory_user_repository.dart';
import 'package:mistrix_backend/src/features/auth/domain/repositories/user_repository.dart';
import 'package:mistrix_backend/src/features/auth/domain/services/auth_service.dart';
import 'package:mistrix_backend/src/features/auth/presentation/auth_handler.dart';
import 'package:mistrix_backend/src/features/admin/presentation/admin_handler.dart';
import 'package:mistrix_backend/src/features/technicians/data/repositories/mongo_technician_repository.dart';
import 'package:mistrix_backend/src/features/bookings/data/repositories/in_memory_booking_repository.dart';
import 'package:mistrix_backend/src/features/bookings/domain/repositories/booking_repository.dart';
import 'package:mistrix_backend/src/features/bookings/presentation/booking_handler.dart';
import 'package:mistrix_backend/src/features/notifications/data/repositories/in_memory_notification_repository.dart';
import 'package:mistrix_backend/src/features/notifications/domain/repositories/notification_repository.dart';
import 'package:mistrix_backend/src/features/notifications/domain/services/notification_service.dart';
import 'package:mistrix_backend/src/features/notifications/presentation/notification_handler.dart';
import 'package:mistrix_backend/src/features/favorites/data/repositories/in_memory_favorite_repository.dart';
import 'package:mistrix_backend/src/features/favorites/domain/repositories/favorite_repository.dart';
import 'package:mistrix_backend/src/features/favorites/presentation/favorite_handler.dart';
import 'package:mistrix_backend/src/features/technicians/data/repositories/in_memory_technician_repository.dart';
import 'package:mistrix_backend/src/features/technicians/domain/repositories/technician_repository.dart';
import 'package:mistrix_backend/src/features/technicians/presentation/technician_handler.dart';
import 'package:mistrix_backend/src/features/services/presentation/service_handler.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class MistrixBackend {
  MistrixBackend({
    required this.config,
    UserRepository? userRepository,
    TechnicianRepository? technicianRepository,
    BookingRepository? bookingRepository,
    NotificationRepository? notificationRepository,
    FavoriteRepository? favoriteRepository,
    MongoDatabase? database,
  }) {
    final idGenerator = IdGenerator();
    final resolvedUsers = userRepository ?? InMemoryUserRepository();
    final resolvedTechnicians =
        technicianRepository ?? const InMemoryTechnicianRepository();
    final resolvedBookings = bookingRepository ?? InMemoryBookingRepository();
    final resolvedNotifications =
        notificationRepository ?? InMemoryNotificationRepository();
    final resolvedFavorites =
        favoriteRepository ?? InMemoryFavoriteRepository();
    final authService = AuthService(
      userRepository: resolvedUsers,
      idGenerator: idGenerator,
      jwtSecret: config.jwtSecret,
    );
    final notificationService = NotificationService(
      repository: resolvedNotifications,
      idGenerator: idGenerator,
    );

    _authHandler = AuthHandler(authService);
    _technicianHandler = TechnicianHandler(resolvedTechnicians);
    _bookingHandler = BookingHandler(
      authService: authService,
      bookingRepository: resolvedBookings,
      technicianRepository: resolvedTechnicians,
      idGenerator: idGenerator,
      notificationService: notificationService,
    );
    _notificationHandler = NotificationHandler(
      authService: authService,
      repository: resolvedNotifications,
    );
    _favoriteHandler = FavoriteHandler(
      authService: authService,
      repository: resolvedFavorites,
      technicians: resolvedTechnicians,
    );
    if (database != null && resolvedTechnicians is MongoTechnicianRepository) {
      _serviceHandler = ServiceHandler(database);
      _adminHandler = AdminHandler(
        database: database,
        authService: authService,
        technicians: resolvedTechnicians,
        notificationService: notificationService,
      );
    }
  }

  final AppConfig config;
  late final AuthHandler _authHandler;
  late final TechnicianHandler _technicianHandler;
  late final BookingHandler _bookingHandler;
  late final NotificationHandler _notificationHandler;
  late final FavoriteHandler _favoriteHandler;
  AdminHandler? _adminHandler;
  ServiceHandler? _serviceHandler;

  Handler get handler {
    final router = Router();
    router.get('/health', (Request request) {
      return successResponse({
        'service': 'mistrix-backend',
        'status': 'healthy',
        'timestamp': DateTime.now().toUtc().toIso8601String(),
      });
    });
    router.mount('/api/v1/auth/', _authHandler.router.call);
    router.mount('/api/v1/technicians/', _technicianHandler.router.call);
    router.mount('/api/v1/bookings/', _bookingHandler.router.call);
    router.mount('/api/v1/notifications/', _notificationHandler.router.call);
    router.mount('/api/v1/favorites/', _favoriteHandler.router.call);
    if (_serviceHandler != null) {
      router.mount('/api/v1/services/', _serviceHandler!.router.call);
    }
    if (_adminHandler != null) {
      router.mount('/api/v1/admin/', _adminHandler!.router.call);
    }

    return Pipeline()
        .addMiddleware(errorMiddleware())
        .addMiddleware(corsMiddleware(config.allowedOrigin))
        .addMiddleware(logRequests())
        .addHandler(router.call);
  }
}
