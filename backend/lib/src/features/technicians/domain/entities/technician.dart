class Technician {
  const Technician({
    required this.id,
    required this.name,
    required this.profession,
    required this.location,
    required this.rating,
    required this.reviewCount,
    required this.isAvailable,
    required this.hourlyRate,
  });

  final String id;
  final String name;
  final String profession;
  final String location;
  final double rating;
  final int reviewCount;
  final bool isAvailable;
  final double hourlyRate;

  Map<String, Object> toJson() => {
    'id': id,
    'name': name,
    'profession': profession,
    'location': location,
    'rating': rating,
    'reviewCount': reviewCount,
    'isAvailable': isAvailable,
    'hourlyRate': hourlyRate,
  };
}
