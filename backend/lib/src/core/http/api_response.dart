import 'dart:convert';

import 'package:shelf/shelf.dart';

const _jsonHeaders = {'content-type': 'application/json; charset=utf-8'};

Response jsonResponse(
  Object? data, {
  int statusCode = 200,
  Map<String, String>? headers,
}) {
  return Response(
    statusCode,
    body: jsonEncode(data),
    headers: {..._jsonHeaders, ...?headers},
  );
}

Response successResponse(Object? data, {int statusCode = 200}) {
  return jsonResponse({'success': true, 'data': data}, statusCode: statusCode);
}

Response errorResponse(
  String message, {
  int statusCode = 400,
  Object? details,
}) {
  return jsonResponse({
    'success': false,
    'error': {'message': message, if (details != null) 'details': details},
  }, statusCode: statusCode);
}

Future<Map<String, dynamic>> readJsonObject(Request request) async {
  final body = await request.readAsString();
  if (body.trim().isEmpty) return <String, dynamic>{};

  final decoded = jsonDecode(body);
  if (decoded is! Map<String, dynamic>) {
    throw const FormatException('Request body must be a JSON object.');
  }
  return decoded;
}
