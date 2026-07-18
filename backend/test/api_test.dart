import 'dart:convert';

import 'package:mistrix_backend/src/app.dart';
import 'package:mistrix_backend/src/core/config/app_config.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  late Handler handler;

  setUp(() {
    handler =
        MistrixBackend(
          config: const AppConfig(
            host: 'localhost',
            port: 8080,
            jwtSecret: 'test-secret-with-enough-entropy',
            allowedOrigin: '*',
          ),
        ).handler;
  });

  test('health endpoint responds successfully', () async {
    final response = await handler(
      Request('GET', Uri.parse('http://localhost/health')),
    );
    expect(response.statusCode, 200);
    final body =
        jsonDecode(await response.readAsString()) as Map<String, dynamic>;
    expect(body['success'], isTrue);
  });

  test('technician endpoint supports search', () async {
    final response = await handler(
      Request(
        'GET',
        Uri.parse('http://localhost/api/v1/technicians/?query=plumber'),
      ),
    );
    expect(response.statusCode, 200);
    final body =
        jsonDecode(await response.readAsString()) as Map<String, dynamic>;
    final data = body['data'] as Map<String, dynamic>;
    expect(data['count'], 1);
  });

  test('signup returns a token and public user', () async {
    final response = await handler(
      Request(
        'POST',
        Uri.parse('http://localhost/api/v1/auth/signup'),
        headers: {'content-type': 'application/json'},
        body: jsonEncode({
          'name': 'Test User',
          'email': 'test@mistrix.app',
          'phone': '9800000000',
          'password': 'password123',
        }),
      ),
    );
    expect(response.statusCode, 201);
    final body =
        jsonDecode(await response.readAsString()) as Map<String, dynamic>;
    final data = body['data'] as Map<String, dynamic>;
    expect(data['token'], isNotEmpty);
  });

  test('client can reschedule and cancel their booking', () async {
    final signupResponse = await handler(
      Request(
        'POST',
        Uri.parse('http://localhost/api/v1/auth/signup'),
        headers: {'content-type': 'application/json'},
        body: jsonEncode({
          'name': 'Booking Client',
          'email': 'booking-client@mistrix.app',
          'phone': '9800000001',
          'password': 'password123',
        }),
      ),
    );
    final signupBody =
        jsonDecode(await signupResponse.readAsString()) as Map<String, dynamic>;
    final signupData = signupBody['data'] as Map<String, dynamic>;
    final headers = {
      'content-type': 'application/json',
      'authorization': 'Bearer ${signupData['token']}',
    };

    final createResponse = await handler(
      Request(
        'POST',
        Uri.parse('http://localhost/api/v1/bookings/'),
        headers: headers,
        body: jsonEncode({
          'technicianId': 'tech-001',
          'service': 'Electrician',
          'address': 'Kathmandu, Nepal',
          'scheduledAt':
              DateTime.now()
                  .add(const Duration(days: 2))
                  .toUtc()
                  .toIso8601String(),
        }),
      ),
    );
    expect(createResponse.statusCode, 201);
    final createBody =
        jsonDecode(await createResponse.readAsString()) as Map<String, dynamic>;
    final booking = createBody['data'] as Map<String, dynamic>;
    final bookingId = booking['id'] as String;

    final rescheduledAt = DateTime.now().add(const Duration(days: 4)).toUtc();
    final rescheduleResponse = await handler(
      Request(
        'PUT',
        Uri.parse('http://localhost/api/v1/bookings/$bookingId'),
        headers: headers,
        body: jsonEncode({'scheduledAt': rescheduledAt.toIso8601String()}),
      ),
    );
    expect(rescheduleResponse.statusCode, 200);

    final cancelResponse = await handler(
      Request(
        'PUT',
        Uri.parse('http://localhost/api/v1/bookings/$bookingId'),
        headers: headers,
        body: jsonEncode({'status': 'cancelled'}),
      ),
    );
    expect(cancelResponse.statusCode, 200);
    final cancelBody =
        jsonDecode(await cancelResponse.readAsString()) as Map<String, dynamic>;
    final cancelled = cancelBody['data'] as Map<String, dynamic>;
    expect(cancelled['status'], 'cancelled');
  });
}
