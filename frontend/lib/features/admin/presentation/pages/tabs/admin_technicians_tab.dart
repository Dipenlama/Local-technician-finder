import 'package:flutter/material.dart';
import 'package:mistrix/features/admin/presentation/controllers/admin_controller.dart';
import 'package:mistrix/features/admin/presentation/widgets/admin_entity_dialogs.dart';

class AdminTechniciansTab extends StatelessWidget {
  const AdminTechniciansTab({required this.controller, super.key});

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
              count: controller.technicians.length,
              onAdd: () => _add(context),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
                itemCount: controller.technicians.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final technician = controller.technicians[index];
                  return Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.fromLTRB(14, 8, 6, 8),
                      leading: CircleAvatar(
                        child: Text(
                          technician.name.substring(0, 1),
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                      title: Text(
                        technician.name,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      subtitle: Text(
                        '${technician.profession} • ${technician.location}\n'
                        '★ ${technician.rating} · ${technician.reviewCount} reviews',
                      ),
                      isThreeLine: true,
                      trailing: PopupMenuButton<String>(
                        onSelected: (action) =>
                            _handleAction(context, action, index),
                        itemBuilder: (context) => const [
                          PopupMenuItem(value: 'edit', child: Text('Edit')),
                          PopupMenuItem(
                              value: 'availability',
                              child: Text('Change availability')),
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
    final technician = await showTechnicianEditor(context);
    if (technician != null) await controller.saveTechnician(technician);
  }

  Future<void> _handleAction(
      BuildContext context, String action, int index) async {
    final technician = controller.technicians[index];
    if (action == 'edit' || action == 'availability') {
      final updated =
          await showTechnicianEditor(context, technician: technician);
      if (updated != null) await controller.saveTechnician(updated);
    } else if (action == 'delete' &&
        await confirmAdminDelete(context, technician.name)) {
      await controller.deleteTechnician(technician.id);
    }
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.count, required this.onAdd});

  final int count;
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
                  'Technicians',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                ),
                Text('$count registered professionals',
                    style: const TextStyle(color: Colors.blueGrey)),
              ],
            ),
          ),
          FilledButton.icon(
            onPressed: onAdd,
            style: FilledButton.styleFrom(
              minimumSize: const Size(0, 44),
              padding: const EdgeInsets.symmetric(horizontal: 14),
            ),
            icon: const Icon(Icons.person_add_alt_1_rounded),
            label: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
