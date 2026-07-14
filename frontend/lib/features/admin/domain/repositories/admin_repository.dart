import 'package:mistrix/features/admin/domain/entities/admin_client.dart';
import 'package:mistrix/features/admin/domain/entities/admin_service.dart';
import 'package:mistrix/features/technicians/domain/entities/technician.dart';

abstract interface class AdminRepository {
  Future<List<AdminService>> getServices();
  Future<void> saveService(AdminService service);
  Future<void> deleteService(String id);

  Future<List<Technician>> getTechnicians();
  Future<void> saveTechnician(Technician technician);
  Future<void> deleteTechnician(String id);

  Future<List<AdminClient>> getClients();
  Future<void> saveClient(AdminClient client);
  Future<void> deleteClient(String id);
}
