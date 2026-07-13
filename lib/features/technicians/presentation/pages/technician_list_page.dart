import 'package:flutter/material.dart';
import 'package:mistrix/features/technicians/presentation/controllers/technician_controller.dart';
import 'package:mistrix/features/technicians/presentation/widgets/technician_card.dart';

class TechnicianListPage extends StatefulWidget {
  const TechnicianListPage({
    required this.controller,
    this.embedded = false,
    super.key,
  });

  final TechnicianController controller;
  final bool embedded;

  @override
  State<TechnicianListPage> createState() => _TechnicianListPageState();
}

class _TechnicianListPageState extends State<TechnicianListPage> {
  @override
  Widget build(BuildContext context) {
    final content = SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.embedded) ...[
              Text(
                'Explore technicians',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                'Search by skill, name, or location.',
                style: TextStyle(color: Colors.blueGrey.shade600),
              ),
              const SizedBox(height: 18),
            ],
            TextField(
              onChanged: (value) => widget.controller.load(query: value),
              decoration: const InputDecoration(
                hintText: 'Search skill, name, or location',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Recommended technicians',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListenableBuilder(
                listenable: widget.controller,
                builder: (context, _) => _buildContent(),
              ),
            ),
          ],
        ),
      ),
    );

    if (widget.embedded) return content;

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mistrix'),
            Text('Find trusted help nearby', style: TextStyle(fontSize: 13)),
          ],
        ),
      ),
      body: content,
    );
  }

  Widget _buildContent() {
    final controller = widget.controller;

    return switch (controller.status) {
      TechnicianStatus.initial ||
      TechnicianStatus.loading =>
        const Center(child: CircularProgressIndicator()),
      TechnicianStatus.failure => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(controller.errorMessage ?? 'Something went wrong.'),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: controller.load,
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
      TechnicianStatus.success when controller.technicians.isEmpty =>
        const Center(child: Text('No technicians found.')),
      TechnicianStatus.success => ListView.separated(
          itemCount: controller.technicians.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            return TechnicianCard(technician: controller.technicians[index]);
          },
        ),
    };
  }
}
