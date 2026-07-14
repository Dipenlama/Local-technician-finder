class AdminService {
  const AdminService({
    required this.id,
    required this.name,
    required this.description,
    required this.basePrice,
    required this.isActive,
  });

  final String id;
  final String name;
  final String description;
  final double basePrice;
  final bool isActive;

  AdminService copyWith({
    String? name,
    String? description,
    double? basePrice,
    bool? isActive,
  }) {
    return AdminService(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      basePrice: basePrice ?? this.basePrice,
      isActive: isActive ?? this.isActive,
    );
  }
}
