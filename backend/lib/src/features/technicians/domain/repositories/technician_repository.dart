import 'package:mistrix_backend/src/features/technicians/domain/entities/technician.dart';

abstract interface class TechnicianRepository {
  Future<List<Technician>> findAll({
    String query = '',
    String profession = '',
    bool? available,
  });

  Future<Technician?> findById(String id);
}
