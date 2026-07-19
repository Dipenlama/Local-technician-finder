import 'package:mistrix_backend/src/core/errors/api_exception.dart';
import 'package:mistrix_backend/src/core/http/api_response.dart';
import 'package:mistrix_backend/src/features/auth/domain/services/auth_service.dart';
import 'package:mistrix_backend/src/features/favorites/domain/repositories/favorite_repository.dart';
import 'package:mistrix_backend/src/features/technicians/domain/entities/technician.dart';
import 'package:mistrix_backend/src/features/technicians/domain/repositories/technician_repository.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class FavoriteHandler {
  const FavoriteHandler({
    required this.authService,
    required this.repository,
    required this.technicians,
  });

  final AuthService authService;
  final FavoriteRepository repository;
  final TechnicianRepository technicians;

  Router get router {
    final router = Router();
    router.get('/', _findMine);
    router.put('/<technicianId>', _add);
    router.delete('/<technicianId>', _remove);
    return router;
  }

  Future<Response> _findMine(Request request) async {
    final user = await authService.userFromRequest(request);
    final ids = await repository.findTechnicianIds(user.id);
    final items = await Future.wait(ids.map(technicians.findById));
    final favorites = items
        .whereType<Technician>()
        .map((item) => item.toJson())
        .toList(growable: false);
    return successResponse({'items': favorites, 'count': favorites.length});
  }

  Future<Response> _add(Request request, String technicianId) async {
    final user = await authService.userFromRequest(request);
    final technician = await technicians.findById(technicianId);
    if (technician == null) {
      throw const ApiException(404, 'Technician not found.');
    }
    await repository.add(user.id, technicianId);
    return successResponse(technician.toJson());
  }

  Future<Response> _remove(Request request, String technicianId) async {
    final user = await authService.userFromRequest(request);
    await repository.remove(user.id, technicianId);
    return successResponse({'technicianId': technicianId});
  }
}
