import 'package:mistrix_backend/src/core/errors/api_exception.dart';
import 'package:mistrix_backend/src/core/http/api_response.dart';
import 'package:mistrix_backend/src/features/technicians/domain/repositories/technician_repository.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class TechnicianHandler {
  const TechnicianHandler(this._repository);

  final TechnicianRepository _repository;

  Router get router {
    final router = Router();
    router.get('/', _findAll);
    router.get('/<id>', _findOne);
    return router;
  }

  Future<Response> _findAll(Request request) async {
    final params = request.url.queryParameters;
    final availableValue = params['available'];
    bool? available;
    if (availableValue == 'true') available = true;
    if (availableValue == 'false') available = false;

    final technicians = await _repository.findAll(
      query: params['query'] ?? '',
      profession: params['profession'] ?? '',
      available: available,
    );
    return successResponse({
      'items': technicians.map((item) => item.toJson()).toList(growable: false),
      'count': technicians.length,
    });
  }

  Future<Response> _findOne(Request request, String id) async {
    final technician = await _repository.findById(id);
    if (technician == null) {
      throw const ApiException(404, 'Technician not found.');
    }
    return successResponse(technician.toJson());
  }
}
