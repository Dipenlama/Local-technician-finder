import 'package:mistrix_backend/src/features/bookings/domain/entities/booking.dart';
import 'package:mistrix_backend/src/features/bookings/domain/repositories/booking_repository.dart';

class InMemoryBookingRepository implements BookingRepository {
  final List<Booking> _bookings = [];

  @override
  Future<Booking> create(Booking booking) async {
    _bookings.add(booking);
    return booking;
  }

  @override
  Future<List<Booking>> findByCustomerId(String customerId) async {
    final bookings =
        _bookings.where((item) => item.customerId == customerId).toList();
    bookings.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return bookings;
  }

  @override
  Future<Booking?> findById(String id) async {
    for (final booking in _bookings) {
      if (booking.id == id) return booking;
    }
    return null;
  }

  @override
  Future<Booking> update(Booking booking) async {
    final index = _bookings.indexWhere((item) => item.id == booking.id);
    if (index == -1) throw StateError('Booking not found.');
    _bookings[index] = booking;
    return booking;
  }
}
