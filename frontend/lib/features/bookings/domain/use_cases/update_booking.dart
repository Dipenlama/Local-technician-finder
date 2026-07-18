import 'package:mistrix/features/bookings/domain/entities/booking.dart';
import 'package:mistrix/features/bookings/domain/repositories/booking_repository.dart';

class UpdateBooking {
  const UpdateBooking(this._repository);

  final BookingRepository _repository;

  Future<Booking> reschedule(String id, DateTime scheduledAt) {
    return _repository.rescheduleBooking(id, scheduledAt);
  }

  Future<Booking> cancel(String id) {
    return _repository.cancelBooking(id);
  }
}
