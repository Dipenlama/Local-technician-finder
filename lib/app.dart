import 'package:flutter/material.dart';
import 'package:mistrix/core/theme/app_theme.dart';
import 'package:mistrix/features/auth/presentation/pages/login_page.dart';
import 'package:mistrix/features/auth/presentation/pages/signup_page.dart';
import 'package:mistrix/features/home/presentation/pages/home_shell.dart';
import 'package:mistrix/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:mistrix/features/technicians/presentation/controllers/technician_controller.dart';
import 'package:mistrix/injection_container.dart';

class MistrixApp extends StatefulWidget {
  const MistrixApp({required this.dependencies, super.key});

  final AppDependencies dependencies;

  @override
  State<MistrixApp> createState() => _MistrixAppState();
}

class _MistrixAppState extends State<MistrixApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  late final TechnicianController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TechnicianController(widget.dependencies.getTechnicians)
      ..load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'Mistrix',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: Builder(
        builder: (context) => OnboardingPage(onFinished: _openLogin),
      ),
    );
  }

  void _openLogin() {
    _navigatorKey.currentState!.pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (context) => LoginPage(
          onLogin: _openHome,
          onCreateAccount: _openSignup,
        ),
      ),
      (route) => false,
    );
  }

  void _openSignup() {
    _navigatorKey.currentState!.push(
      MaterialPageRoute<void>(
        builder: (context) => SignupPage(onSignup: _openHome),
      ),
    );
  }

  void _openHome() {
    _navigatorKey.currentState!.pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (context) => HomeShell(
          technicianController: _controller,
          onLogout: _openLogin,
        ),
      ),
      (route) => false,
    );
  }
}
