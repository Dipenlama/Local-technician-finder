import 'package:flutter/material.dart';
import 'package:mistrix/core/theme/app_colors.dart';
import 'package:mistrix/features/technicians/presentation/controllers/technician_controller.dart';
import 'package:mistrix/features/technicians/presentation/widgets/technician_card.dart';
import 'package:mistrix/features/technicians/domain/entities/technician.dart';
import 'package:mistrix/features/favorites/presentation/controllers/favorite_controller.dart';

class TechnicianListPage extends StatefulWidget {
  const TechnicianListPage({
    required this.controller,
    required this.favoriteController,
    this.embedded = false,
    this.onBook,
    super.key,
  });

  final TechnicianController controller;
  final FavoriteController favoriteController;
  final bool embedded;
  final ValueChanged<Technician>? onBook;

  @override
  State<TechnicianListPage> createState() => _TechnicianListPageState();
}

class _TechnicianListPageState extends State<TechnicianListPage> {
  @override
  Widget build(BuildContext context) {
    final content = SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.embedded) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondarySoft,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  'DISCOVER LOCAL EXPERTS',
                  style: TextStyle(
                    color: AppColors.success,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Explore technicians',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Search by skill, name, or location.',
                style: TextStyle(color: AppColors.inkMuted),
              ),
              const SizedBox(height: 18),
            ],
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0D24315E),
                    blurRadius: 16,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: TextField(
                onChanged: (value) => widget.controller.load(query: value),
                decoration: const InputDecoration(
                  hintText: 'Search skill, name, or location',
                  prefixIcon: Icon(Icons.search_rounded),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Recommended for you',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                ListenableBuilder(
                  listenable: widget.controller,
                  builder: (context, _) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${widget.controller.technicians.length} found',
                      style: const TextStyle(
                        color: AppColors.primaryDark,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListenableBuilder(
                listenable: Listenable.merge([
                  widget.controller,
                  widget.favoriteController,
                ]),
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
          padding: const EdgeInsets.only(bottom: 24),
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final technician = controller.technicians[index];
            return TechnicianCard(
              technician: technician,
              isFavorite: widget.favoriteController.isFavorite(technician.id),
              isFavoriteUpdating:
                  widget.favoriteController.updatingIds.contains(technician.id),
              onFavoriteToggle: () =>
                  widget.favoriteController.toggle(technician),
              onBook: widget.onBook == null
                  ? null
                  : () => widget.onBook!(technician),
            );
          },
        ),
    };
  }
}
