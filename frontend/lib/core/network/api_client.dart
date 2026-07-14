import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mistrix/core/errors/app_exception.dart';
import 'package:mistrix/core/network/api_config.dart';

class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  String? token;

  Future<dynamic> get(String path) => _send('GET', path);
  Future<dynamic> post(String path, Map<String, dynamic> body) =>
      _send('POST', path, body: body);
  Future<dynamic> put(String path, Map<String, dynamic> body) =>
      _send('PUT', path, body: body);
  Future<dynamic> delete(String path) => _send('DELETE', path);

  Future<dynamic> _send(
    String method,
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');
    final request = http.Request(method, uri)
      ..headers['content-type'] = 'application/json'
      ..headers['accept'] = 'application/json';
    if (token != null) request.headers['authorization'] = 'Bearer $token';
    if (body != null) request.body = jsonEncode(body);

    try {
      final streamed = await _client.send(request);
      final response = await http.Response.fromStream(streamed);
      final decoded = response.body.isEmpty ? null : jsonDecode(response.body);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        final message = decoded is Map<String, dynamic>
            ? ((decoded['error'] as Map<String, dynamic>?)?['message']
                    as String? ??
                'Request failed.')
            : 'Request failed.';
        throw AppException(message);
      }
      return decoded is Map<String, dynamic> ? decoded['data'] : decoded;
    } on AppException {
      rethrow;
    } on Object {
      throw const AppException(
        'Cannot connect to the Mistrix server. Check that the backend is running.',
      );
    }
  }
}
