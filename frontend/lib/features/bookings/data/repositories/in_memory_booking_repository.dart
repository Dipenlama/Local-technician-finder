import 'package:mistrix/features/bookings/domain/entities/booking.dart';
import 'package:mistrix/features/bookings/domain/repositories/booking_repository.dart';

class InMemoryBookingRepository implements BookingRepository {
  final List<Booking> _bookings = [];

  @override
  Future<Booking> createBooking(Booking booking) async {
    _bookings.insert(0, booking);
    return booking;
  }

  @override
  Future<List<Booking>> getBookings() async {
    return List.unmodifiable(_bookings);
  }

  @override
  Future<Booking> rescheduleBooking(String id, DateTime scheduledAt) async {
    return _update(id, (booking) => booking.copyWith(scheduledAt: scheduledAt));
  }

  @override
  Future<Booking> cancelBooking(String id) async {
    return _update(
      id,
      (booking) => booking.copyWith(status: BookingStatus.cancelled),
    );
  }

  Booking _update(String id, Booking Function(Booking) change) {
    final index = _bookings.indexWhere((booking) => booking.id == id);
    if (index == -1) throw StateError('Booking not found.');
    final updated = change(_bookings[index]);
    _bookings[index] = updated;
    return updated;
  }
}
