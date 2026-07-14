import 'package:flutter/foundation.dart';
import 'package:mistrix/features/technicians/domain/entities/technician.dart';
import 'package:mistrix/features/technicians/domain/use_cases/get_technicians.dart';

enum TechnicianStatus { initial, loading, success, failure }

class TechnicianController extends ChangeNotifier {
  TechnicianController(this._getTechnicians);

  final GetTechnicians _getTechnicians;

  TechnicianStatus status = TechnicianStatus.initial;
  List<Technician> technicians = const [];
  String? errorMessage;

  Future<void> load({String query = ''}) async {
    status = TechnicianStatus.loading;
    errorMessage = null;
    notifyListeners();

    try {
      technicians = await _getTechnicians(query: query);
      status = TechnicianStatus.success;
    } on Exception catch (error) {
      technicians = const [];
      errorMessage = error.toString();
      status = TechnicianStatus.failure;
    }

    notifyListeners();
  }
}
