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
}
