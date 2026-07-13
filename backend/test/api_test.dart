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
}
