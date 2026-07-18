import 'package:flutter/foundation.dart';
import 'package:mistrix/features/favorites/domain/repositories/favorite_repository.dart';
import 'package:mistrix/features/technicians/domain/entities/technician.dart';

class FavoriteController extends ChangeNotifier {
  FavoriteController(this._repository);

  final FavoriteRepository _repository;

  List<Technician> favorites = const [];
  Set<String> updatingIds = const {};
  bool isLoading = false;
  String? errorMessage;

  bool isFavorite(String technicianId) =>
      favorites.any((technician) => technician.id == technicianId);

  Future<void> load() async {
    isLoading = true;
    notifyListeners();
    try {
      favorites = await _repository.getFavorites();
      errorMessage = null;
    } on Exception catch (error) {
      errorMessage = error.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> toggle(Technician technician) async {
    updatingIds = {...updatingIds, technician.id};
    notifyListeners();
    try {
      if (isFavorite(technician.id)) {
        await _repository.removeFavorite(technician.id);
      } else {
        await _repository.addFavorite(technician);
      }
      favorites = await _repository.getFavorites();
      errorMessage = null;
      return true;
    } on Exception catch (error) {
      errorMessage = error.toString();
      return false;
    } finally {
      updatingIds = {...updatingIds}..remove(technician.id);
      notifyListeners();
    }
  }
}
