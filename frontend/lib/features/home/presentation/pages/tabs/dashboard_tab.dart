import 'package:flutter/material.dart';
import 'package:mistrix/core/widgets/mistrix_logo.dart';
import 'package:mistrix/features/admin/domain/entities/admin_service.dart';
import 'package:mistrix/features/admin/presentation/controllers/admin_controller.dart';
import 'package:mistrix/features/home/presentation/widgets/service_category.dart';
import 'package:mistrix/features/notifications/presentation/controllers/notification_controller.dart';
import 'package:mistrix/features/favorites/presentation/controllers/favorite_controller.dart';
import 'package:mistrix/features/technicians/presentation/controllers/technician_controller.dart';
import 'package:mistrix/features/technicians/presentation/widgets/technician_card.dart';
import 'package:mistrix/features/technicians/domain/entities/technician.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({
    required this.controller,
    required this.adminController,
    required this.userName,
    required this.notificationController,
    required this.favoriteController,
    required this.onExplore,
    required this.onServiceSelected,
    required this.onBook,
    required this.onNotifications,
    super.key,
  });

  final TechnicianController controller;
  final AdminController adminController;
  final String userName;
  final NotificationController notificationController;
  final FavoriteController favoriteController;
  final VoidCallback onExplore;
  final ValueChanged<ServiceCategoryData> onServiceSelected;
  final ValueChanged<Technician> onBook;
  final VoidCallback onNotifications;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: controller.load,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
              sliver: SliverList.list(
                children: [
                  Row(
                    children: [
                      const MistrixLogo(compact: true),
                      const Spacer(),
                      ListenableBuilder(
                        listenable: notificationController,
                        builder: (context, _) => IconButton.filledTonal(
                          onPressed: onNotifications,
                          icon: Badge.count(
                            count: notificationController.unreadCount,
                            isLabelVisible:
                                notificationController.unreadCount > 0,
                            child: const Icon(
                              Icons.notifications_none_rounded,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 26),
                  Text('Good morning, $userName 👋',
                      style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 4),
                  Text(
                    'What service do you need?',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                  ),
                  const SizedBox(height: 18),
                  InkWell(
                    onTap: onExplore,
                    borderRadius: BorderRadius.circular(16),
                    child: const IgnorePointer(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search for a service',
                          prefixIcon: Icon(Icons.search_rounded),
                          suffixIcon: Icon(Icons.tune_rounded),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3157D5), Color(0xFF5679EA)],
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'First booking offer',
                                style: TextStyle(color: Colors.white70),
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                'Get 20% off your first service',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 13),
                              FilledButton.tonal(
                                onPressed: onExplore,
                                style: FilledButton.styleFrom(
                                  minimumSize: const Size(120, 40),
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xFF3157D5),
                                ),
                                child: const Text('Book now'),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.home_repair_service_rounded,
                            color: Colors.white, size: 76),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  _SectionHeader(
                      title: 'Popular services',
                      action: 'View all',
                      onTap: onExplore),
                  const SizedBox(height: 14),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              sliver: ListenableBuilder(
                listenable: adminController,
                builder: (context, _) {
                  final categories = _serviceCategories();
                  return SliverGrid.builder(
                    itemCount: categories.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.92,
                    ),
                    itemBuilder: (context, index) => ServiceCategory(
                      data: categories[index],
                      onTap: () => onServiceSelected(categories[index]),
                    ),
                  );
                },
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(18, 28, 18, 14),
              sliver: SliverToBoxAdapter(
                child: _SectionHeader(
                    title: 'Top technicians',
                    action: 'See all',
                    onTap: onExplore),
              ),
            ),
            ListenableBuilder(
              listenable: Listenable.merge([controller, favoriteController]),
              builder: (context, _) {
                if (controller.status == TechnicianStatus.loading) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  );
                }
                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
                  sliver: SliverList.separated(
                    itemCount: controller.technicians.take(3).length,
                    itemBuilder: (context, index) => TechnicianCard(
                      technician: controller.technicians[index],
                      isFavorite: favoriteController.isFavorite(
                        controller.technicians[index].id,
                      ),
                      isFavoriteUpdating: favoriteController.updatingIds
                          .contains(controller.technicians[index].id),
                      onFavoriteToggle: () => favoriteController.toggle(
                        controller.technicians[index],
                      ),
                      onBook: () => onBook(controller.technicians[index]),
                    ),
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  List<ServiceCategoryData> _serviceCategories() {
    final services = adminController.services.isEmpty
        ? _defaultServices
        : adminController.services;
    final categories = services
        .where((service) => service.isActive)
        .take(5)
        .map(_categoryFromService)
        .toList(growable: true);
    categories.add(
      const ServiceCategoryData(
        label: 'More',
        icon: Icons.grid_view_rounded,
        color: Color(0xFF637083),
      ),
    );
    return categories;
  }

  static const _defaultServices = [
    AdminService(
      id: 'service-001',
      name: 'Electrician',
      description: '',
      basePrice: 850,
      isActive: true,
    ),
    AdminService(
      id: 'service-002',
      name: 'Plumber',
      description: '',
      basePrice: 750,
      isActive: true,
    ),
    AdminService(
      id: 'service-003',
      name: 'AC Repair',
      description: '',
      basePrice: 1000,
      isActive: true,
    ),
    AdminService(
      id: 'service-004',
      name: 'Computer Repair',
      description: '',
      basePrice: 1200,
      isActive: true,
    ),
    AdminService(
      id: 'service-005',
      name: 'Carpenter',
      description: '',
      basePrice: 900,
      isActive: true,
    ),
  ];

  ServiceCategoryData _categoryFromService(AdminService service) {
    final name = service.name.toLowerCase();
    final icon = switch (name) {
      final value when value.contains('electric') =>
        Icons.electrical_services_rounded,
      final value when value.contains('plumb') => Icons.plumbing_rounded,
      final value when value.contains('computer') => Icons.computer_rounded,
      final value when value.contains('carpenter') => Icons.carpenter_rounded,
      final value when value.contains('ac') => Icons.ac_unit_rounded,
      _ => Icons.handyman_rounded,
    };
    const colors = [
      Color(0xFFFFB547),
      Color(0xFF4A90E2),
      Color(0xFF00A8A8),
      Color(0xFF8B5CF6),
      Color(0xFFE46D5C),
    ];
    final source = adminController.services.isEmpty
        ? _defaultServices
        : adminController.services;
    final index = source.indexOf(service);
    return ServiceCategoryData(
      label: service.name,
      query: name.contains('ac repair') ? 'AC Technician' : service.name,
      icon: icon,
      color: colors[index.abs() % colors.length],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(
      {required this.title, required this.action, required this.onTap});

  final String title;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w800)),
        const Spacer(),
        TextButton(onPressed: onTap, child: Text(action)),
      ],
    );
  }
}
