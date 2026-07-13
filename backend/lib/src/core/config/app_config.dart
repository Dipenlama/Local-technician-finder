import 'dart:io';

class AppConfig {
  const AppConfig({
    required this.host,
    required this.port,
    required this.jwtSecret,
    required this.allowedOrigin,
  });

  factory AppConfig.fromEnvironment() {
    final environment = Platform.environment;
    return AppConfig(
      host: environment['HOST'] ?? '0.0.0.0',
      port: int.tryParse(environment['PORT'] ?? '') ?? 8080,
      jwtSecret:
          environment['JWT_SECRET'] ?? 'mistrix-development-secret-change-me',
      allowedOrigin: environment['ALLOWED_ORIGIN'] ?? '*',
    );
  }

  final String host;
  final int port;
  final String jwtSecret;
  final String allowedOrigin;
}
