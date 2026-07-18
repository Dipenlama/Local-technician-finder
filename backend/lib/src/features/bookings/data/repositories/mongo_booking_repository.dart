import 'package:mistrix_backend/src/core/database/mongo_database.dart';
import 'package:mistrix_backend/src/features/bookings/domain/entities/booking.dart';
import 'package:mistrix_backend/src/features/bookings/domain/repositories/booking_repository.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoBookingRepository implements BookingRepository {
  const MongoBookingRepository(this._database);

  final MongoDatabase _database;

  @override
  Future<Booking> create(Booking booking) async {
    await _database.bookings.insertOne(_toDocument(booking));
    return booking;
  }

  @override
  Future<List<Booking>> findByCustomerId(String customerId) async {
    final documents =
        await _database.bookings
            .find(where.eq('customerId', customerId))
            .toList();
    final bookings = documents.map(_fromDocument).toList();
    bookings.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return bookings;
  }

  @override
  Future<Booking?> findById(String id) async {
    final document = await _database.bookings.findOne(where.eq('_id', id));
    return document == null ? null : _fromDocument(document);
  }

  @override
  Future<Booking> update(Booking booking) async {
    await _database.bookings.replaceOne(
      where.eq('_id', booking.id),
      _toDocument(booking),
    );
    return booking;
  }

  Booking _fromDocument(Map<String, dynamic> document) => Booking(
    id: document['_id'] as String,
    customerId: document['customerId'] as String,
    technicianId: document['technicianId'] as String,
    service: document['service'] as String,
    address: document['address'] as String,
    scheduledAt: (document['scheduledAt'] as DateTime).toUtc(),
    status: BookingStatus.values.byName(document['status'] as String),
    notes: document['notes'] as String? ?? '',
    createdAt: (document['createdAt'] as DateTime).toUtc(),
    technicianName: document['technicianName'] as String? ?? '',
    location: document['location'] as String? ?? '',
    technicianImageUrl: document['technicianImageUrl'] as String? ?? '',
  );

  Map<String, dynamic> _toDocument(Booking booking) => {
    '_id': booking.id,
    'customerId': booking.customerId,
    'technicianId': booking.technicianId,
    'service': booking.service,
    'address': booking.address,
    'scheduledAt': booking.scheduledAt,
    'status': booking.status.name,
    'notes': booking.notes,
    'createdAt': booking.createdAt,
    'technicianName': booking.technicianName,
    'location': booking.location,
    'technicianImageUrl': booking.technicianImageUrl,
  };
}
