import 'package:isar/isar.dart';
import 'package:travelmd/domain/models/trip.dart';
import 'package:travelmd/domain/models/traveler_profile.dart';
import 'package:travelmd/data/storage/entities/trip_entity.dart';
import 'package:travelmd/data/storage/entities/traveler_entity.dart';
import 'package:travelmd/data/storage/entities/plan_selection_entity.dart';
import 'package:travelmd/data/storage/entities/checklist_state_entity.dart';
import 'package:travelmd/data/storage/storage_repository_base.dart';

/// Repository for persisting and retrieving trip, traveler, and plan data.
class StorageRepository implements StorageRepositoryBase {
  final Isar _isar;

  StorageRepository(this._isar);

  // ===== TRIPS =====

  /// Save a trip to the database. Returns the trip ID.
  Future<int> saveTrip(Trip trip) async {
    final entity = TripEntity()
      ..originCountry = trip.originCountry
      ..destinationCountry = trip.destinationCountry
      ..departDate = trip.departDate
      ..returnDate = trip.returnDate
      ..transitCountries = trip.transitCountries
      ..createdAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.tripEntitys.put(entity);
    });

    return entity.id;
  }

  /// List all saved trips.
  Future<List<Trip>> listTrips() async {
    final entities = await _isar.tripEntitys.where().findAll();
    return entities.map(_tripEntityToDomain).toList();
  }

  /// Get a single trip by ID.
  Future<Trip?> getTrip(int id) async {
    final entity = await _isar.tripEntitys.get(id);
    return entity != null ? _tripEntityToDomain(entity) : null;
  }

  /// Delete a trip by ID (and associated plan selections).
  Future<void> deleteTrip(int id) async {
    await _isar.writeTxn(() async {
      await _isar.tripEntitys.delete(id);
      // Also delete associated plan selections
      final plans = await _isar.planSelectionEntitys.where().findAll();
      for (final plan in plans) {
        if (plan.tripId == id) {
          await _isar.planSelectionEntitys.delete(plan.id);
          // Delete associated checklist states
          final states = await _isar.checklistStateEntitys.where().findAll();
          for (final state in states) {
            if (state.planSelectionId == plan.id) {
              await _isar.checklistStateEntitys.delete(state.id);
            }
          }
        }
      }
    });
  }

  // ===== TRAVELERS =====

  /// Save a traveler to the database. Returns the traveler ID.
  Future<int> saveTraveler(TravelerProfile traveler) async {
    final entity = TravelerEntity()
      ..nickname = traveler.nickname
      ..ageYears = traveler.ageYears
      ..isPregnant = traveler.isPregnant
      ..isImmunocompromised = traveler.isImmunocompromised
      ..isVFR = traveler.isVFR
      ..purpose = traveler.purpose
      ..createdAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.travelerEntitys.put(entity);
    });

    return entity.id;
  }

  /// List all saved travelers.
  Future<List<TravelerProfile>> listTravelers() async {
    final entities = await _isar.travelerEntitys.where().findAll();
    return entities.map(_travelerEntityToDomain).toList();
  }

  /// Get a single traveler by ID.
  Future<TravelerProfile?> getTraveler(int id) async {
    final entity = await _isar.travelerEntitys.get(id);
    return entity != null ? _travelerEntityToDomain(entity) : null;
  }

  /// Delete a traveler by ID (and associated plan selections).
  Future<void> deleteTraveler(int id) async {
    await _isar.writeTxn(() async {
      await _isar.travelerEntitys.delete(id);
      // Also delete associated plan selections
      final plans = await _isar.planSelectionEntitys.where().findAll();
      for (final plan in plans) {
        if (plan.travelerId == id) {
          await _isar.planSelectionEntitys.delete(plan.id);
          // Delete associated checklist states
          final states = await _isar.checklistStateEntitys.where().findAll();
          for (final state in states) {
            if (state.planSelectionId == plan.id) {
              await _isar.checklistStateEntitys.delete(state.id);
            }
          }
        }
      }
    });
  }

  // ===== PLAN SELECTIONS & CHECKLIST STATE =====

  /// Save plan selection (card IDs) for a trip+traveler pair. Returns the plan selection ID.
  Future<int> savePlanSelection({
    required int tripId,
    required int travelerId,
    required List<String> selectedCardIds,
  }) async {
    // Check if already exists
    final allSelections = await _isar.planSelectionEntitys.where().findAll();
    PlanSelectionEntity? existing;
    try {
      existing = allSelections.firstWhere(
        (e) => e.tripId == tripId && e.travelerId == travelerId,
      );
    } catch (e) {
      existing = null;
    }

    late PlanSelectionEntity entity;
    if (existing != null) {
      entity = existing
        ..selectedCardIds = selectedCardIds
        ..updatedAt = DateTime.now();
    } else {
      entity = PlanSelectionEntity()
        ..tripId = tripId
        ..travelerId = travelerId
        ..selectedCardIds = selectedCardIds
        ..createdAt = DateTime.now()
        ..updatedAt = DateTime.now();
    }

    await _isar.writeTxn(() async {
      await _isar.planSelectionEntitys.put(entity);
    });

    return entity.id;
  }

  /// Load plan selection for a trip+traveler pair.
  Future<StoredPlanSelection?> loadPlanSelection({
    required int tripId,
    required int travelerId,
  }) async {
    final all = await _isar.planSelectionEntitys.where().findAll();
    try {
      final entity = all.firstWhere((e) => e.tripId == tripId && e.travelerId == travelerId);
      return StoredPlanSelection(
        id: entity.id,
        tripId: entity.tripId,
        travelerId: entity.travelerId,
        selectedCardIds: List.unmodifiable(entity.selectedCardIds),
      );
    } catch (e) {
      return null;
    }
  }

  /// Save checklist item state (isDone).
  Future<void> saveChecklistItemState({
    required int planSelectionId,
    required String itemId,
    required bool isDone,
  }) async {
    // Check if already exists
    final all = await _isar.checklistStateEntitys.where().findAll();
    ChecklistStateEntity? existing;
    try {
      existing = all.firstWhere(
        (e) => e.planSelectionId == planSelectionId && e.checklistItemId == itemId,
      );
    } catch (e) {
      existing = null;
    }

    late ChecklistStateEntity entity;
    if (existing != null) {
      entity = existing..isDone = isDone;
    } else {
      entity = ChecklistStateEntity()
        ..planSelectionId = planSelectionId
        ..checklistItemId = itemId
        ..isDone = isDone;
    }

    await _isar.writeTxn(() async {
      await _isar.checklistStateEntitys.put(entity);
    });
  }

  /// Load all checklist states for a plan selection.
  Future<Map<String, bool>> loadChecklistStates(int planSelectionId) async {
    final all = await _isar.checklistStateEntitys.where().findAll();
    final states = all.where((s) => s.planSelectionId == planSelectionId).toList();
    return {for (final state in states) state.checklistItemId: state.isDone};
  }

  // ===== CONVERSION HELPERS =====

  Trip _tripEntityToDomain(TripEntity entity) {
    return Trip(
      originCountry: entity.originCountry,
      destinationCountry: entity.destinationCountry,
      departDate: entity.departDate,
      returnDate: entity.returnDate,
      transitCountries: entity.transitCountries,
    );
  }

  TravelerProfile _travelerEntityToDomain(TravelerEntity entity) {
    return TravelerProfile(
      nickname: entity.nickname,
      ageYears: entity.ageYears,
      isPregnant: entity.isPregnant,
      isImmunocompromised: entity.isImmunocompromised,
      isVFR: entity.isVFR,
      purpose: entity.purpose,
    );
  }
}
