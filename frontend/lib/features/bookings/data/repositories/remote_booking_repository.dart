import 'package:mistrix/core/network/api_client.dart';
import 'package:mistrix/features/bookings/domain/entities/booking.dart';
import 'package:mistrix/features/bookings/domain/repositories/booking_repository.dart';

class RemoteBookingRepository implements BookingRepository {
  const RemoteBookingRepository(this._client);

  final ApiClient _client;

  @override
  Future<Booking> createBooking(Booking booking) async {
    final data = await _client.post('/bookings/', {
      'technicianId': booking.technicianId,
      'service': booking.service,
      'address': booking.address,
      'scheduledAt': booking.scheduledAt.toUtc().toIso8601String(),
      'notes': booking.notes,
    }) as Map<String, dynamic>;
    return _fromJson(data, fallback: booking);
  }

  @override
  Future<List<Booking>> getBookings() async {
    final data = await _client.get('/bookings/') as Map<String, dynamic>;
    final items = data['items'] as List<dynamic>;
    return items
        .cast<Map<String, dynamic>>()
        .map(_fromJson)
        .toList(growable: false);
  }

  @override
  Future<Booking> rescheduleBooking(String id, DateTime scheduledAt) async {
    final data = await _client.put('/bookings/$id', {
      'scheduledAt': scheduledAt.toUtc().toIso8601String(),
    }) as Map<String, dynamic>;
    return _fromJson(data);
  }

  @override
  Future<Booking> cancelBooking(String id) async {
    final data = await _client.put('/bookings/$id', {
      'status': BookingStatus.cancelled.name,
    }) as Map<String, dynamic>;
    return _fromJson(data);
  }

  Booking _fromJson(Map<String, dynamic> json, {Booking? fallback}) => Booking(
        id: json['id'] as String,
        technicianId: json['technicianId'] as String,
        technicianName:
            json['technicianName'] as String? ?? fallback?.technicianName ?? '',
        service: json['service'] as String,
        location: json['location'] as String? ?? fallback?.location ?? '',
        address: json['address'] as String,
        scheduledAt: DateTime.parse(json['scheduledAt'] as String).toLocal(),
        notes: json['notes'] as String? ?? '',
        status: BookingStatus.values.byName(json['status'] as String),
        createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
        technicianImageUrl: json['technicianImageUrl'] as String? ??
            fallback?.technicianImageUrl ??
            '',
      );
}
