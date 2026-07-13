import 'package:mistrix/features/technicians/data/data_sources/technician_local_data_source.dart';
import 'package:mistrix/features/technicians/domain/entities/technician.dart';
import 'package:mistrix/features/technicians/domain/repositories/technician_repository.dart';

class TechnicianRepositoryImpl implements TechnicianRepository {
  const TechnicianRepositoryImpl(this._localDataSource);

  final TechnicianLocalDataSource _localDataSource;

  @override
  Future<List<Technician>> getTechnicians({String query = ''}) async {
    final technicians = await _localDataSource.getTechnicians();
    final normalizedQuery = query.trim().toLowerCase();

    if (normalizedQuery.isEmpty) return technicians;

    return technicians.where((technician) {
      return technician.name.toLowerCase().contains(normalizedQuery) ||
          technician.profession.toLowerCase().contains(normalizedQuery) ||
          technician.location.toLowerCase().contains(normalizedQuery);
    }).toList(growable: false);
  }
}
