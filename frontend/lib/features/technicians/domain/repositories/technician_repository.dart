import 'package:mistrix/features/technicians/domain/entities/technician.dart';

abstract interface class TechnicianRepository {
  Future<List<Technician>> getTechnicians({String query = ''});
}
