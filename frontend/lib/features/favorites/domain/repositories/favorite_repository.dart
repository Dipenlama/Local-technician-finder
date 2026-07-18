import 'package:mistrix/features/technicians/domain/entities/technician.dart';

abstract interface class FavoriteRepository {
  Future<List<Technician>> getFavorites();
  Future<void> addFavorite(Technician technician);
  Future<void> removeFavorite(String technicianId);
}
