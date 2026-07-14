import 'package:flutter/foundation.dart';

abstract final class ApiConfig {
  static const _definedUrl = String.fromEnvironment('API_BASE_URL');

  static String get baseUrl {
    if (_definedUrl.isNotEmpty) return _definedUrl;
    if (kIsWeb) return 'http://localhost:8080/api/v1';
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8080/api/v1';
    }
    return 'http://localhost:8080/api/v1';
  }
}
