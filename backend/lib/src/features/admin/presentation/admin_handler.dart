import 'package:bcrypt/bcrypt.dart';
import 'package:mistrix_backend/src/core/database/mongo_database.dart';
import 'package:mistrix_backend/src/core/errors/api_exception.dart';
import 'package:mistrix_backend/src/core/http/api_response.dart';
import 'package:mistrix_backend/src/features/auth/domain/services/auth_service.dart';
import 'package:mistrix_backend/src/features/technicians/data/repositories/mongo_technician_repository.dart';
import 'package:mistrix_backend/src/features/notifications/domain/services/notification_service.dart';
import 'package:mistrix_backend/src/features/technicians/domain/entities/technician.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class AdminHandler {
  const AdminHandler({
    required this.database,
    required this.authService,
    required this.technicians,
    required this.notificationService,
  });

  final MongoDatabase database;
  final AuthService authService;
  final MongoTechnicianRepository technicians;
  final NotificationService notificationService;

  Router get router {
    final router = Router();
    router.get('/services', _getServices);
    router.put('/services/<id>', _saveService);
    router.delete('/services/<id>', _deleteService);
    router.get('/technicians', _getTechnicians);
    router.put('/technicians/<id>', _saveTechnician);
    router.delete('/technicians/<id>', _deleteTechnician);
    router.get('/clients', _getClients);
    router.put('/clients/<id>', _saveClient);
    router.delete('/clients/<id>', _deleteClient);
    router.get('/bookings', _getBookings);
    router.put('/bookings/<id>', _updateBooking);
    return router;
  }

  Future<void> _requireAdmin(Request request) async {
    final user = await authService.userFromRequest(request);
    if (user.role != 'admin') {
      throw const ApiException(403, 'Admin access required.');
    }
  }

  Future<Response> _getServices(Request request) async {
    await _requireAdmin(request);
    final items = await database.services.find().toList();
    return successResponse({'items': items.map(_publicDocument).toList()});
  }

  Future<Response> _saveService(Request request, String id) async {
    await _requireAdmin(request);
    final body = await readJsonObject(request);
    await database.services.replaceOne(where.eq('_id', id), {
      '_id': id,
      'name': body['name'],
      'description': body['description'],
      'basePrice': body['basePrice'],
      'isActive': body['isActive'] ?? true,
    }, upsert: true);
    return successResponse({'id': id});
  }

  Future<Response> _deleteService(Request request, String id) async {
    await _requireAdmin(request);
    await database.services.deleteOne(where.eq('_id', id));
    return successResponse({'id': id});
  }

  Future<Response> _getTechnicians(Request request) async {
    await _requireAdmin(request);
    final items = await technicians.findAll();
    return successResponse({
      'items': items.map((item) => item.toJson()).toList(),
    });
  }

  Future<Response> _saveTechnician(Request request, String id) async {
    await _requireAdmin(request);
    final body = await readJsonObject(request);
    await technicians.save(
      Technician(
        id: id,
        name: body['name'] as String,
        profession: body['profession'] as String,
        location: body['location'] as String,
        rating: (body['rating'] as num).toDouble(),
        reviewCount: body['reviewCount'] as int? ?? 0,
        isAvailable: body['isAvailable'] as bool? ?? true,
        hourlyRate: (body['hourlyRate'] as num?)?.toDouble() ?? 0,
        imageUrl: body['imageUrl'] as String? ?? '',
      ),
    );
    return successResponse({'id': id});
  }

  Future<Response> _deleteTechnician(Request request, String id) async {
    await _requireAdmin(request);
    await technicians.delete(id);
    return successResponse({'id': id});
  }

  Future<Response> _getClients(Request request) async {
    await _requireAdmin(request);
    final documents =
        await database.users.find(where.eq('role', 'client')).toList();
    final items =
        documents
            .map(
              (item) => {
                'id': item['_id'],
                'name': item['name'],
                'email': item['email'],
                'phone': item['phone'],
                'isActive': item['isActive'] ?? true,
                'joinedAt':
                    (item['createdAt'] as DateTime).toUtc().toIso8601String(),
              },
            )
            .toList();
    return successResponse({'items': items});
  }

  Future<Response> _saveClient(Request request, String id) async {
    await _requireAdmin(request);
    final body = await readJsonObject(request);
    final existing = await database.users.findOne(where.eq('_id', id));
    await database.users.replaceOne(where.eq('_id', id), {
      '_id': id,
      'name': body['name'],
      'email': (body['email'] as String).toLowerCase(),
      'phone': body['phone'],
      'isActive': body['isActive'] ?? true,
      'role': 'client',
      'createdAt': existing?['createdAt'] ?? DateTime.now().toUtc(),
      'passwordHash':
          existing?['passwordHash'] ??
          BCrypt.hashpw('ChangeMe123', BCrypt.gensalt()),
    }, upsert: true);
    return successResponse({'id': id});
  }

  Future<Response> _deleteClient(Request request, String id) async {
    await _requireAdmin(request);
    await database.users.deleteOne(where.eq('_id', id));
    return successResponse({'id': id});
  }

  Future<Response> _getBookings(Request request) async {
    await _requireAdmin(request);
    final documents = await database.bookings.find().toList();
    documents.sort((a, b) {
      final aDate = a['createdAt'] as DateTime;
      final bDate = b['createdAt'] as DateTime;
      return bDate.compareTo(aDate);
    });
    final items = await Future.wait(documents.map(_bookingResponse));
    return successResponse({'items': items, 'count': items.length});
  }

  Future<Response> _updateBooking(Request request, String id) async {
    await _requireAdmin(request);
    final existing = await database.bookings.findOne(where.eq('_id', id));
    if (existing == null) {
      throw const ApiException(404, 'Booking not found.');
    }
    final body = await readJsonObject(request);
    final status = body['status'] as String? ?? existing['status'] as String;
    const allowedStatuses = {'pending', 'confirmed', 'cancelled', 'completed'};
    if (!allowedStatuses.contains(status)) {
      throw const ApiException(422, 'Invalid booking status.');
    }
    final scheduledAtValue = body['scheduledAt'] as String?;
    final scheduledAt =
        scheduledAtValue == null
            ? existing['scheduledAt'] as DateTime
            : DateTime.tryParse(scheduledAtValue);
    if (scheduledAt == null) {
      throw const ApiException(422, 'Invalid booking date and time.');
    }

    final updated =
        Map<String, dynamic>.from(existing)
          ..['status'] = status
          ..['scheduledAt'] = scheduledAt.toUtc()
          ..['updatedAt'] = DateTime.now().toUtc();
    await database.bookings.replaceOne(where.eq('_id', id), updated);
    final customerId = existing['customerId'] as String;
    if (status != existing['status']) {
      final event = switch (status) {
        'completed' => (
          'Booking completed',
          'Your ${existing['service']} booking has been marked complete.',
          'booking_completed',
        ),
        'cancelled' => (
          'Booking cancelled',
          'Your ${existing['service']} booking was cancelled by the admin.',
          'booking_cancelled',
        ),
        'confirmed' => (
          'Booking confirmed',
          'Your ${existing['service']} booking has been confirmed.',
          'booking_confirmed',
        ),
        _ => null,
      };
      if (event != null) {
        await notificationService.send(
          userId: customerId,
          title: event.$1,
          message: event.$2,
          type: event.$3,
          bookingId: id,
        );
      }
    } else if (scheduledAt != existing['scheduledAt']) {
      await notificationService.send(
        userId: customerId,
        title: 'Booking rescheduled',
        message: 'Your ${existing['service']} booking has a new schedule.',
        type: 'booking_rescheduled',
        bookingId: id,
      );
    }
    return successResponse(await _bookingResponse(updated));
  }

  Future<Map<String, dynamic>> _bookingResponse(
    Map<String, dynamic> booking,
  ) async {
    final customer = await database.users.findOne(
      where.eq('_id', booking['customerId']),
    );
    return {
      'id': booking['_id'],
      'customerId': booking['customerId'],
      'customerName': customer?['name'] ?? 'Client',
      'customerEmail': customer?['email'] ?? '',
      'technicianId': booking['technicianId'],
      'technicianName': booking['technicianName'] ?? 'Technician',
      'service': booking['service'],
      'address': booking['address'],
      'scheduledAt':
          (booking['scheduledAt'] as DateTime).toUtc().toIso8601String(),
      'status': booking['status'],
      'createdAt': (booking['createdAt'] as DateTime).toUtc().toIso8601String(),
    };
  }

  Map<String, dynamic> _publicDocument(Map<String, dynamic> item) => {
    'id': item['_id'],
    ...item..remove('_id'),
  };
}
