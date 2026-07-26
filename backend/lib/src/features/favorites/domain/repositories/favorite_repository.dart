abstract interface class FavoriteRepository {
  Future<List<String>> findTechnicianIds(String userId);
  Future<void> add(String userId, String technicianId);
  Future<void> remove(String userId, String technicianId);
}
