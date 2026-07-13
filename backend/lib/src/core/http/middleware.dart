import 'dart:io';

import 'package:mistrix_backend/src/core/errors/api_exception.dart';
import 'package:mistrix_backend/src/core/http/api_response.dart';
import 'package:shelf/shelf.dart';

Middleware corsMiddleware(String allowedOrigin) {
  const allowedHeaders = 'Origin, Content-Type, Accept, Authorization';
  const allowedMethods = 'GET, POST, PUT, PATCH, DELETE, OPTIONS';

  return (Handler innerHandler) {
    return (Request request) async {
      final headers = {
        'access-control-allow-origin': allowedOrigin,
        'access-control-allow-headers': allowedHeaders,
        'access-control-allow-methods': allowedMethods,
      };

      if (request.method == 'OPTIONS') {
        return Response.ok('', headers: headers);
      }

      final response = await innerHandler(request);
      return response.change(headers: {...response.headers, ...headers});
    };
  };
}

Middleware errorMiddleware() {
  return (Handler innerHandler) {
    return (Request request) async {
      try {
        return await innerHandler(request);
      } on ApiException catch (error) {
        return errorResponse(
          error.message,
          statusCode: error.statusCode,
          details: error.details,
        );
      } on FormatException catch (error) {
        return errorResponse(error.message, statusCode: 400);
      } on Object catch (error, stackTrace) {
        stderr.writeln('Unhandled API error: $error\n$stackTrace');
        return errorResponse('Internal server error.', statusCode: 500);
      }
    };
  };
}
