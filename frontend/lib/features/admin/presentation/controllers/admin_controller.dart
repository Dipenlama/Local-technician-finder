import 'package:flutter/foundation.dart';
import 'package:mistrix/features/admin/domain/entities/admin_client.dart';
import 'package:mistrix/features/admin/domain/entities/admin_service.dart';
import 'package:mistrix/features/admin/domain/repositories/admin_repository.dart';
import 'package:mistrix/features/technicians/domain/entities/technician.dart';

class AdminController extends ChangeNotifier {
  AdminController(this._repository);

  final AdminRepository _repository;

  bool isLoading = false;
  List<AdminService> services = const [];
  List<Technician> technicians = const [];
  List<AdminClient> clients = const [];

  Future<void> load() async {
    isLoading = true;
    notifyListeners();
    services = await _repository.getServices();
    technicians = await _repository.getTechnicians();
    clients = await _repository.getClients();
    isLoading = false;
    notifyListeners();
  }

  Future<void> saveService(AdminService service) async {
    await _repository.saveService(service);
    services = await _repository.getServices();
    notifyListeners();
  }

  Future<void> deleteService(String id) async {
    await _repository.deleteService(id);
    services = await _repository.getServices();
    notifyListeners();
  }

  Future<void> saveTechnician(Technician technician) async {
    await _repository.saveTechnician(technician);
    technicians = await _repository.getTechnicians();
    notifyListeners();
  }

  Future<void> deleteTechnician(String id) async {
    await _repository.deleteTechnician(id);
    technicians = await _repository.getTechnicians();
    notifyListeners();
  }

  Future<void> saveClient(AdminClient client) async {
    await _repository.saveClient(client);
    clients = await _repository.getClients();
    notifyListeners();
  }

  Future<void> deleteClient(String id) async {
    await _repository.deleteClient(id);
    clients = await _repository.getClients();
    notifyListeners();
  }
}
