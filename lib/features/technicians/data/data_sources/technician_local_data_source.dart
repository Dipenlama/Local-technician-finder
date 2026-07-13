import 'package:mistrix/features/technicians/data/models/technician_model.dart';

abstract interface class TechnicianLocalDataSource {
  Future<List<TechnicianModel>> getTechnicians();
}

class TechnicianLocalDataSourceImpl implements TechnicianLocalDataSource {
  const TechnicianLocalDataSourceImpl();

  @override
  Future<List<TechnicianModel>> getTechnicians() async {
    return _technicians.map(TechnicianModel.fromMap).toList(growable: false);
  }

  static const _technicians = <Map<String, Object>>[
    {
      'id': 'tech-001',
      'name': 'Aarav Sharma',
      'profession': 'Electrician',
      'location': 'Kathmandu',
      'rating': 4.9,
      'reviewCount': 126,
      'isAvailable': true,
    },
    {
      'id': 'tech-002',
      'name': 'Sita Rai',
      'profession': 'Plumber',
      'location': 'Lalitpur',
      'rating': 4.8,
      'reviewCount': 94,
      'isAvailable': true,
    },
    {
      'id': 'tech-003',
      'name': 'Nabin Thapa',
      'profession': 'AC Technician',
      'location': 'Bhaktapur',
      'rating': 4.7,
      'reviewCount': 81,
      'isAvailable': false,
    },
    {
      'id': 'tech-004',
      'name': 'Maya Gurung',
      'profession': 'Computer Repair',
      'location': 'Kathmandu',
      'rating': 4.9,
      'reviewCount': 158,
      'isAvailable': true,
    },
    {
      'id': 'tech-005',
      'name': 'Ramesh Karki',
      'profession': 'Carpenter',
      'location': 'Kathmandu',
      'rating': 4.8,
      'reviewCount': 73,
      'isAvailable': true,
    },
    {
      'id': 'tech-006',
      'name': 'Anita Maharjan',
      'profession': 'Electrician',
      'location': 'Lalitpur',
      'rating': 4.7,
      'reviewCount': 68,
      'isAvailable': true,
    },
    {
      'id': 'tech-007',
      'name': 'Bikash Tamang',
      'profession': 'Plumber',
      'location': 'Bhaktapur',
      'rating': 4.6,
      'reviewCount': 57,
      'isAvailable': false,
    },
    {
      'id': 'tech-008',
      'name': 'Prakash Shrestha',
      'profession': 'AC Technician',
      'location': 'Kathmandu',
      'rating': 4.8,
      'reviewCount': 102,
      'isAvailable': true,
    },
    {
      'id': 'tech-009',
      'name': 'Sunita Lama',
      'profession': 'Computer Repair',
      'location': 'Lalitpur',
      'rating': 4.7,
      'reviewCount': 89,
      'isAvailable': true,
    },
    {
      'id': 'tech-010',
      'name': 'Hari Adhikari',
      'profession': 'Carpenter',
      'location': 'Bhaktapur',
      'rating': 4.6,
      'reviewCount': 61,
      'isAvailable': false,
    },
  ];
}
