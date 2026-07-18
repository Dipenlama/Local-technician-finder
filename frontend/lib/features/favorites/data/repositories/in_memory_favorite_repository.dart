import 'package:mistrix/features/favorites/domain/repositories/favorite_repository.dart';
import 'package:mistrix/features/technicians/domain/entities/technician.dart';

class InMemoryFavoriteRepository implements FavoriteRepository {
  final List<Technician> _favorites = [];

  @override
  Future<List<Technician>> getFavorites() async =>
      List.unmodifiable(_favorites);

  @override
  Future<void> addFavorite(Technician technician) async {
    if (_favorites.every((item) => item.id != technician.id)) {
      _favorites.add(technician);
    }
  }

  @override
  Future<void> removeFavorite(String technicianId) async {
    _favorites.removeWhere((item) => item.id == technicianId);
  }
}
