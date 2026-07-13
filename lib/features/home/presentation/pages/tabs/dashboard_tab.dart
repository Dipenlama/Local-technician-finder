import 'package:flutter/material.dart';
import 'package:mistrix/core/widgets/mistrix_logo.dart';
import 'package:mistrix/features/home/presentation/widgets/service_category.dart';
import 'package:mistrix/features/technicians/presentation/controllers/technician_controller.dart';
import 'package:mistrix/features/technicians/presentation/widgets/technician_card.dart';
import 'package:mistrix/features/technicians/domain/entities/technician.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({
    required this.controller,
    required this.onExplore,
    required this.onServiceSelected,
    required this.onBook,
    super.key,
  });

  final TechnicianController controller;
  final VoidCallback onExplore;
  final ValueChanged<ServiceCategoryData> onServiceSelected;
  final ValueChanged<Technician> onBook;

  static const _categories = [
    ServiceCategoryData(
      label: 'Electrician',
      query: 'Electrician',
      icon: Icons.electrical_services_rounded,
      color: Color(0xFFFFB547),
    ),
    ServiceCategoryData(
      label: 'Plumber',
      query: 'Plumber',
      icon: Icons.plumbing_rounded,
      color: Color(0xFF4A90E2),
    ),
    ServiceCategoryData(
      label: 'AC Repair',
      query: 'AC Technician',
      icon: Icons.ac_unit_rounded,
      color: Color(0xFF00A8A8),
    ),
    ServiceCategoryData(
      label: 'Computer',
      query: 'Computer Repair',
      icon: Icons.computer_rounded,
      color: Color(0xFF8B5CF6),
    ),
    ServiceCategoryData(
      label: 'Carpenter',
      query: 'Carpenter',
      icon: Icons.carpenter_rounded,
      color: Color(0xFFE46D5C),
    ),
    ServiceCategoryData(
      label: 'More',
      icon: Icons.grid_view_rounded,
      color: Color(0xFF637083),
    ),
  ];

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
                      IconButton.filledTonal(
                        onPressed: () {},
                        icon: const Badge(
                          smallSize: 7,
                          child: Icon(Icons.notifications_none_rounded),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 26),
                  Text('Good morning, Dipen 👋',
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
              sliver: SliverGrid.builder(
                itemCount: _categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.92,
                ),
                itemBuilder: (context, index) => ServiceCategory(
                  data: _categories[index],
                  onTap: () => onServiceSelected(_categories[index]),
                ),
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
              listenable: controller,
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
