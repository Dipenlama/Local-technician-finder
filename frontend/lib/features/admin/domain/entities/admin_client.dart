class AdminClient {
  const AdminClient({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.isActive,
    required this.joinedAt,
  });

  final String id;
  final String name;
  final String email;
  final String phone;
  final bool isActive;
  final DateTime joinedAt;

  AdminClient copyWith({
    String? name,
    String? email,
    String? phone,
    bool? isActive,
  }) {
    return AdminClient(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      isActive: isActive ?? this.isActive,
      joinedAt: joinedAt,
    );
  }
}
