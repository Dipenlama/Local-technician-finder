import 'package:mistrix_backend/src/core/http/api_response.dart';
import 'package:mistrix_backend/src/features/auth/domain/services/auth_service.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class AuthHandler {
  const AuthHandler(this._authService);

  final AuthService _authService;

  Router get router {
    final router = Router();
    router.post('/signup', _signup);
    router.post('/login', _login);
    router.get('/me', _me);
    router.put('/me', _updateMe);
    return router;
  }

  Future<Response> _signup(Request request) async {
    final body = await readJsonObject(request);
    final result = await _authService.signup(
      name: body['name'] as String? ?? '',
      email: body['email'] as String? ?? '',
      phone: body['phone'] as String? ?? '',
      password: body['password'] as String? ?? '',
    );
    return successResponse(result.toJson(), statusCode: 201);
  }

  Future<Response> _login(Request request) async {
    final body = await readJsonObject(request);
    final result = await _authService.login(
      email: body['email'] as String? ?? '',
      password: body['password'] as String? ?? '',
    );
    return successResponse(result.toJson());
  }

  Future<Response> _me(Request request) async {
    final user = await _authService.userFromRequest(request);
    return successResponse(user.toPublicJson());
  }

  Future<Response> _updateMe(Request request) async {
    final body = await readJsonObject(request);
    final user = await _authService.updateProfile(
      request,
      name: body['name'] as String? ?? '',
      email: body['email'] as String? ?? '',
      phone: body['phone'] as String? ?? '',
    );
    return successResponse(user.toPublicJson());
  }
}
