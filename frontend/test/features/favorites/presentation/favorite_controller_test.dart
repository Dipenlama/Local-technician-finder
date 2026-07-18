import 'package:flutter_test/flutter_test.dart';
import 'package:mistrix/features/favorites/data/repositories/in_memory_favorite_repository.dart';
import 'package:mistrix/features/favorites/presentation/controllers/favorite_controller.dart';
import 'package:mistrix/features/technicians/domain/entities/technician.dart';

void main() {
  test('client can add and remove a favourite technician', () async {
    final controller = FavoriteController(InMemoryFavoriteRepository());
    addTearDown(controller.dispose);
    const technician = Technician(
      id: 'tech-favourite-test',
      name: 'Favourite Technician',
      profession: 'Electrician',
      location: 'Kathmandu',
      rating: 4.9,
      reviewCount: 10,
      isAvailable: true,
    );

    expect(await controller.toggle(technician), isTrue);
    expect(controller.isFavorite(technician.id), isTrue);

    expect(await controller.toggle(technician), isTrue);
    expect(controller.isFavorite(technician.id), isFalse);
  });
}
