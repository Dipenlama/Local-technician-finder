import 'package:mistrix_backend/src/features/auth/domain/entities/user.dart';
import 'package:mistrix_backend/src/features/auth/domain/repositories/user_repository.dart';

class InMemoryUserRepository implements UserRepository {
  final Map<String, User> _users = {};

  @override
  Future<User> create(User user) async {
    _users[user.id] = user;
    return user;
  }

  @override
  Future<User?> findByEmail(String email) async {
    final normalizedEmail = email.trim().toLowerCase();
    for (final user in _users.values) {
      if (user.email == normalizedEmail) return user;
    }
    return null;
  }

  @override
  Future<User?> findById(String id) async => _users[id];
}
