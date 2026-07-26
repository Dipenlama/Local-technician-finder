import 'package:flutter/material.dart';
import 'package:mistrix/core/theme/app_colors.dart';
import 'package:mistrix/features/technicians/domain/use_cases/get_technicians.dart';
import 'package:mistrix/features/technicians/presentation/controllers/technician_controller.dart';
import 'package:mistrix/features/technicians/presentation/widgets/technician_card.dart';
import 'package:mistrix/features/technicians/domain/entities/technician.dart';
import 'package:mistrix/features/favorites/presentation/controllers/favorite_controller.dart';

class ServiceTechniciansPage extends StatefulWidget {
  const ServiceTechniciansPage({
    required this.serviceName,
    required this.query,
    required this.getTechnicians,
    required this.onBook,
    required this.favoriteController,
    super.key,
  });

  final String serviceName;
  final String query;
  final GetTechnicians getTechnicians;
  final ValueChanged<Technician> onBook;
  final FavoriteController favoriteController;

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
          listenable:
              Listenable.merge([_controller, widget.favoriteController]),
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
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
                    itemCount: _controller.technicians.length + 1,
                    separatorBuilder: (_, index) =>
                        SizedBox(height: index == 0 ? 20 : 12),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return _ResultsHeader(
                          serviceName: widget.serviceName,
                          count: _controller.technicians.length,
                        );
                      }
                      final technician = _controller.technicians[index - 1];
                      return TechnicianCard(
                        technician: technician,
                        isFavorite:
                            widget.favoriteController.isFavorite(technician.id),
                        isFavoriteUpdating: widget
                            .favoriteController.updatingIds
                            .contains(technician.id),
                        onFavoriteToggle: () =>
                            widget.favoriteController.toggle(technician),
                        onBook: () => widget.onBook(
                          technician,
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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
          decoration: BoxDecoration(
            color: AppColors.primarySoft,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            '$count ${count == 1 ? 'EXPERT' : 'EXPERTS'} AVAILABLE',
            style: const TextStyle(
              color: AppColors.primaryDark,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.7,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '$serviceName technicians',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          '$count trusted ${count == 1 ? 'professional' : 'professionals'} found near you.',
          style: const TextStyle(color: AppColors.inkMuted),
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
