class AdminBooking {
  const AdminBooking({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.customerEmail,
    required this.technicianId,
    required this.technicianName,
    required this.service,
    required this.address,
    required this.scheduledAt,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String customerId;
  final String customerName;
  final String customerEmail;
  final String technicianId;
  final String technicianName;
  final String service;
  final String address;
  final DateTime scheduledAt;
  final String status;
  final DateTime createdAt;

  AdminBooking copyWith({DateTime? scheduledAt, String? status}) {
    return AdminBooking(
      id: id,
      customerId: customerId,
      customerName: customerName,
      customerEmail: customerEmail,
      technicianId: technicianId,
      technicianName: technicianName,
      service: service,
      address: address,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      status: status ?? this.status,
      createdAt: createdAt,
    );
  }
}
