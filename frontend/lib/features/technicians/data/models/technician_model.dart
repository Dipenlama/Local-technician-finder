import 'package:mistrix/features/technicians/domain/entities/technician.dart';

class TechnicianModel extends Technician {
  const TechnicianModel({
    required super.id,
    required super.name,
    required super.profession,
    required super.location,
    required super.rating,
    required super.reviewCount,
    required super.isAvailable,
    super.imageUrl,
  });

  factory TechnicianModel.fromMap(Map<String, Object?> map) {
    return TechnicianModel(
      id: map['id']! as String,
      name: map['name']! as String,
      profession: map['profession']! as String,
      location: map['location']! as String,
      rating: (map['rating']! as num).toDouble(),
      reviewCount: map['reviewCount']! as int,
      isAvailable: map['isAvailable']! as bool,
      imageUrl: map['imageUrl'] as String? ?? '',
    );
  }

  Map<String, Object> toMap() => {
        'id': id,
        'name': name,
        'profession': profession,
        'location': location,
        'rating': rating,
        'reviewCount': reviewCount,
        'isAvailable': isAvailable,
        'imageUrl': imageUrl,
      };
}
