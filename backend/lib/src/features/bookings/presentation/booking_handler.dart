import 'package:mistrix_backend/src/core/errors/api_exception.dart';
import 'package:mistrix_backend/src/core/http/api_response.dart';
import 'package:mistrix_backend/src/core/utils/id_generator.dart';
import 'package:mistrix_backend/src/features/auth/domain/services/auth_service.dart';
import 'package:mistrix_backend/src/features/bookings/domain/entities/booking.dart';
import 'package:mistrix_backend/src/features/bookings/domain/repositories/booking_repository.dart';
import 'package:mistrix_backend/src/features/notifications/domain/services/notification_service.dart';
import 'package:mistrix_backend/src/features/technicians/domain/repositories/technician_repository.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class BookingHandler {
  const BookingHandler({
    required AuthService authService,
    required BookingRepository bookingRepository,
    required TechnicianRepository technicianRepository,
    required IdGenerator idGenerator,
    required NotificationService notificationService,
  }) : _authService = authService,
       _bookingRepository = bookingRepository,
       _technicianRepository = technicianRepository,
       _idGenerator = idGenerator,
       _notificationService = notificationService;

  final AuthService _authService;
  final BookingRepository _bookingRepository;
  final TechnicianRepository _technicianRepository;
  final IdGenerator _idGenerator;
  final NotificationService _notificationService;

  Router get router {
    final router = Router();
    router.get('/', _findMine);
    router.post('/', _create);
    router.put('/<id>', _updateMine);
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
    await _notificationService.send(
      userId: user.id,
      title: 'Booking requested',
      message: 'Your booking with ${technician.name} has been submitted.',
      type: 'booking_created',
      bookingId: booking.id,
    );
    return successResponse(booking.toJson(), statusCode: 201);
  }

  Future<Response> _updateMine(Request request, String id) async {
    final user = await _authService.userFromRequest(request);
    final booking = await _bookingRepository.findById(id);
    if (booking == null || booking.customerId != user.id) {
      throw const ApiException(404, 'Booking not found.');
    }
    if (booking.status == BookingStatus.completed ||
        booking.status == BookingStatus.cancelled) {
      throw const ApiException(409, 'This booking can no longer be changed.');
    }

    final body = await readJsonObject(request);
    final statusValue = body['status'] as String?;
    if (statusValue != null && statusValue != BookingStatus.cancelled.name) {
      throw const ApiException(422, 'Clients can only cancel a booking.');
    }

    DateTime? scheduledAt;
    if (body['scheduledAt'] != null) {
      scheduledAt = DateTime.tryParse(body['scheduledAt'] as String);
      if (scheduledAt == null || !scheduledAt.isAfter(DateTime.now())) {
        throw const ApiException(422, 'Choose a future date and time.');
      }
    }
    if (statusValue == null && scheduledAt == null) {
      throw const ApiException(422, 'No booking changes were provided.');
    }

    final updated = booking.copyWith(
      scheduledAt: scheduledAt?.toUtc(),
      status: statusValue == null ? null : BookingStatus.cancelled,
    );
    await _bookingRepository.update(updated);
    if (statusValue == BookingStatus.cancelled.name) {
      await _notificationService.send(
        userId: user.id,
        title: 'Booking cancelled',
        message: 'Your booking with ${booking.technicianName} was cancelled.',
        type: 'booking_cancelled',
        bookingId: booking.id,
      );
    } else {
      await _notificationService.send(
        userId: user.id,
        title: 'Booking rescheduled',
        message:
            'Your booking with ${booking.technicianName} has a new schedule.',
        type: 'booking_rescheduled',
        bookingId: booking.id,
      );
    }
    return successResponse(updated.toJson());
  }
}
