import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelmd/data/repositories/content_repository.dart';
import 'package:travelmd/data/storage/isar_service.dart';
import 'package:travelmd/data/storage/storage_repository.dart';
import 'package:travelmd/domain/models/trip.dart';
import 'package:travelmd/domain/models/traveler_profile.dart';
import 'package:travelmd/domain/models/public_plan.dart';
import 'package:travelmd/domain/rules/rabies_plan_builder.dart';

/// Storage repository provider (async, initializes Isar).
final storageRepositoryProvider = FutureProvider<StorageRepository>((ref) async {
  final isar = await IsarService.getInstance();
  return StorageRepository(isar);
});

/// Content repository (singleton, loads YAML once).
final contentRepositoryProvider = Provider<ContentRepository>((ref) {
  return ContentRepository();
});

/// Current trip (user's travel destination and dates).
final tripProvider = StateNotifierProvider<_TripNotifier, Trip?>((ref) {
  return _TripNotifier();
});

class _TripNotifier extends StateNotifier<Trip?> {
  _TripNotifier() : super(null);

  void setTrip(Trip trip, {int? isarId}) {
    state = trip;
    if (isarId != null) {
      // Store ID separately via ref in the widget
    }
  }
}

/// Isar ID for current trip (used when persisting plan selection).
final tripIsarIdProvider = StateNotifierProvider<_TripIsarIdNotifier, int?>((ref) {
  return _TripIsarIdNotifier();
});

class _TripIsarIdNotifier extends StateNotifier<int?> {
  _TripIsarIdNotifier() : super(null);

  void setId(int? id) {
    state = id;
  }
}

/// Current traveler (demographics and health info).
final travelerProvider = StateNotifierProvider<_TravelerNotifier, TravelerProfile?>(
  (ref) {
    return _TravelerNotifier();
  },
);

class _TravelerNotifier extends StateNotifier<TravelerProfile?> {
  _TravelerNotifier() : super(null);

  void setTraveler(TravelerProfile traveler, {int? isarId}) {
    state = traveler;
    if (isarId != null) {
      // Store ID separately via ref in the widget
    }
  }
}

/// Isar ID for current traveler (used when persisting plan selection).
final travelerIsarIdProvider = StateNotifierProvider<_TravelerIsarIdNotifier, int?>((ref) {
  return _TravelerIsarIdNotifier();
});

class _TravelerIsarIdNotifier extends StateNotifier<int?> {
  _TravelerIsarIdNotifier() : super(null);

  void setId(int? id) {
    state = id;
  }
}

/// Current plan (guidance cards + checklist).
final planProvider = StateNotifierProvider<_PlanNotifier, PublicPlan>((ref) {
  return _PlanNotifier();
});

class _PlanNotifier extends StateNotifier<PublicPlan> {
  _PlanNotifier()
      : super(PublicPlan(
          id: 'empty',
          tripId: '',
          travelerId: '',
          title: 'Your Travel Plan',
          summary: 'Build a plan to get started',
        ));

  void updatePlan(PublicPlan newPlan) {
    state = newPlan;
  }
}

/// Checklist item completion state (item ID -> isDone).
/// Scoped to current plan + persisted to storage.
final checklistStateProvider = StateNotifierProvider<_ChecklistStateNotifier, Map<String, bool>>((ref) {
  return _ChecklistStateNotifier();
});

class _ChecklistStateNotifier extends StateNotifier<Map<String, bool>> {
  _ChecklistStateNotifier() : super({});

  void toggleItem(String itemId) {
    state = {
      ...state,
      itemId: !(state[itemId] ?? false),
    };
  }

  void setItemState(String itemId, bool isDone) {
    state = {
      ...state,
      itemId: isDone,
    };
  }

  void loadState(Map<String, bool> newState) {
    state = newState;
  }

  void clear() {
    state = {};
  }
}

/// List of saved trips.
final savedTripsProvider = FutureProvider<List<Trip>>((ref) async {
  final storage = await ref.watch(storageRepositoryProvider.future);
  return storage.listTrips();
});

/// List of saved travelers.
final savedTravelersProvider = FutureProvider<List<TravelerProfile>>((ref) async {
  final storage = await ref.watch(storageRepositoryProvider.future);
  return storage.listTravelers();
});

/// Generate prevention-first plan from trip + traveler.
final preventionPlanProvider = FutureProvider<PublicPlan>((ref) async {
  final trip = ref.watch(tripProvider);
  final traveler = ref.watch(travelerProvider);
  final contentRepo = ref.watch(contentRepositoryProvider);

  if (trip == null || traveler == null) {
    return PublicPlan(
      id: 'empty',
      tripId: '',
      travelerId: '',
      title: 'Your Travel Plan',
      summary: 'Complete trip and traveler info to generate your plan.',
    );
  }

  // Load content first
  await contentRepo.loadAll();

  // Build plan patch
  const builder = RabiesPlanBuilder();
  final patch = await builder.build(
    trip: trip,
    traveler: traveler,
    contentRepo: contentRepo,
  );

  // Create new plan from patch
  return PublicPlan(
    id: 'plan_${trip.destinationCountry}_${traveler.ageYears}',
    tripId: 'trip_${trip.destinationCountry}',
    travelerId: 'traveler_${traveler.ageYears}',
    title: 'Your Travel Health Plan',
    summary: 'Prevention-first guidance for your trip to ${trip.destinationCountry}',
    cards: patch.cardsToAdd,
    checklist: patch.checklistToAdd,
    timeline: patch.timelineToAdd,
  );
});

/// Load persisted checklist state from storage based on current trip/traveler IDs.
final persistedChecklistStateProvider = FutureProvider<Map<String, bool>>((ref) async {
  final tripId = ref.watch(tripIsarIdProvider);
  final travelerId = ref.watch(travelerIsarIdProvider);

  if (tripId == null || travelerId == null) {
    return {};
  }

  try {
    final storage = await ref.watch(storageRepositoryProvider.future);
    // Get the plan selection to find the planSelectionId
    final planSelection = await storage.loadPlanSelection(tripId: tripId, travelerId: travelerId);
    if (planSelection == null || planSelection.id == null) {
      return {};
    }
    // Load checklist states for this plan
    return storage.loadChecklistStates(planSelection.id!);
  } catch (e) {
    // If no persisted state, return empty map
    return {};
  }
});
