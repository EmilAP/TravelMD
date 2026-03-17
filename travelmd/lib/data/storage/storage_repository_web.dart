import 'package:travelmd/data/storage/storage_repository_base.dart';
import 'package:travelmd/domain/models/traveler_profile.dart';
import 'package:travelmd/domain/models/trip.dart';

class MemoryStorageRepository implements StorageRepositoryBase {
  int _tripSeq = 0;
  int _travelerSeq = 0;
  int _planSeq = 0;

  final Map<int, Trip> _trips = {};
  final Map<int, TravelerProfile> _travelers = {};
  final Map<int, StoredPlanSelection> _plans = {};
  final Map<int, Map<String, bool>> _checklistByPlan = {};

  @override
  Future<int> saveTrip(Trip trip) async {
    final id = ++_tripSeq;
    _trips[id] = trip;
    return id;
  }

  @override
  Future<List<Trip>> listTrips() async {
    return _trips.values.toList(growable: false);
  }

  @override
  Future<Trip?> getTrip(int id) async {
    return _trips[id];
  }

  @override
  Future<void> deleteTrip(int id) async {
    _trips.remove(id);
    final planIds = _plans.values
        .where((plan) => plan.tripId == id)
        .map((plan) => plan.id)
        .toList(growable: false);
    for (final planId in planIds) {
      _plans.remove(planId);
      _checklistByPlan.remove(planId);
    }
  }

  @override
  Future<int> saveTraveler(TravelerProfile traveler) async {
    final id = ++_travelerSeq;
    _travelers[id] = traveler;
    return id;
  }

  @override
  Future<List<TravelerProfile>> listTravelers() async {
    return _travelers.values.toList(growable: false);
  }

  @override
  Future<TravelerProfile?> getTraveler(int id) async {
    return _travelers[id];
  }

  @override
  Future<void> deleteTraveler(int id) async {
    _travelers.remove(id);
    final planIds = _plans.values
        .where((plan) => plan.travelerId == id)
        .map((plan) => plan.id)
        .toList(growable: false);
    for (final planId in planIds) {
      _plans.remove(planId);
      _checklistByPlan.remove(planId);
    }
  }

  @override
  Future<int> savePlanSelection({
    required int tripId,
    required int travelerId,
    required List<String> selectedCardIds,
  }) async {
    final existing = _plans.values.where((plan) =>
        plan.tripId == tripId && plan.travelerId == travelerId);
    if (existing.isNotEmpty) {
      final plan = existing.first;
      _plans[plan.id] = StoredPlanSelection(
        id: plan.id,
        tripId: tripId,
        travelerId: travelerId,
        selectedCardIds: List.unmodifiable(selectedCardIds),
      );
      return plan.id;
    }

    final id = ++_planSeq;
    _plans[id] = StoredPlanSelection(
      id: id,
      tripId: tripId,
      travelerId: travelerId,
      selectedCardIds: List.unmodifiable(selectedCardIds),
    );
    return id;
  }

  @override
  Future<StoredPlanSelection?> loadPlanSelection({
    required int tripId,
    required int travelerId,
  }) async {
    for (final plan in _plans.values) {
      if (plan.tripId == tripId && plan.travelerId == travelerId) {
        return plan;
      }
    }
    return null;
  }

  @override
  Future<void> saveChecklistItemState({
    required int planSelectionId,
    required String itemId,
    required bool isDone,
  }) async {
    final map = _checklistByPlan.putIfAbsent(planSelectionId, () => {});
    map[itemId] = isDone;
  }

  @override
  Future<Map<String, bool>> loadChecklistStates(int planSelectionId) async {
    final map = _checklistByPlan[planSelectionId] ?? {};
    return Map<String, bool>.from(map);
  }
}
