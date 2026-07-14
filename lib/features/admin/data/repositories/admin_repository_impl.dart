import 'package:mistrix/features/admin/domain/entities/admin_client.dart';
import 'package:mistrix/features/admin/domain/entities/admin_service.dart';
import 'package:mistrix/features/admin/domain/repositories/admin_repository.dart';
import 'package:mistrix/features/technicians/data/data_sources/technician_local_data_source.dart';
import 'package:mistrix/features/technicians/data/models/technician_model.dart';
import 'package:mistrix/features/technicians/domain/entities/technician.dart';

class AdminRepositoryImpl implements AdminRepository {
  AdminRepositoryImpl(this._technicianDataSource)
      : _services = List.of(_seedServices),
        _clients = List.of(_seedClients);

  final TechnicianLocalDataSourceImpl _technicianDataSource;
  final List<AdminService> _services;
  final List<AdminClient> _clients;

  static const _seedServices = [
    AdminService(
      id: 'service-001',
      name: 'Electrician',
      description: 'Wiring, lighting, and electrical repairs',
      basePrice: 850,
      isActive: true,
    ),
    AdminService(
      id: 'service-002',
      name: 'Plumber',
      description: 'Pipe, tap, drainage, and water repairs',
      basePrice: 750,
      isActive: true,
    ),
    AdminService(
      id: 'service-003',
      name: 'AC Repair',
      description: 'Air conditioner servicing and repair',
      basePrice: 1000,
      isActive: true,
    ),
    AdminService(
      id: 'service-004',
      name: 'Computer Repair',
      description: 'Computer diagnosis, upgrades, and repair',
      basePrice: 1200,
      isActive: true,
    ),
    AdminService(
      id: 'service-005',
      name: 'Carpenter',
      description: 'Furniture assembly and woodwork',
      basePrice: 900,
      isActive: true,
    ),
  ];

  static final _seedClients = [
    AdminClient(
      id: 'client-001',
      name: 'Dipen',
      email: 'dipen@example.com',
      phone: '9800000001',
      isActive: true,
      joinedAt: DateTime(2026, 5, 14),
    ),
    AdminClient(
      id: 'client-002',
      name: 'Aayush KC',
      email: 'aayush@example.com',
      phone: '9800000002',
      isActive: true,
      joinedAt: DateTime(2026, 6, 2),
    ),
    AdminClient(
      id: 'client-003',
      name: 'Sneha Rai',
      email: 'sneha@example.com',
      phone: '9800000003',
      isActive: false,
      joinedAt: DateTime(2026, 6, 18),
    ),
  ];

  @override
  Future<List<AdminService>> getServices() async =>
      List.unmodifiable(_services);

  @override
  Future<void> saveService(AdminService service) async {
    final index = _services.indexWhere((item) => item.id == service.id);
    if (index == -1) {
      _services.add(service);
    } else {
      _services[index] = service;
    }
  }

  @override
  Future<void> deleteService(String id) async {
    _services.removeWhere((item) => item.id == id);
  }

  @override
  Future<List<Technician>> getTechnicians() =>
      _technicianDataSource.getTechnicians();

  @override
  Future<void> saveTechnician(Technician technician) async {
    final model = TechnicianModel(
      id: technician.id,
      name: technician.name,
      profession: technician.profession,
      location: technician.location,
      rating: technician.rating,
      reviewCount: technician.reviewCount,
      isAvailable: technician.isAvailable,
    );
    final existing = await _technicianDataSource.getTechnicians();
    if (existing.any((item) => item.id == technician.id)) {
      await _technicianDataSource.updateTechnician(model);
    } else {
      await _technicianDataSource.addTechnician(model);
    }
  }

  @override
  Future<void> deleteTechnician(String id) =>
      _technicianDataSource.deleteTechnician(id);

  @override
  Future<List<AdminClient>> getClients() async => List.unmodifiable(_clients);

  @override
  Future<void> saveClient(AdminClient client) async {
    final index = _clients.indexWhere((item) => item.id == client.id);
    if (index == -1) {
      _clients.add(client);
    } else {
      _clients[index] = client;
    }
  }

  @override
  Future<void> deleteClient(String id) async {
    _clients.removeWhere((item) => item.id == id);
  }
}
