import 'package:flutter/material.dart';
import 'package:mistrix/features/favorites/presentation/controllers/favorite_controller.dart';
import 'package:mistrix/features/technicians/domain/entities/technician.dart';
import 'package:mistrix/features/technicians/presentation/widgets/technician_card.dart';

class FavoriteTechniciansPage extends StatelessWidget {
  const FavoriteTechniciansPage({
    required this.controller,
    required this.onBook,
    super.key,
  });

  final FavoriteController controller;
  final ValueChanged<Technician> onBook;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favourite technicians')),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            if (controller.isLoading && controller.favorites.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.errorMessage != null &&
                controller.favorites.isEmpty) {
              return Center(
                child: FilledButton.icon(
                  onPressed: controller.load,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Try again'),
                ),
              );
            }
            if (controller.favorites.isEmpty) {
              return const _EmptyFavorites();
            }
            return RefreshIndicator(
              onRefresh: controller.load,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
                itemCount: controller.favorites.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final technician = controller.favorites[index];
                  return TechnicianCard(
                    technician: technician,
                    isFavorite: true,
                    isFavoriteUpdating:
                        controller.updatingIds.contains(technician.id),
                    onFavoriteToggle: () => controller.toggle(technician),
                    onBook: technician.isAvailable
                        ? () => onBook(technician)
                        : null,
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  const _EmptyFavorites();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.favorite_border_rounded, size: 68),
          SizedBox(height: 16),
          Text('No favourite technicians', style: TextStyle(fontSize: 18)),
          SizedBox(height: 6),
          Text('Tap the heart on a technician to save them.'),
        ],
      ),
    );
  }
}
