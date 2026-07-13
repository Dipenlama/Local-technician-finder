import 'package:mistrix_backend/src/features/auth/domain/entities/user.dart';

abstract interface class UserRepository {
  Future<User?> findByEmail(String email);
  Future<User?> findById(String id);
  Future<User> create(User user);
}
