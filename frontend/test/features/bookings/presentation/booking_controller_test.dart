import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mistrix/features/bookings/data/repositories/in_memory_booking_repository.dart';
import 'package:mistrix/features/bookings/domain/entities/booking.dart';
import 'package:mistrix/features/bookings/domain/repositories/booking_repository.dart';
import 'package:mistrix/features/bookings/domain/use_cases/create_booking.dart';
import 'package:mistrix/features/bookings/domain/use_cases/get_bookings.dart';
import 'package:mistrix/features/bookings/domain/use_cases/update_booking.dart';
import 'package:mistrix/features/bookings/presentation/controllers/booking_controller.dart';
import 'package:mistrix/features/home/presentation/pages/tabs/bookings_tab.dart';
import 'package:mistrix/features/technicians/domain/entities/technician.dart';

void main() {
  testWidgets('confirmed booking appears in the bookings tab', (tester) async {
    final repository = InMemoryBookingRepository();
    final controller = BookingController(
      CreateBooking(repository),
      GetBookings(repository),
      UpdateBooking(repository),
    );
    addTearDown(controller.dispose);

    const technician = Technician(
      id: 'tech-test',
      name: 'Test Technician',
      profession: 'Electrician',
      location: 'Kathmandu',
      rating: 4.9,
      reviewCount: 10,
      isAvailable: true,
    );
    await controller.create(
      technician: technician,
      address: 'Thamel, Kathmandu',
      scheduledAt: DateTime.now().add(const Duration(days: 1)),
      notes: 'Repair the kitchen light.',
    );

    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: BookingsTab(controller: controller))),
    );
    await tester.pumpAndSettle();

    expect(find.text('Test Technician'), findsOneWidget);
    expect(find.text('Electrician'), findsOneWidget);
    expect(find.text('Thamel, Kathmandu'), findsOneWidget);
    expect(find.text('confirmed'), findsOneWidget);
  });

  testWidgets('completed and cancelled bookings appear in matching tabs', (
    tester,
  ) async {
    final repository = _StatusBookingRepository([
      _booking(
          'completed-booking', 'Completed Technician', BookingStatus.completed),
      _booking(
          'cancelled-booking', 'Cancelled Technician', BookingStatus.cancelled),
    ]);
    final controller = BookingController(
      CreateBooking(repository),
      GetBookings(repository),
      UpdateBooking(repository),
    );
    addTearDown(controller.dispose);
    await controller.load();

    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: BookingsTab(controller: controller))),
    );

    await tester.tap(find.text('Completed'));
    await tester.pumpAndSettle();
    expect(find.text('Completed Technician'), findsOneWidget);
    expect(find.text('Cancelled Technician'), findsNothing);

    await tester.tap(find.text('Cancelled'));
    await tester.pumpAndSettle();
    expect(find.text('Cancelled Technician'), findsOneWidget);
    expect(find.text('Completed Technician'), findsNothing);
  });

  test('client can reschedule and cancel an active booking', () async {
    final repository = _StatusBookingRepository([
      _booking('active-booking', 'Active Technician', BookingStatus.pending),
    ]);
    final controller = BookingController(
      CreateBooking(repository),
      GetBookings(repository),
      UpdateBooking(repository),
    );
    addTearDown(controller.dispose);
    await controller.load();

    final newDate = DateTime(2026, 8, 10, 14, 30);
    expect(
      await controller.reschedule(controller.bookings.single, newDate),
      isTrue,
    );
    expect(controller.bookings.single.scheduledAt, newDate);

    expect(await controller.cancel(controller.bookings.single), isTrue);
    expect(controller.bookings.single.status, BookingStatus.cancelled);
  });
}

Booking _booking(String id, String technicianName, BookingStatus status) {
  return Booking(
    id: id,
    technicianId: 'tech-$id',
    technicianName: technicianName,
    service: 'Electrician',
    location: 'Kathmandu',
    address: 'Kathmandu',
    scheduledAt: DateTime(2026, 7, 20),
    notes: '',
    status: status,
    createdAt: DateTime(2026, 7, 14),
  );
}

class _StatusBookingRepository implements BookingRepository {
  _StatusBookingRepository(this.bookings);

  final List<Booking> bookings;

  @override
  Future<Booking> createBooking(Booking booking) async => booking;

  @override
  Future<List<Booking>> getBookings() async => List.unmodifiable(bookings);

  @override
  Future<Booking> rescheduleBooking(String id, DateTime scheduledAt) async {
    final index = bookings.indexWhere((booking) => booking.id == id);
    final updated = bookings[index].copyWith(scheduledAt: scheduledAt);
    bookings[index] = updated;
    return updated;
  }

  @override
  Future<Booking> cancelBooking(String id) async {
    final index = bookings.indexWhere((booking) => booking.id == id);
    final updated = bookings[index].copyWith(status: BookingStatus.cancelled);
    bookings[index] = updated;
    return updated;
  }
}
