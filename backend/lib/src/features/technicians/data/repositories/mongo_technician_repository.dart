import 'package:mistrix_backend/src/core/database/mongo_database.dart';
import 'package:mistrix_backend/src/features/technicians/domain/entities/technician.dart';
import 'package:mistrix_backend/src/features/technicians/domain/repositories/technician_repository.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoTechnicianRepository implements TechnicianRepository {
  const MongoTechnicianRepository(this._database);

  final MongoDatabase _database;

  @override
  Future<List<Technician>> findAll({
    String query = '',
    String profession = '',
    bool? available,
  }) async {
    final documents = await _database.technicians.find().toList();
    final normalizedQuery = query.trim().toLowerCase();
    final normalizedProfession = profession.trim().toLowerCase();
    return documents
        .map(_fromDocument)
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
    final document = await _database.technicians.findOne(where.eq('_id', id));
    return document == null ? null : _fromDocument(document);
  }

  Future<void> save(Technician technician) async {
    await _database.technicians.replaceOne(
      where.eq('_id', technician.id),
      _toDocument(technician),
      upsert: true,
    );
  }

  Future<void> delete(String id) async {
    await _database.technicians.deleteOne(where.eq('_id', id));
  }

  Technician _fromDocument(Map<String, dynamic> document) => Technician(
    id: document['_id'] as String,
    name: document['name'] as String,
    profession: document['profession'] as String,
    location: document['location'] as String,
    rating: (document['rating'] as num).toDouble(),
    reviewCount: document['reviewCount'] as int,
    isAvailable: document['isAvailable'] as bool,
    hourlyRate: (document['hourlyRate'] as num).toDouble(),
    imageUrl: document['imageUrl'] as String? ?? '',
  );

  Map<String, dynamic> _toDocument(Technician technician) => {
    '_id': technician.id,
    'name': technician.name,
    'profession': technician.profession,
    'location': technician.location,
    'rating': technician.rating,
    'reviewCount': technician.reviewCount,
    'isAvailable': technician.isAvailable,
    'hourlyRate': technician.hourlyRate,
    'imageUrl': technician.imageUrl,
  };
}
