import 'package:mistrix/core/network/api_client.dart';

class AuthApiService {
  const AuthApiService(this._client);

  final ApiClient _client;

  Future<AuthSession> login(String email, String password) async {
    final data = await _client.post('/auth/login', {
      'email': email,
      'password': password,
    }) as Map<String, dynamic>;
    return _saveSession(data);
  }

  Future<AuthSession> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final data = await _client.post('/auth/signup', {
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
    }) as Map<String, dynamic>;
    return _saveSession(data);
  }

  AuthSession _saveSession(Map<String, dynamic> data) {
    _client.token = data['token'] as String;
    final user = data['user'] as Map<String, dynamic>;
    return AuthSession(
      id: user['id'] as String,
      name: user['name'] as String,
      email: user['email'] as String,
      role: user['role'] as String? ?? 'client',
    );
  }
}

class AuthSession {
  const AuthSession({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  final String id;
  final String name;
  final String email;
  final String role;
}
