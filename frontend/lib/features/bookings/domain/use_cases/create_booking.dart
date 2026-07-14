import 'package:mistrix/features/bookings/domain/entities/booking.dart';
import 'package:mistrix/features/bookings/domain/repositories/booking_repository.dart';
import 'package:mistrix/features/technicians/domain/entities/technician.dart';

class CreateBooking {
  const CreateBooking(this._repository);

  final BookingRepository _repository;

  Future<Booking> call({
    required Technician technician,
    required String address,
    required DateTime scheduledAt,
    String notes = '',
  }) {
    final now = DateTime.now();
    final booking = Booking(
      id: 'booking-${now.microsecondsSinceEpoch}',
      technicianId: technician.id,
      technicianName: technician.name,
      service: technician.profession,
      location: technician.location,
      address: address.trim(),
      scheduledAt: scheduledAt,
      notes: notes.trim(),
      status: BookingStatus.confirmed,
      createdAt: now,
    );
    return _repository.createBooking(booking);
  }
}
