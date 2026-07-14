import 'package:flutter/material.dart';
import 'package:mistrix/features/admin/presentation/controllers/admin_controller.dart';
import 'package:mistrix/features/admin/presentation/pages/tabs/admin_clients_tab.dart';
import 'package:mistrix/features/admin/presentation/pages/tabs/admin_bookings_tab.dart';
import 'package:mistrix/features/admin/presentation/pages/tabs/admin_dashboard_tab.dart';
import 'package:mistrix/features/admin/presentation/pages/tabs/admin_services_tab.dart';
import 'package:mistrix/features/admin/presentation/pages/tabs/admin_technicians_tab.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({
    required this.controller,
    required this.onLogout,
    super.key,
  });

  final AdminController controller;
  final VoidCallback onLogout;

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      AdminDashboardTab(
        controller: widget.controller,
        onOpenSection: (index) => setState(() => _selectedIndex = index),
        onLogout: widget.onLogout,
      ),
      AdminBookingsTab(controller: widget.controller),
      AdminServicesTab(controller: widget.controller),
      AdminTechniciansTab(controller: widget.controller),
      AdminClientsTab(controller: widget.controller),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_note_outlined),
            selectedIcon: Icon(Icons.event_note_rounded),
            label: 'Bookings',
          ),
          NavigationDestination(
            icon: Icon(Icons.home_repair_service_outlined),
            selectedIcon: Icon(Icons.home_repair_service_rounded),
            label: 'Services',
          ),
          NavigationDestination(
            icon: Icon(Icons.engineering_outlined),
            selectedIcon: Icon(Icons.engineering_rounded),
            label: 'Techs',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline_rounded),
            selectedIcon: Icon(Icons.people_rounded),
            label: 'Clients',
          ),
        ],
      ),
    );
  }
}
