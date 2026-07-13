import 'package:bcrypt/bcrypt.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mistrix_backend/src/core/errors/api_exception.dart';
import 'package:mistrix_backend/src/core/utils/id_generator.dart';
import 'package:mistrix_backend/src/features/auth/domain/entities/user.dart';
import 'package:mistrix_backend/src/features/auth/domain/repositories/user_repository.dart';
import 'package:shelf/shelf.dart';

class AuthService {
  const AuthService({
    required UserRepository userRepository,
    required IdGenerator idGenerator,
    required String jwtSecret,
  }) : _userRepository = userRepository,
       _idGenerator = idGenerator,
       _jwtSecret = jwtSecret;

  final UserRepository _userRepository;
  final IdGenerator _idGenerator;
  final String _jwtSecret;

  Future<AuthResult> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    _validateSignup(name, normalizedEmail, phone, password);

    if (await _userRepository.findByEmail(normalizedEmail) != null) {
      throw const ApiException(
        409,
        'An account with this email already exists.',
      );
    }

    final user = User(
      id: _idGenerator('usr'),
      name: name.trim(),
      email: normalizedEmail,
      phone: phone.trim(),
      passwordHash: BCrypt.hashpw(password, BCrypt.gensalt()),
      createdAt: DateTime.now().toUtc(),
    );
    await _userRepository.create(user);
    return AuthResult(user: user, token: _createToken(user));
  }

  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    final user = await _userRepository.findByEmail(email);
    if (user == null || !BCrypt.checkpw(password, user.passwordHash)) {
      throw const ApiException(401, 'Invalid email or password.');
    }
    return AuthResult(user: user, token: _createToken(user));
  }

  Future<User> userFromRequest(Request request) async {
    final authorization = request.headers['authorization'];
    if (authorization == null || !authorization.startsWith('Bearer ')) {
      throw const ApiException(401, 'A bearer token is required.');
    }

    try {
      final token = authorization.substring(7).trim();
      final jwt = JWT.verify(
        token,
        SecretKey(_jwtSecret),
        issuer: 'mistrix-api',
      );
      final userId = jwt.subject;
      if (userId == null) {
        throw const ApiException(401, 'Invalid access token.');
      }
      final user = await _userRepository.findById(userId);
      if (user == null) throw const ApiException(401, 'User no longer exists.');
      return user;
    } on ApiException {
      rethrow;
    } on JWTException {
      throw const ApiException(401, 'Invalid or expired access token.');
    }
  }

  String _createToken(User user) {
    final jwt = JWT(
      {'email': user.email, 'name': user.name},
      subject: user.id,
      issuer: 'mistrix-api',
    );
    return jwt.sign(SecretKey(_jwtSecret), expiresIn: const Duration(days: 7));
  }

  void _validateSignup(
    String name,
    String email,
    String phone,
    String password,
  ) {
    final errors = <String, String>{};
    if (name.trim().length < 3) {
      errors['name'] = 'Name must contain at least 3 characters.';
    }
    if (!email.contains('@')) {
      errors['email'] = 'Enter a valid email address.';
    }
    if (phone.trim().length < 8) {
      errors['phone'] = 'Enter a valid phone number.';
    }
    if (password.length < 8) {
      errors['password'] = 'Password must contain at least 8 characters.';
    }
    if (errors.isNotEmpty) {
      throw ApiException(422, 'Validation failed.', details: errors);
    }
  }
}

class AuthResult {
  const AuthResult({required this.user, required this.token});

  final User user;
  final String token;

  Map<String, Object> toJson() => {'user': user.toPublicJson(), 'token': token};
}
