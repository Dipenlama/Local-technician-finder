import 'dart:io';

import 'package:mistrix_backend/src/app.dart';
import 'package:mistrix_backend/src/core/config/app_config.dart';
import 'package:mistrix_backend/src/core/database/database_seeder.dart';
import 'package:mistrix_backend/src/core/database/mongo_database.dart';
import 'package:mistrix_backend/src/features/auth/data/repositories/mongo_user_repository.dart';
import 'package:mistrix_backend/src/features/bookings/data/repositories/mongo_booking_repository.dart';
import 'package:mistrix_backend/src/features/notifications/data/repositories/mongo_notification_repository.dart';
import 'package:mistrix_backend/src/features/favorites/data/repositories/mongo_favorite_repository.dart';
import 'package:mistrix_backend/src/features/technicians/data/repositories/mongo_technician_repository.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

Future<void> main() async {
  final config = AppConfig.fromEnvironment();
  final database = await MongoDatabase.connect(config.mongodbUri);
  final users = MongoUserRepository(database);
  final technicians = MongoTechnicianRepository(database);
  final bookings = MongoBookingRepository(database);
  final notifications = MongoNotificationRepository(database);
  final favorites = MongoFavoriteRepository(database);
  await DatabaseSeeder(
    database: database,
    users: users,
    technicians: technicians,
  ).seed();
  final app = MistrixBackend(
    config: config,
    userRepository: users,
    technicianRepository: technicians,
    bookingRepository: bookings,
    database: database,
    notificationRepository: notifications,
    favoriteRepository: favorites,
  );
  final server = await shelf_io.serve(app.handler, config.host, config.port);

  stdout.writeln(
    'Mistrix API running on http://${server.address.host}:${server.port}',
  );
}
