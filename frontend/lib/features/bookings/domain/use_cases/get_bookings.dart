import 'package:mistrix/features/bookings/domain/entities/booking.dart';
import 'package:mistrix/features/bookings/domain/repositories/booking_repository.dart';

class GetBookings {
  const GetBookings(this._repository);

  final BookingRepository _repository;

  Future<List<Booking>> call() => _repository.getBookings();
}
