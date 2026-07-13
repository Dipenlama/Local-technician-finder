import 'package:mistrix_backend/src/features/technicians/domain/entities/technician.dart';
import 'package:mistrix_backend/src/features/technicians/domain/repositories/technician_repository.dart';

class InMemoryTechnicianRepository implements TechnicianRepository {
  const InMemoryTechnicianRepository();

  static const _technicians = [
    Technician(
      id: 'tech-001',
      name: 'Aarav Sharma',
      profession: 'Electrician',
      location: 'Kathmandu',
      rating: 4.9,
      reviewCount: 126,
      isAvailable: true,
      hourlyRate: 850,
    ),
    Technician(
      id: 'tech-002',
      name: 'Sita Rai',
      profession: 'Plumber',
      location: 'Lalitpur',
      rating: 4.8,
      reviewCount: 94,
      isAvailable: true,
      hourlyRate: 750,
    ),
    Technician(
      id: 'tech-003',
      name: 'Nabin Thapa',
      profession: 'AC Technician',
      location: 'Bhaktapur',
      rating: 4.7,
      reviewCount: 81,
      isAvailable: false,
      hourlyRate: 1000,
    ),
    Technician(
      id: 'tech-004',
      name: 'Maya Gurung',
      profession: 'Computer Repair',
      location: 'Kathmandu',
      rating: 4.9,
      reviewCount: 158,
      isAvailable: true,
      hourlyRate: 1200,
    ),
  ];

  @override
  Future<List<Technician>> findAll({
    String query = '',
    String profession = '',
    bool? available,
  }) async {
    final normalizedQuery = query.trim().toLowerCase();
    final normalizedProfession = profession.trim().toLowerCase();

    return _technicians
        .where((technician) {
          final matchesQuery =
              normalizedQuery.isEmpty ||
              technician.name.toLowerCase().contains(normalizedQuery) ||
              technician.profession.toLowerCase().contains(normalizedQuery) ||
              technician.location.toLowerCase().contains(normalizedQuery);
          final matchesProfession =
              normalizedProfession.isEmpty ||
              technician.profession.toLowerCase() == normalizedProfession;
          final matchesAvailability =
              available == null || technician.isAvailable == available;
          return matchesQuery && matchesProfession && matchesAvailability;
        })
        .toList(growable: false);
  }

  @override
  Future<Technician?> findById(String id) async {
    for (final technician in _technicians) {
      if (technician.id == id) return technician;
    }
    return null;
  }
}
