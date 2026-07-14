import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mistrix/core/network/api_client.dart';
import 'package:mistrix/features/bookings/data/repositories/remote_booking_repository.dart';
import 'package:mistrix/features/bookings/domain/entities/booking.dart';

void main() {
  test('maps a pending booking response returned by the backend', () async {
    final client = ApiClient(
      client: MockClient((request) async {
        return http.Response(
          jsonEncode({
            'success': true,
            'data': {
              'id': 'bkg-001',
              'technicianId': 'tech-001',
              'technicianName': 'Aarav Sharma',
              'service': 'Electrician',
              'location': 'Kathmandu',
              'address': 'Thamel, Kathmandu',
              'scheduledAt': '2026-08-01T04:15:00.000Z',
              'status': 'pending',
              'notes': '',
              'createdAt': '2026-07-14T04:15:00.000Z',
            },
          }),
          201,
          headers: {'content-type': 'application/json'},
        );
      }),
    )..token = 'test-token';
    final repository = RemoteBookingRepository(client);

    final result = await repository.createBooking(
      Booking(
        id: 'local',
        technicianId: 'tech-001',
        technicianName: 'Aarav Sharma',
        service: 'Electrician',
        location: 'Kathmandu',
        address: 'Thamel, Kathmandu',
        scheduledAt: DateTime(2026, 8),
        notes: '',
        status: BookingStatus.confirmed,
        createdAt: DateTime(2026, 7, 14),
      ),
    );

    expect(result.status, BookingStatus.pending);
    expect(result.technicianName, 'Aarav Sharma');
  });
}
