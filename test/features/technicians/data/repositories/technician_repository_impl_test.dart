import 'package:flutter_test/flutter_test.dart';
import 'package:mistrix/features/technicians/data/data_sources/technician_local_data_source.dart';
import 'package:mistrix/features/technicians/data/repositories/technician_repository_impl.dart';

void main() {
  const repository = TechnicianRepositoryImpl(TechnicianLocalDataSourceImpl());

  test('returns every technician when the search is empty', () async {
    final result = await repository.getTechnicians();

    expect(result, hasLength(4));
  });

  test('filters technicians by profession', () async {
    final result = await repository.getTechnicians(query: 'plumber');

    expect(result, hasLength(1));
    expect(result.single.name, 'Sita Rai');
  });
}
