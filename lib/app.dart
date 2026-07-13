import 'package:flutter/material.dart';
import 'package:mistrix/core/theme/app_theme.dart';
import 'package:mistrix/features/technicians/presentation/controllers/technician_controller.dart';
import 'package:mistrix/features/technicians/presentation/pages/technician_list_page.dart';
import 'package:mistrix/injection_container.dart';

class MistrixApp extends StatefulWidget {
  const MistrixApp({required this.dependencies, super.key});

  final AppDependencies dependencies;

  @override
  State<MistrixApp> createState() => _MistrixAppState();
}

class _MistrixAppState extends State<MistrixApp> {
  late final TechnicianController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TechnicianController(widget.dependencies.getTechnicians)..load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mistrix',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: TechnicianListPage(controller: _controller),
    );
  }
}
