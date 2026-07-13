import 'package:mistrix/features/technicians/data/data_sources/technician_local_data_source.dart';
import 'package:mistrix/features/technicians/data/repositories/technician_repository_impl.dart';
import 'package:mistrix/features/technicians/domain/use_cases/get_technicians.dart';

class AppDependencies {
  const AppDependencies({required this.getTechnicians});

  final GetTechnicians getTechnicians;
}

AppDependencies configureDependencies() {
  const dataSource = TechnicianLocalDataSourceImpl();
  const repository = TechnicianRepositoryImpl(dataSource);
  const getTechnicians = GetTechnicians(repository);

  return const AppDependencies(getTechnicians: getTechnicians);
}
