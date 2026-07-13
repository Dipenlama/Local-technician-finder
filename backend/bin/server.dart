import 'dart:io';

import 'package:mistrix_backend/src/app.dart';
import 'package:mistrix_backend/src/core/config/app_config.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

Future<void> main() async {
  final config = AppConfig.fromEnvironment();
  final app = MistrixBackend(config: config);
  final server = await shelf_io.serve(app.handler, config.host, config.port);

  stdout.writeln(
    'Mistrix API running on http://${server.address.host}:${server.port}',
  );
}
