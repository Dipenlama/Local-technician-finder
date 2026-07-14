enum BookingStatus { pending, confirmed, completed, cancelled }

class Booking {
  const Booking({
    required this.id,
    required this.customerId,
    required this.technicianId,
    required this.service,
    required this.address,
    required this.scheduledAt,
    required this.status,
    required this.notes,
    required this.createdAt,
    this.technicianName = '',
    this.location = '',
  });

  final String id;
  final String customerId;
  final String technicianId;
  final String service;
  final String address;
  final DateTime scheduledAt;
  final BookingStatus status;
  final String notes;
  final DateTime createdAt;
  final String technicianName;
  final String location;

  Map<String, Object> toJson() => {
    'id': id,
    'customerId': customerId,
    'technicianId': technicianId,
    'service': service,
    'address': address,
    'scheduledAt': scheduledAt.toUtc().toIso8601String(),
    'status': status.name,
    'notes': notes,
    'createdAt': createdAt.toUtc().toIso8601String(),
    'technicianName': technicianName,
    'location': location,
  };
}
