import 'package:mistrix/core/network/api_client.dart';
import 'package:mistrix/core/errors/app_exception.dart';
import 'package:mistrix/features/admin/domain/entities/admin_client.dart';
import 'package:mistrix/features/admin/domain/entities/admin_booking.dart';
import 'package:mistrix/features/admin/domain/entities/admin_service.dart';
import 'package:mistrix/features/admin/domain/repositories/admin_repository.dart';
import 'package:mistrix/features/technicians/domain/entities/technician.dart';

class RemoteAdminRepository implements AdminRepository {
  const RemoteAdminRepository(this._client);

  final ApiClient _client;

  @override
  Future<List<AdminService>> getServices() async {
    Map<String, dynamic> data;
    try {
      data = await _client.get('/services/') as Map<String, dynamic>;
    } on AppException {
      data = await _client.get('/admin/services') as Map<String, dynamic>;
    }
    return (data['items'] as List)
        .cast<Map<String, dynamic>>()
        .map((item) => AdminService(
              id: item['id'] as String,
              name: item['name'] as String,
              description: item['description'] as String,
              basePrice: (item['basePrice'] as num).toDouble(),
              isActive: item['isActive'] as bool,
            ))
        .toList();
  }

  @override
  Future<void> saveService(AdminService service) async {
    await _client.put('/admin/services/${service.id}', {
      'name': service.name,
      'description': service.description,
      'basePrice': service.basePrice,
      'isActive': service.isActive,
    });
  }

  @override
  Future<void> deleteService(String id) =>
      _client.delete('/admin/services/$id');

  @override
  Future<List<Technician>> getTechnicians() async {
    final data =
        await _client.get('/admin/technicians') as Map<String, dynamic>;
    return (data['items'] as List)
        .cast<Map<String, dynamic>>()
        .map((item) => Technician(
              id: item['id'] as String,
              name: item['name'] as String,
              profession: item['profession'] as String,
              location: item['location'] as String,
              rating: (item['rating'] as num).toDouble(),
              reviewCount: item['reviewCount'] as int,
              isAvailable: item['isAvailable'] as bool,
            ))
        .toList();
  }

  @override
  Future<void> saveTechnician(Technician technician) async {
    await _client.put('/admin/technicians/${technician.id}', {
      'name': technician.name,
      'profession': technician.profession,
      'location': technician.location,
      'rating': technician.rating,
      'reviewCount': technician.reviewCount,
      'isAvailable': technician.isAvailable,
    });
  }

  @override
  Future<void> deleteTechnician(String id) =>
      _client.delete('/admin/technicians/$id');

  @override
  Future<List<AdminClient>> getClients() async {
    final data = await _client.get('/admin/clients') as Map<String, dynamic>;
    return (data['items'] as List)
        .cast<Map<String, dynamic>>()
        .map((item) => AdminClient(
              id: item['id'] as String,
              name: item['name'] as String,
              email: item['email'] as String,
              phone: item['phone'] as String,
              isActive: item['isActive'] as bool,
              joinedAt: DateTime.parse(item['joinedAt'] as String).toLocal(),
            ))
        .toList();
  }

  @override
  Future<void> saveClient(AdminClient client) async {
    await _client.put('/admin/clients/${client.id}', {
      'name': client.name,
      'email': client.email,
      'phone': client.phone,
      'isActive': client.isActive,
    });
  }

  @override
  Future<void> deleteClient(String id) => _client.delete('/admin/clients/$id');

  @override
  Future<List<AdminBooking>> getBookings() async {
    final data = await _client.get('/admin/bookings') as Map<String, dynamic>;
    return (data['items'] as List)
        .cast<Map<String, dynamic>>()
        .map(_bookingFromJson)
        .toList(growable: false);
  }

  @override
  Future<AdminBooking> updateBooking(AdminBooking booking) async {
    final data = await _client.put('/admin/bookings/${booking.id}', {
      'status': booking.status,
      'scheduledAt': booking.scheduledAt.toUtc().toIso8601String(),
    }) as Map<String, dynamic>;
    return _bookingFromJson(data);
  }

  AdminBooking _bookingFromJson(Map<String, dynamic> item) => AdminBooking(
        id: item['id'] as String,
        customerId: item['customerId'] as String,
        customerName: item['customerName'] as String? ?? 'Client',
        customerEmail: item['customerEmail'] as String? ?? '',
        technicianId: item['technicianId'] as String,
        technicianName: item['technicianName'] as String? ?? 'Technician',
        service: item['service'] as String,
        address: item['address'] as String,
        scheduledAt: DateTime.parse(item['scheduledAt'] as String).toLocal(),
        status: item['status'] as String,
        createdAt: DateTime.parse(item['createdAt'] as String).toLocal(),
      );
}
