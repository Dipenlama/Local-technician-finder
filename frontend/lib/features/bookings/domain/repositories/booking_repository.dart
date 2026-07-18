import 'package:mistrix/features/bookings/domain/entities/booking.dart';

abstract interface class BookingRepository {
  Future<List<Booking>> getBookings();
  Future<Booking> createBooking(Booking booking);
  Future<Booking> rescheduleBooking(String id, DateTime scheduledAt);
  Future<Booking> cancelBooking(String id);
}
