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
  });

  final GetTechnicians getTechnicians;
  final CreateBooking createBooking;
  final GetBookings getBookings;
}

AppDependencies configureDependencies() {
  const dataSource = TechnicianLocalDataSourceImpl();
  const repository = TechnicianRepositoryImpl(dataSource);
  const getTechnicians = GetTechnicians(repository);
  final bookingRepository = InMemoryBookingRepository();
  final createBooking = CreateBooking(bookingRepository);
  final getBookings = GetBookings(bookingRepository);

  return AppDependencies(
    getTechnicians: getTechnicians,
    createBooking: createBooking,
    getBookings: getBookings,
  );
}
