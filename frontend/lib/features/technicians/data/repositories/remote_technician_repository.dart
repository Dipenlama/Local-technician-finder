import 'package:mistrix/core/network/api_client.dart';
import 'package:mistrix/features/technicians/domain/entities/technician.dart';
import 'package:mistrix/features/technicians/domain/repositories/technician_repository.dart';

class RemoteTechnicianRepository implements TechnicianRepository {
  const RemoteTechnicianRepository(this._client);

  final ApiClient _client;

  @override
  Future<List<Technician>> getTechnicians({String query = ''}) async {
    final encoded = Uri.encodeQueryComponent(query);
    final data = await _client.get('/technicians/?query=$encoded')
        as Map<String, dynamic>;
    final items = data['items'] as List<dynamic>;
    return items
        .cast<Map<String, dynamic>>()
        .map(
          (item) => Technician(
            id: item['id'] as String,
            name: item['name'] as String,
            profession: item['profession'] as String,
            location: item['location'] as String,
            rating: (item['rating'] as num).toDouble(),
            reviewCount: item['reviewCount'] as int,
            isAvailable: item['isAvailable'] as bool,
          ),
        )
        .toList(growable: false);
  }
}
