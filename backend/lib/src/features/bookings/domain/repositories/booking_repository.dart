import 'package:mistrix_backend/src/features/bookings/domain/entities/booking.dart';

abstract interface class BookingRepository {
  Future<Booking> create(Booking booking);
  Future<Booking?> findById(String id);
  Future<List<Booking>> findByCustomerId(String customerId);
  Future<Booking> update(Booking booking);
}
