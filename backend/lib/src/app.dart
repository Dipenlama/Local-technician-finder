import 'package:mistrix_backend/src/core/config/app_config.dart';
import 'package:mistrix_backend/src/core/http/api_response.dart';
import 'package:mistrix_backend/src/core/http/middleware.dart';
import 'package:mistrix_backend/src/core/utils/id_generator.dart';
import 'package:mistrix_backend/src/features/auth/data/repositories/in_memory_user_repository.dart';
import 'package:mistrix_backend/src/features/auth/domain/services/auth_service.dart';
import 'package:mistrix_backend/src/features/auth/presentation/auth_handler.dart';
import 'package:mistrix_backend/src/features/bookings/data/repositories/in_memory_booking_repository.dart';
import 'package:mistrix_backend/src/features/bookings/presentation/booking_handler.dart';
import 'package:mistrix_backend/src/features/technicians/data/repositories/in_memory_technician_repository.dart';
import 'package:mistrix_backend/src/features/technicians/presentation/technician_handler.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class MistrixBackend {
  MistrixBackend({required this.config}) {
    final idGenerator = IdGenerator();
    final userRepository = InMemoryUserRepository();
    const technicianRepository = InMemoryTechnicianRepository();
    final bookingRepository = InMemoryBookingRepository();
    final authService = AuthService(
      userRepository: userRepository,
      idGenerator: idGenerator,
      jwtSecret: config.jwtSecret,
    );

    _authHandler = AuthHandler(authService);
    _technicianHandler = const TechnicianHandler(technicianRepository);
    _bookingHandler = BookingHandler(
      authService: authService,
      bookingRepository: bookingRepository,
      technicianRepository: technicianRepository,
      idGenerator: idGenerator,
    );
  }

  final AppConfig config;
  late final AuthHandler _authHandler;
  late final TechnicianHandler _technicianHandler;
  late final BookingHandler _bookingHandler;

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

    return Pipeline()
        .addMiddleware(errorMiddleware())
        .addMiddleware(corsMiddleware(config.allowedOrigin))
        .addMiddleware(logRequests())
        .addHandler(router.call);
  }
}
