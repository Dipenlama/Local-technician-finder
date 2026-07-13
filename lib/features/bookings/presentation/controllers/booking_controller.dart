import 'package:flutter/foundation.dart';
import 'package:mistrix/features/bookings/domain/entities/booking.dart';
import 'package:mistrix/features/bookings/domain/use_cases/create_booking.dart';
import 'package:mistrix/features/bookings/domain/use_cases/get_bookings.dart';
import 'package:mistrix/features/technicians/domain/entities/technician.dart';

enum BookingLoadStatus { initial, loading, success, failure }

class BookingController extends ChangeNotifier {
  BookingController(this._createBooking, this._getBookings);

  final CreateBooking _createBooking;
  final GetBookings _getBookings;

  BookingLoadStatus status = BookingLoadStatus.initial;
  List<Booking> bookings = const [];
  bool isSaving = false;
  String? errorMessage;

  Future<void> load() async {
    status = BookingLoadStatus.loading;
    notifyListeners();
    try {
      bookings = await _getBookings();
      status = BookingLoadStatus.success;
      errorMessage = null;
    } on Exception catch (error) {
      status = BookingLoadStatus.failure;
      errorMessage = error.toString();
    }
    notifyListeners();
  }

  Future<Booking?> create({
    required Technician technician,
    required String address,
    required DateTime scheduledAt,
    String notes = '',
  }) async {
    isSaving = true;
    errorMessage = null;
    notifyListeners();
    try {
      final booking = await _createBooking(
        technician: technician,
        address: address,
        scheduledAt: scheduledAt,
        notes: notes,
      );
      bookings = await _getBookings();
      status = BookingLoadStatus.success;
      return booking;
    } on Exception catch (error) {
      errorMessage = error.toString();
      return null;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }
}
