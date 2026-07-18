enum BookingStatus { pending, confirmed, completed, cancelled }

class Booking {
  const Booking({
    required this.id,
    required this.technicianId,
    required this.technicianName,
    required this.service,
    required this.location,
    required this.address,
    required this.scheduledAt,
    required this.notes,
    required this.status,
    required this.createdAt,
    this.technicianImageUrl = '',
  });

  final String id;
  final String technicianId;
  final String technicianName;
  final String service;
  final String location;
  final String address;
  final DateTime scheduledAt;
  final String notes;
  final BookingStatus status;
  final DateTime createdAt;
  final String technicianImageUrl;

  Booking copyWith({DateTime? scheduledAt, BookingStatus? status}) {
    return Booking(
      id: id,
      technicianId: technicianId,
      technicianName: technicianName,
      service: service,
      location: location,
      address: address,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      notes: notes,
      status: status ?? this.status,
      createdAt: createdAt,
      technicianImageUrl: technicianImageUrl,
    );
  }
}
