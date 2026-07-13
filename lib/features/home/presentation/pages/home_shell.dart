import 'package:flutter/material.dart';
import 'package:mistrix/features/home/presentation/pages/tabs/bookings_tab.dart';
import 'package:mistrix/features/home/presentation/pages/tabs/dashboard_tab.dart';
import 'package:mistrix/features/home/presentation/pages/tabs/profile_tab.dart';
import 'package:mistrix/features/technicians/presentation/controllers/technician_controller.dart';
import 'package:mistrix/features/technicians/presentation/pages/technician_list_page.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({
    required this.technicianController,
    required this.onLogout,
    super.key,
  });

  final TechnicianController technicianController;
  final VoidCallback onLogout;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardTab(
        controller: widget.technicianController,
        onExplore: () => setState(() => _selectedIndex = 1),
      ),
      TechnicianListPage(
          controller: widget.technicianController, embedded: true),
      const BookingsTab(),
      ProfileTab(onLogout: widget.onLogout),
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
}
