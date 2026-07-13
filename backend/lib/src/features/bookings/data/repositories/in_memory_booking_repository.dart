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
}
