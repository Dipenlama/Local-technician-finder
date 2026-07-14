import 'package:flutter_test/flutter_test.dart';
import 'package:mistrix/features/technicians/data/data_sources/technician_local_data_source.dart';
import 'package:mistrix/features/technicians/data/repositories/technician_repository_impl.dart';

void main() {
  final repository = TechnicianRepositoryImpl(TechnicianLocalDataSourceImpl());

  test('returns every technician when the search is empty', () async {
    final result = await repository.getTechnicians();

    expect(result, hasLength(10));
  });

  test('filters technicians by profession', () async {
    final result = await repository.getTechnicians(query: 'plumber');

    expect(result, hasLength(2));
    expect(result.map((technician) => technician.name), contains('Sita Rai'));
  });
}
