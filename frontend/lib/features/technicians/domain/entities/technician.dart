class Technician {
  const Technician({
    required this.id,
    required this.name,
    required this.profession,
    required this.location,
    required this.rating,
    required this.reviewCount,
    required this.isAvailable,
    this.imageUrl = '',
  });

  final String id;
  final String name;
  final String profession;
  final String location;
  final double rating;
  final int reviewCount;
  final bool isAvailable;
  final String imageUrl;
}
