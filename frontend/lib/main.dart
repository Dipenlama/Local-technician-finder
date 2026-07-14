import 'package:flutter/material.dart';
import 'package:mistrix/app.dart';
import 'package:mistrix/injection_container.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final dependencies = configureDependencies();
  runApp(MistrixApp(dependencies: dependencies));
}
