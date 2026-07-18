import 'package:mistrix/features/admin/data/repositories/admin_repository_impl.dart';
import 'package:mistrix/features/admin/data/repositories/remote_admin_repository.dart';
import 'package:mistrix/features/admin/domain/repositories/admin_repository.dart';
import 'package:mistrix/features/bookings/data/repositories/in_memory_booking_repository.dart';
import 'package:mistrix/features/bookings/data/repositories/remote_booking_repository.dart';
import 'package:mistrix/features/auth/data/auth_api_service.dart';
import 'package:mistrix/core/network/api_client.dart';
import 'package:mistrix/features/bookings/domain/use_cases/create_booking.dart';
import 'package:mistrix/features/bookings/domain/use_cases/get_bookings.dart';
import 'package:mistrix/features/bookings/domain/use_cases/update_booking.dart';
import 'package:mistrix/features/technicians/data/data_sources/technician_local_data_source.dart';
import 'package:mistrix/features/technicians/data/repositories/technician_repository_impl.dart';
import 'package:mistrix/features/technicians/data/repositories/remote_technician_repository.dart';
import 'package:mistrix/features/technicians/domain/repositories/technician_repository.dart';
import 'package:mistrix/features/bookings/domain/repositories/booking_repository.dart';
import 'package:mistrix/features/technicians/domain/use_cases/get_technicians.dart';

class AppDependencies {
  const AppDependencies({
    required this.getTechnicians,
    required this.createBooking,
    required this.getBookings,
    required this.updateBooking,
    required this.adminRepository,
    this.authApiService,
  });

  final GetTechnicians getTechnicians;
  final CreateBooking createBooking;
  final GetBookings getBookings;
  final UpdateBooking updateBooking;
  final AdminRepository adminRepository;
  final AuthApiService? authApiService;
}

AppDependencies configureDependencies({bool useRemote = true}) {
  final dataSource = TechnicianLocalDataSourceImpl();
  final apiClient = ApiClient();
  final TechnicianRepository repository = useRemote
      ? RemoteTechnicianRepository(apiClient)
      : TechnicianRepositoryImpl(dataSource);
  final getTechnicians = GetTechnicians(repository);
  final BookingRepository bookingRepository = useRemote
      ? RemoteBookingRepository(apiClient)
      : InMemoryBookingRepository();
  final createBooking = CreateBooking(bookingRepository);
  final getBookings = GetBookings(bookingRepository);
  final updateBooking = UpdateBooking(bookingRepository);

  return AppDependencies(
    getTechnicians: getTechnicians,
    createBooking: createBooking,
    getBookings: getBookings,
    updateBooking: updateBooking,
    adminRepository: useRemote
        ? RemoteAdminRepository(apiClient)
        : AdminRepositoryImpl(dataSource),
    authApiService: useRemote ? AuthApiService(apiClient) : null,
  );
}
