import 'package:mistrix/core/network/api_client.dart';
import 'package:mistrix/features/favorites/domain/repositories/favorite_repository.dart';
import 'package:mistrix/features/technicians/domain/entities/technician.dart';

class RemoteFavoriteRepository implements FavoriteRepository {
  const RemoteFavoriteRepository(this._client);

  final ApiClient _client;

  @override
  Future<List<Technician>> getFavorites() async {
    final data = await _client.get('/favorites/') as Map<String, dynamic>;
    return (data['items'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(_fromJson)
        .toList(growable: false);
  }

  @override
  Future<void> addFavorite(Technician technician) async {
    await _client.put('/favorites/${technician.id}', const {});
  }

  @override
  Future<void> removeFavorite(String technicianId) async {
    await _client.delete('/favorites/$technicianId');
  }

  Technician _fromJson(Map<String, dynamic> item) => Technician(
        id: item['id'] as String,
        name: item['name'] as String,
        profession: item['profession'] as String,
        location: item['location'] as String,
        rating: (item['rating'] as num).toDouble(),
        reviewCount: item['reviewCount'] as int,
        isAvailable: item['isAvailable'] as bool,
        imageUrl: item['imageUrl'] as String? ?? '',
      );
}
