import 'package:mistrix/features/admin/data/repositories/admin_repository_impl.dart';
import 'package:mistrix/features/admin/domain/repositories/admin_repository.dart';
import 'package:mistrix/features/bookings/data/repositories/in_memory_booking_repository.dart';
import 'package:mistrix/features/bookings/domain/use_cases/create_booking.dart';
import 'package:mistrix/features/bookings/domain/use_cases/get_bookings.dart';
import 'package:mistrix/features/technicians/data/data_sources/technician_local_data_source.dart';
import 'package:mistrix/features/technicians/data/repositories/technician_repository_impl.dart';
import 'package:mistrix/features/technicians/domain/use_cases/get_technicians.dart';

class AppDependencies {
  const AppDependencies({
    required this.getTechnicians,
    required this.createBooking,
    required this.getBookings,
    required this.adminRepository,
  });

  final GetTechnicians getTechnicians;
  final CreateBooking createBooking;
  final GetBookings getBookings;
  final AdminRepository adminRepository;
}

AppDependencies configureDependencies() {
  final dataSource = TechnicianLocalDataSourceImpl();
  final repository = TechnicianRepositoryImpl(dataSource);
  final getTechnicians = GetTechnicians(repository);
  final bookingRepository = InMemoryBookingRepository();
  final createBooking = CreateBooking(bookingRepository);
  final getBookings = GetBookings(bookingRepository);

  return AppDependencies(
    getTechnicians: getTechnicians,
    createBooking: createBooking,
    getBookings: getBookings,
    adminRepository: AdminRepositoryImpl(dataSource),
  );
}
