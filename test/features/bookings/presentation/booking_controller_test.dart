import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mistrix/features/bookings/data/repositories/in_memory_booking_repository.dart';
import 'package:mistrix/features/bookings/domain/use_cases/create_booking.dart';
import 'package:mistrix/features/bookings/domain/use_cases/get_bookings.dart';
import 'package:mistrix/features/bookings/presentation/controllers/booking_controller.dart';
import 'package:mistrix/features/home/presentation/pages/tabs/bookings_tab.dart';
import 'package:mistrix/features/technicians/domain/entities/technician.dart';

void main() {
  testWidgets('confirmed booking appears in the bookings tab', (tester) async {
    final repository = InMemoryBookingRepository();
    final controller = BookingController(
      CreateBooking(repository),
      GetBookings(repository),
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
}
