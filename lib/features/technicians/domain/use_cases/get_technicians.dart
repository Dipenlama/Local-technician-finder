import 'package:mistrix/features/technicians/domain/entities/technician.dart';
import 'package:mistrix/features/technicians/domain/repositories/technician_repository.dart';

class GetTechnicians {
  const GetTechnicians(this._repository);

  final TechnicianRepository _repository;

  Future<List<Technician>> call({String query = ''}) {
    return _repository.getTechnicians(query: query);
  }
}
