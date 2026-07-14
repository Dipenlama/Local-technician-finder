import 'package:flutter/material.dart';
import 'package:mistrix/features/admin/presentation/controllers/admin_controller.dart';
import 'package:mistrix/features/auth/data/auth_api_service.dart';
import 'package:mistrix/features/bookings/presentation/controllers/booking_controller.dart';
import 'package:mistrix/features/bookings/presentation/pages/create_booking_page.dart';
import 'package:mistrix/features/home/presentation/pages/tabs/bookings_tab.dart';
import 'package:mistrix/features/home/presentation/pages/tabs/dashboard_tab.dart';
import 'package:mistrix/features/home/presentation/pages/tabs/profile_tab.dart';
import 'package:mistrix/features/home/presentation/pages/personal_information_page.dart';
import 'package:mistrix/features/home/presentation/widgets/service_category.dart';
import 'package:mistrix/features/technicians/presentation/controllers/technician_controller.dart';
import 'package:mistrix/features/technicians/presentation/pages/technician_list_page.dart';
import 'package:mistrix/features/technicians/presentation/pages/service_technicians_page.dart';
import 'package:mistrix/features/technicians/domain/use_cases/get_technicians.dart';
import 'package:mistrix/features/technicians/domain/entities/technician.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({
    required this.technicianController,
    required this.bookingController,
    required this.adminController,
    required this.getTechnicians,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.authApiService,
    required this.onLogout,
    super.key,
  });

  final TechnicianController technicianController;
  final BookingController bookingController;
  final AdminController adminController;
  final GetTechnicians getTechnicians;
  final String userName;
  final String userEmail;
  final String userPhone;
  final AuthApiService? authApiService;
  final VoidCallback onLogout;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _selectedIndex = 0;
  late String _userName;
  late String _userEmail;
  late String _userPhone;

  @override
  void initState() {
    super.initState();
    _userName = widget.userName;
    _userEmail = widget.userEmail;
    _userPhone = widget.userPhone;
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardTab(
        controller: widget.technicianController,
        adminController: widget.adminController,
        userName: _userName,
        onExplore: () => setState(() => _selectedIndex = 1),
        onServiceSelected: _openService,
        onBook: _openBooking,
      ),
      TechnicianListPage(
        controller: widget.technicianController,
        embedded: true,
        onBook: _openBooking,
      ),
      BookingsTab(controller: widget.bookingController),
      ProfileTab(
        userName: _userName,
        userEmail: _userEmail,
        userPhone: _userPhone,
        onEditPersonalInformation: _openPersonalInformation,
        onLogout: widget.onLogout,
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search_rounded),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_month_rounded),
            label: 'Bookings',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void _openService(ServiceCategoryData service) {
    if (service.query == null) {
      widget.technicianController.load();
      setState(() => _selectedIndex = 1);
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => ServiceTechniciansPage(
          serviceName: service.label,
          query: service.query!,
          getTechnicians: widget.getTechnicians,
          onBook: _openBooking,
        ),
      ),
    );
  }

  Future<void> _openBooking(Technician technician) async {
    final successful = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (context) => CreateBookingPage(
          technician: technician,
          controller: widget.bookingController,
        ),
      ),
    );
    if (!mounted || successful != true) return;

    setState(() => _selectedIndex = 2);
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  Future<void> _openPersonalInformation() async {
    final updated = await Navigator.of(context).push<AuthSession>(
      MaterialPageRoute<AuthSession>(
        builder: (context) => PersonalInformationPage(
          initialName: _userName,
          initialEmail: _userEmail,
          initialPhone: _userPhone,
          onSave: _saveProfile,
        ),
      ),
    );
    if (!mounted || updated == null) return;
    setState(() {
      _userName = updated.name;
      _userEmail = updated.email;
      _userPhone = updated.phone;
    });
  }

  Future<AuthSession> _saveProfile(
    String name,
    String email,
    String phone,
  ) async {
    final api = widget.authApiService;
    if (api != null) {
      return api.updateProfile(name: name, email: email, phone: phone);
    }
    return AuthSession(
      id: 'local-client',
      name: name,
      email: email,
      phone: phone,
      role: 'client',
    );
  }
}
