import 'package:flutter/material.dart';
import 'package:mistrix/features/technicians/domain/use_cases/get_technicians.dart';
import 'package:mistrix/features/technicians/presentation/controllers/technician_controller.dart';
import 'package:mistrix/features/technicians/presentation/widgets/technician_card.dart';
import 'package:mistrix/features/technicians/domain/entities/technician.dart';

class ServiceTechniciansPage extends StatefulWidget {
  const ServiceTechniciansPage({
    required this.serviceName,
    required this.query,
    required this.getTechnicians,
    required this.onBook,
    super.key,
  });

  final String serviceName;
  final String query;
  final GetTechnicians getTechnicians;
  final ValueChanged<Technician> onBook;

  @override
  State<ServiceTechniciansPage> createState() => _ServiceTechniciansPageState();
}

class _ServiceTechniciansPageState extends State<ServiceTechniciansPage> {
  late final TechnicianController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TechnicianController(widget.getTechnicians)
      ..load(query: widget.query);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.serviceName)),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            return switch (_controller.status) {
              TechnicianStatus.initial ||
              TechnicianStatus.loading =>
                const Center(child: CircularProgressIndicator()),
              TechnicianStatus.failure => _ErrorState(
                  message:
                      _controller.errorMessage ?? 'Unable to load technicians.',
                  onRetry: () => _controller.load(query: widget.query),
                ),
              TechnicianStatus.success when _controller.technicians.isEmpty =>
                _EmptyState(
                  serviceName: widget.serviceName,
                ),
              TechnicianStatus.success => RefreshIndicator(
                  onRefresh: () => _controller.load(query: widget.query),
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
                    itemCount: _controller.technicians.length + 1,
                    separatorBuilder: (_, index) =>
                        SizedBox(height: index == 0 ? 18 : 10),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return _ResultsHeader(
                          serviceName: widget.serviceName,
                          count: _controller.technicians.length,
                        );
                      }
                      return TechnicianCard(
                        technician: _controller.technicians[index - 1],
                        onBook: () => widget.onBook(
                          _controller.technicians[index - 1],
                        ),
                      );
                    },
                  ),
                ),
            };
          },
        ),
      ),
    );
  }
}

class _ResultsHeader extends StatelessWidget {
  const _ResultsHeader({required this.serviceName, required this.count});

  final String serviceName;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$serviceName technicians',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          '$count trusted ${count == 1 ? 'professional' : 'professionals'} found near you.',
          style: TextStyle(color: Colors.blueGrey.shade600),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.serviceName});

  final String serviceName;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.person_search_rounded, size: 72),
            const SizedBox(height: 16),
            Text(
              'No $serviceName technicians found',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Try again later or explore another service.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message),
          const SizedBox(height: 12),
          FilledButton(onPressed: onRetry, child: const Text('Try again')),
        ],
      ),
    );
  }
}
