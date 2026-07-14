import 'package:flutter/material.dart';
import 'package:mistrix/core/widgets/mistrix_logo.dart';
import 'package:mistrix/features/admin/presentation/controllers/admin_controller.dart';

class AdminDashboardTab extends StatelessWidget {
  const AdminDashboardTab({
    required this.controller,
    required this.onOpenSection,
    required this.onLogout,
    super.key,
  });

  final AdminController controller;
  final ValueChanged<int> onOpenSection;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return RefreshIndicator(
            onRefresh: controller.load,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(18),
              children: [
                Row(
                  children: [
                    const MistrixLogo(compact: true),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'ADMIN',
                        style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w900),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Sign out',
                      onPressed: onLogout,
                      icon: const Icon(Icons.logout_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Text(
                  'Admin dashboard',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.8,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Manage the Mistrix marketplace from one place.',
                  style: TextStyle(color: Colors.blueGrey.shade600),
                ),
                const SizedBox(height: 24),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.35,
                  children: [
                    _MetricCard(
                      label: 'Services',
                      value: controller.services.length,
                      icon: Icons.home_repair_service_rounded,
                      color: const Color(0xFF3157D5),
                      onTap: () => onOpenSection(1),
                    ),
                    _MetricCard(
                      label: 'Technicians',
                      value: controller.technicians.length,
                      icon: Icons.engineering_rounded,
                      color: const Color(0xFF0F9D7A),
                      onTap: () => onOpenSection(2),
                    ),
                    _MetricCard(
                      label: 'Clients',
                      value: controller.clients.length,
                      icon: Icons.people_rounded,
                      color: const Color(0xFFFF8B3D),
                      onTap: () => onOpenSection(3),
                    ),
                    _MetricCard(
                      label: 'Available now',
                      value: controller.technicians
                          .where((item) => item.isAvailable)
                          .length,
                      icon: Icons.verified_rounded,
                      color: const Color(0xFF8B5CF6),
                      onTap: () => onOpenSection(2),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Text(
                  'Recently added technicians',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 12),
                ...controller.technicians.reversed.take(3).map(
                      (technician) => Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(technician.name.substring(0, 1)),
                          ),
                          title: Text(
                            technician.name,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text(
                              '${technician.profession} • ${technician.location}'),
                          trailing: Icon(
                            technician.isAvailable
                                ? Icons.check_circle
                                : Icons.schedule,
                            color: technician.isAvailable
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ),
                      ),
                    ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final int value;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 27),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$value',
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.blueGrey, fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
