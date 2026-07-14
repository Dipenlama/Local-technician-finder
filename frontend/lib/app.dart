import 'package:flutter/material.dart';
import 'package:mistrix/core/theme/app_theme.dart';
import 'package:mistrix/core/constants/app_constants.dart';
import 'package:mistrix/core/errors/app_exception.dart';
import 'package:mistrix/features/admin/presentation/controllers/admin_controller.dart';
import 'package:mistrix/features/admin/presentation/pages/admin_shell.dart';
import 'package:mistrix/features/auth/presentation/pages/login_page.dart';
import 'package:mistrix/features/auth/presentation/pages/signup_page.dart';
import 'package:mistrix/features/bookings/presentation/controllers/booking_controller.dart';
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
  late final BookingController _bookingController;
  late final AdminController _adminController;

  @override
  void initState() {
    super.initState();
    _controller = TechnicianController(widget.dependencies.getTechnicians)
      ..load();
    _bookingController = BookingController(
      widget.dependencies.createBooking,
      widget.dependencies.getBookings,
    )..load();
    _adminController = AdminController(widget.dependencies.adminRepository);
    if (widget.dependencies.authApiService == null) {
      _adminController.load();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _bookingController.dispose();
    _adminController.dispose();
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
          onLogin: _handleLogin,
          onCreateAccount: _openSignup,
        ),
      ),
      (route) => false,
    );
  }

  void _openSignup() {
    _navigatorKey.currentState!.push(
      MaterialPageRoute<void>(
        builder: (context) => SignupPage(onSignup: _handleSignup),
      ),
    );
  }

  void _openHome() {
    _controller.load();
    _bookingController.load();
    _adminController.loadServices();
    _navigatorKey.currentState!.pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (context) => HomeShell(
          technicianController: _controller,
          bookingController: _bookingController,
          adminController: _adminController,
          getTechnicians: widget.dependencies.getTechnicians,
          onLogout: _openLogin,
        ),
      ),
      (route) => false,
    );
  }

  Future<String?> _handleLogin(String email, String password) async {
    try {
      final authApi = widget.dependencies.authApiService;
      if (authApi == null) {
        if (email == AppConstants.adminEmail &&
            password == AppConstants.adminPassword) {
          _openAdmin();
        } else {
          _openHome();
        }
        return null;
      }
      final session = await authApi.login(email, password);
      if (session.role == 'admin') {
        _openAdmin();
      } else {
        _openHome();
      }
      return null;
    } on AppException catch (error) {
      return error.message;
    }
  }

  Future<String?> _handleSignup(
    String name,
    String email,
    String phone,
    String password,
  ) async {
    try {
      final authApi = widget.dependencies.authApiService;
      if (authApi != null) {
        await authApi.signup(
          name: name,
          email: email,
          phone: phone,
          password: password,
        );
      }
      _openHome();
      return null;
    } on AppException catch (error) {
      return error.message;
    }
  }

  void _openAdmin() {
    _adminController.load();
    _navigatorKey.currentState!.pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (context) => AdminShell(
          controller: _adminController,
          onLogout: _openLogin,
        ),
      ),
      (route) => false,
    );
  }
}
