import 'package:mistrix_backend/src/features/favorites/domain/repositories/favorite_repository.dart';

class InMemoryFavoriteRepository implements FavoriteRepository {
  final Map<String, Set<String>> _favorites = {};

  @override
  Future<List<String>> findTechnicianIds(String userId) async =>
      List.unmodifiable(_favorites[userId] ?? const <String>{});

  @override
  Future<void> add(String userId, String technicianId) async {
    _favorites.putIfAbsent(userId, () => <String>{}).add(technicianId);
  }

  @override
  Future<void> remove(String userId, String technicianId) async {
    _favorites[userId]?.remove(technicianId);
  }
}
