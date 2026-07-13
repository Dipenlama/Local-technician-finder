class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.passwordHash,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String email;
  final String phone;
  final String passwordHash;
  final DateTime createdAt;

  Map<String, Object> toPublicJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'createdAt': createdAt.toUtc().toIso8601String(),
  };
}
