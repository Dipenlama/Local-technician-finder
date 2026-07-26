import 'package:mistrix_backend/src/core/database/mongo_database.dart';
import 'package:mistrix_backend/src/features/favorites/domain/repositories/favorite_repository.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoFavoriteRepository implements FavoriteRepository {
  const MongoFavoriteRepository(this._database);

  final MongoDatabase _database;

  @override
  Future<List<String>> findTechnicianIds(String userId) async {
    final documents =
        await _database.favorites.find(where.eq('userId', userId)).toList();
    return documents
        .map((document) => document['technicianId'] as String)
        .toList(growable: false);
  }

  @override
  Future<void> add(String userId, String technicianId) async {
    final id = '${userId}_$technicianId';
    await _database.favorites.replaceOne(where.eq('_id', id), {
      '_id': id,
      'userId': userId,
      'technicianId': technicianId,
      'createdAt': DateTime.now().toUtc(),
    }, upsert: true);
  }

  @override
  Future<void> remove(String userId, String technicianId) async {
    await _database.favorites.deleteOne(
      where.eq('userId', userId).eq('technicianId', technicianId),
    );
  }
}
