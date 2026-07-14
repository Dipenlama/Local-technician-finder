import 'package:bcrypt/bcrypt.dart';
import 'package:mistrix_backend/src/core/database/mongo_database.dart';
import 'package:mistrix_backend/src/features/auth/data/repositories/mongo_user_repository.dart';
import 'package:mistrix_backend/src/features/auth/domain/entities/user.dart';
import 'package:mistrix_backend/src/features/technicians/data/repositories/in_memory_technician_repository.dart';
import 'package:mistrix_backend/src/features/technicians/data/repositories/mongo_technician_repository.dart';

class DatabaseSeeder {
  const DatabaseSeeder({
    required this.database,
    required this.users,
    required this.technicians,
  });

  final MongoDatabase database;
  final MongoUserRepository users;
  final MongoTechnicianRepository technicians;

  Future<void> seed() async {
    if (await users.findByEmail('admin@mistrix.app') == null) {
      await users.create(
        User(
          id: 'usr-admin',
          name: 'Mistrix Administrator',
          email: 'admin@mistrix.app',
          phone: '9800000000',
          passwordHash: BCrypt.hashpw('Admin123', BCrypt.gensalt()),
          createdAt: DateTime.now().toUtc(),
          role: 'admin',
        ),
      );
    }

    if (await database.technicians.findOne() == null) {
      const source = InMemoryTechnicianRepository();
      for (final technician in await source.findAll()) {
        await technicians.save(technician);
      }
    }

    if (await database.services.findOne() == null) {
      await database.services.insertMany([
        _service('service-001', 'Electrician', 850),
        _service('service-002', 'Plumber', 750),
        _service('service-003', 'AC Repair', 1000),
        _service('service-004', 'Computer Repair', 1200),
        _service('service-005', 'Carpenter', 900),
      ]);
    }
  }

  Map<String, dynamic> _service(String id, String name, double price) => {
    '_id': id,
    'name': name,
    'description': '$name services from verified local professionals',
    'basePrice': price,
    'isActive': true,
  };
}
