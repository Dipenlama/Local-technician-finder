import 'package:flutter/material.dart';
import 'package:mistrix/features/admin/presentation/controllers/admin_controller.dart';
import 'package:mistrix/features/admin/presentation/widgets/admin_entity_dialogs.dart';

class AdminClientsTab extends StatelessWidget {
  const AdminClientsTab({required this.controller, super.key});

  final AdminController controller;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListenableBuilder(
        listenable: controller,
        builder: (context, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Clients',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                        Text(
                          '${controller.clients.length} customer accounts',
                          style: const TextStyle(color: Colors.blueGrey),
                        ),
                      ],
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: () => _add(context),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(0, 44),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                    ),
                    icon: const Icon(Icons.person_add_alt_rounded),
                    label: const Text('Add'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
                itemCount: controller.clients.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final client = controller.clients[index];
                  return Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.fromLTRB(14, 8, 6, 8),
                      leading: CircleAvatar(
                        child: Text(
                          client.name.substring(0, 1),
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              client.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w800),
                            ),
                          ),
                          Icon(
                            client.isActive ? Icons.check_circle : Icons.block,
                            color: client.isActive
                                ? Colors.green
                                : Colors.redAccent,
                            size: 18,
                          ),
                        ],
                      ),
                      subtitle: Text('${client.email}\n${client.phone}'),
                      isThreeLine: true,
                      trailing: PopupMenuButton<String>(
                        onSelected: (action) =>
                            _handleAction(context, action, index),
                        itemBuilder: (context) => const [
                          PopupMenuItem(value: 'edit', child: Text('Edit')),
                          PopupMenuItem(
                              value: 'toggle',
                              child: Text('Activate / suspend')),
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
    final client = await showClientEditor(context);
    if (client != null) await controller.saveClient(client);
  }

  Future<void> _handleAction(
      BuildContext context, String action, int index) async {
    final client = controller.clients[index];
    if (action == 'edit') {
      final updated = await showClientEditor(context, client: client);
      if (updated != null) await controller.saveClient(updated);
    } else if (action == 'toggle') {
      await controller.saveClient(client.copyWith(isActive: !client.isActive));
    } else if (action == 'delete' &&
        await confirmAdminDelete(context, client.name)) {
      await controller.deleteClient(client.id);
    }
  }
}
