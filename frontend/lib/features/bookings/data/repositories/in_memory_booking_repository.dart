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
}
