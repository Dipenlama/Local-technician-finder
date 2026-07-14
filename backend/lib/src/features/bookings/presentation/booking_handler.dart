import 'package:mistrix_backend/src/core/errors/api_exception.dart';
import 'package:mistrix_backend/src/core/http/api_response.dart';
import 'package:mistrix_backend/src/core/utils/id_generator.dart';
import 'package:mistrix_backend/src/features/auth/domain/services/auth_service.dart';
import 'package:mistrix_backend/src/features/bookings/domain/entities/booking.dart';
import 'package:mistrix_backend/src/features/bookings/domain/repositories/booking_repository.dart';
import 'package:mistrix_backend/src/features/technicians/domain/repositories/technician_repository.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class BookingHandler {
  const BookingHandler({
    required AuthService authService,
    required BookingRepository bookingRepository,
    required TechnicianRepository technicianRepository,
    required IdGenerator idGenerator,
  }) : _authService = authService,
       _bookingRepository = bookingRepository,
       _technicianRepository = technicianRepository,
       _idGenerator = idGenerator;

  final AuthService _authService;
  final BookingRepository _bookingRepository;
  final TechnicianRepository _technicianRepository;
  final IdGenerator _idGenerator;

  Router get router {
    final router = Router();
    router.get('/', _findMine);
    router.post('/', _create);
    return router;
  }

  Future<Response> _findMine(Request request) async {
    final user = await _authService.userFromRequest(request);
    final bookings = await _bookingRepository.findByCustomerId(user.id);
    final items = await Future.wait(
      bookings.map((booking) async {
        final technician = await _technicianRepository.findById(
          booking.technicianId,
        );
        return {
          ...booking.toJson(),
          'technicianImageUrl':
              technician?.imageUrl ?? booking.technicianImageUrl,
        };
      }),
    );
    return successResponse({'items': items, 'count': bookings.length});
  }

  Future<Response> _create(Request request) async {
    final user = await _authService.userFromRequest(request);
    final body = await readJsonObject(request);
    final technicianId = body['technicianId'] as String? ?? '';
    final service = body['service'] as String? ?? '';
    final address = body['address'] as String? ?? '';
    final scheduledAt = DateTime.tryParse(body['scheduledAt'] as String? ?? '');

    final errors = <String, String>{};
    final technician = await _technicianRepository.findById(technicianId);
    if (technician == null) {
      errors['technicianId'] = 'Technician does not exist.';
    }
    if (service.trim().isEmpty) errors['service'] = 'Service is required.';
    if (address.trim().isEmpty) errors['address'] = 'Address is required.';
    if (scheduledAt == null || scheduledAt.isBefore(DateTime.now())) {
      errors['scheduledAt'] = 'Choose a future date and time.';
    }
    if (errors.isNotEmpty) {
      throw ApiException(422, 'Validation failed.', details: errors);
    }

    final booking = Booking(
      id: _idGenerator('bkg'),
      customerId: user.id,
      technicianId: technicianId,
      service: service.trim(),
      address: address.trim(),
      scheduledAt: scheduledAt!.toUtc(),
      status: BookingStatus.pending,
      notes: (body['notes'] as String? ?? '').trim(),
      createdAt: DateTime.now().toUtc(),
      technicianName: technician!.name,
      location: technician.location,
      technicianImageUrl: technician.imageUrl,
    );
    await _bookingRepository.create(booking);
    return successResponse(booking.toJson(), statusCode: 201);
  }
}
