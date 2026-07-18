import 'package:flutter/foundation.dart';
import 'package:mistrix/features/bookings/domain/entities/booking.dart';
import 'package:mistrix/features/bookings/domain/use_cases/create_booking.dart';
import 'package:mistrix/features/bookings/domain/use_cases/get_bookings.dart';
import 'package:mistrix/features/bookings/domain/use_cases/update_booking.dart';
import 'package:mistrix/features/technicians/domain/entities/technician.dart';

enum BookingLoadStatus { initial, loading, success, failure }

class BookingController extends ChangeNotifier {
  BookingController(
      this._createBooking, this._getBookings, this._updateBooking);

  final CreateBooking _createBooking;
  final GetBookings _getBookings;
  final UpdateBooking _updateBooking;

  BookingLoadStatus status = BookingLoadStatus.initial;
  List<Booking> bookings = const [];
  bool isSaving = false;
  String? errorMessage;
  String? updatingBookingId;

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

  Future<bool> reschedule(Booking booking, DateTime scheduledAt) {
    return _update(
      booking.id,
      () => _updateBooking.reschedule(booking.id, scheduledAt),
    );
  }

  Future<bool> cancel(Booking booking) {
    return _update(booking.id, () => _updateBooking.cancel(booking.id));
  }

  Future<bool> _update(
    String id,
    Future<Booking> Function() operation,
  ) async {
    updatingBookingId = id;
    errorMessage = null;
    notifyListeners();
    try {
      await operation();
      bookings = await _getBookings();
      status = BookingLoadStatus.success;
      return true;
    } on Exception catch (error) {
      errorMessage = error.toString();
      return false;
    } finally {
      updatingBookingId = null;
      notifyListeners();
    }
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
