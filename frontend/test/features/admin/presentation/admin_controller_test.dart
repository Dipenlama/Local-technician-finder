import 'package:flutter_test/flutter_test.dart';
import 'package:mistrix/features/admin/data/repositories/admin_repository_impl.dart';
import 'package:mistrix/features/admin/domain/entities/admin_service.dart';
import 'package:mistrix/features/admin/presentation/controllers/admin_controller.dart';
import 'package:mistrix/features/technicians/data/data_sources/technician_local_data_source.dart';
import 'package:mistrix/features/technicians/domain/entities/technician.dart';

void main() {
  test('admin can add and delete services and technicians', () async {
    final dataSource = TechnicianLocalDataSourceImpl();
    final controller = AdminController(AdminRepositoryImpl(dataSource));
    addTearDown(controller.dispose);
    await controller.load();

    const service = AdminService(
      id: 'service-test',
      name: 'Painter',
      description: 'Home painting',
      basePrice: 1500,
      isActive: true,
    );
    await controller.saveService(service);
    expect(controller.services.any((item) => item.id == service.id), isTrue);

    const technician = Technician(
      id: 'tech-admin-test',
      name: 'Admin Added',
      profession: 'Painter',
      location: 'Kathmandu',
      rating: 5,
      reviewCount: 0,
      isAvailable: true,
    );
    await controller.saveTechnician(technician);
    expect(
        controller.technicians.any((item) => item.id == technician.id), isTrue);
    expect(
      (await dataSource.getTechnicians())
          .any((item) => item.id == technician.id),
      isTrue,
    );

    await controller.deleteService(service.id);
    await controller.deleteTechnician(technician.id);
    expect(controller.services.any((item) => item.id == service.id), isFalse);
    expect(controller.technicians.any((item) => item.id == technician.id),
        isFalse);
  });
}
