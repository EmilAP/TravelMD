import 'package:travelmd/domain/models/traveler_profile.dart';
import 'package:travelmd/domain/models/trip.dart';

class StoredPlanSelection {
  final int id;
  final int tripId;
  final int travelerId;
  final List<String> selectedCardIds;

  const StoredPlanSelection({
    required this.id,
    required this.tripId,
    required this.travelerId,
    required this.selectedCardIds,
  });
}

abstract class StorageRepositoryBase {
  Future<int> saveTrip(Trip trip);
  Future<List<Trip>> listTrips();
  Future<Trip?> getTrip(int id);
  Future<void> deleteTrip(int id);

  Future<int> saveTraveler(TravelerProfile traveler);
  Future<List<TravelerProfile>> listTravelers();
  Future<TravelerProfile?> getTraveler(int id);
  Future<void> deleteTraveler(int id);

  Future<int> savePlanSelection({
    required int tripId,
    required int travelerId,
    required List<String> selectedCardIds,
  });

  Future<StoredPlanSelection?> loadPlanSelection({
    required int tripId,
    required int travelerId,
  });

  Future<void> saveChecklistItemState({
    required int planSelectionId,
    required String itemId,
    required bool isDone,
  });

  Future<Map<String, bool>> loadChecklistStates(int planSelectionId);
}
