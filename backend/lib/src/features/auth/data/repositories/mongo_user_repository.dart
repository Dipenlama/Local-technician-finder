import 'package:mistrix_backend/src/core/database/mongo_database.dart';
import 'package:mistrix_backend/src/features/auth/domain/entities/user.dart';
import 'package:mistrix_backend/src/features/auth/domain/repositories/user_repository.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoUserRepository implements UserRepository {
  const MongoUserRepository(this._database);

  final MongoDatabase _database;

  @override
  Future<User> create(User user) async {
    await _database.users.insertOne(_toDocument(user));
    return user;
  }

  @override
  Future<User?> findByEmail(String email) async {
    final document = await _database.users.findOne(
      where.eq('email', email.trim().toLowerCase()),
    );
    return document == null ? null : _fromDocument(document);
  }

  @override
  Future<User?> findById(String id) async {
    final document = await _database.users.findOne(where.eq('_id', id));
    return document == null ? null : _fromDocument(document);
  }

  @override
  Future<User> update(User user) async {
    await _database.users.replaceOne(
      where.eq('_id', user.id),
      _toDocument(user),
    );
    return user;
  }

  User _fromDocument(Map<String, dynamic> document) {
    return User(
      id: document['_id'] as String,
      name: document['name'] as String,
      email: document['email'] as String,
      phone: document['phone'] as String,
      passwordHash: document['passwordHash'] as String,
      createdAt: (document['createdAt'] as DateTime).toUtc(),
      role: document['role'] as String? ?? 'client',
    );
  }

  Map<String, dynamic> _toDocument(User user) => {
    '_id': user.id,
    'name': user.name,
    'email': user.email,
    'phone': user.phone,
    'passwordHash': user.passwordHash,
    'createdAt': user.createdAt,
    'role': user.role,
  };
}
