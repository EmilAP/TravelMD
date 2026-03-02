import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelmd/data/repositories/content_repository.dart';
import 'package:travelmd/domain/models/trip.dart';
import 'package:travelmd/domain/models/traveler_profile.dart';
import 'package:travelmd/domain/models/public_plan.dart';
import 'package:travelmd/domain/rules/rabies_plan_builder.dart';

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

  void setTrip(Trip trip) {
    state = trip;
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

  void setTraveler(TravelerProfile traveler) {
    state = traveler;
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
