import 'package:flutter/material.dart';
import 'package:mistrix/features/admin/presentation/controllers/admin_controller.dart';
import 'package:mistrix/features/admin/presentation/widgets/admin_entity_dialogs.dart';

class AdminServicesTab extends StatelessWidget {
  const AdminServicesTab({required this.controller, super.key});

  final AdminController controller;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListenableBuilder(
        listenable: controller,
        builder: (context, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(
              title: 'Services',
              subtitle: '${controller.services.length} service categories',
              onAdd: () => _add(context),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
                itemCount: controller.services.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final service = controller.services[index];
                  return Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
                      leading: CircleAvatar(
                        child: Icon(_serviceIcon(service.name)),
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              service.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w800),
                            ),
                          ),
                          _StatusChip(active: service.isActive),
                        ],
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          '${service.description}\nFrom Rs. ${service.basePrice.toStringAsFixed(0)}',
                        ),
                      ),
                      isThreeLine: true,
                      trailing: PopupMenuButton<String>(
                        onSelected: (action) =>
                            _handleAction(context, action, index),
                        itemBuilder: (context) => const [
                          PopupMenuItem(value: 'edit', child: Text('Edit')),
                          PopupMenuItem(
                              value: 'toggle', child: Text('Enable / disable')),
                          PopupMenuItem(value: 'delete', child: Text('Delete')),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _add(BuildContext context) async {
    final service = await showServiceEditor(context);
    if (service != null) await controller.saveService(service);
  }

  Future<void> _handleAction(
      BuildContext context, String action, int index) async {
    final service = controller.services[index];
    if (action == 'edit') {
      final updated = await showServiceEditor(context, service: service);
      if (updated != null) await controller.saveService(updated);
    } else if (action == 'toggle') {
      await controller
          .saveService(service.copyWith(isActive: !service.isActive));
    } else if (action == 'delete' &&
        await confirmAdminDelete(context, service.name)) {
      await controller.deleteService(service.id);
    }
  }

  IconData _serviceIcon(String name) {
    final value = name.toLowerCase();
    if (value.contains('electric')) return Icons.electrical_services_rounded;
    if (value.contains('plumb')) return Icons.plumbing_rounded;
    if (value.contains('computer')) return Icons.computer_rounded;
    if (value.contains('carpenter')) return Icons.carpenter_rounded;
    if (value.contains('ac')) return Icons.ac_unit_rounded;
    return Icons.handyman_rounded;
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.title,
    required this.subtitle,
    required this.onAdd,
  });

  final String title;
  final String subtitle;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.blueGrey)),
              ],
            ),
          ),
          FilledButton.icon(
            onPressed: onAdd,
            style: FilledButton.styleFrom(
              minimumSize: const Size(0, 44),
              padding: const EdgeInsets.symmetric(horizontal: 14),
            ),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (active ? Colors.green : Colors.grey).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        active ? 'Active' : 'Disabled',
        style: TextStyle(
          color: active ? Colors.green.shade700 : Colors.grey.shade700,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
