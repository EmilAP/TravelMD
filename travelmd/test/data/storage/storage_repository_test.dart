import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:travelmd/data/storage/storage_repository.dart';
import 'package:travelmd/data/storage/entities/trip_entity.dart';
import 'package:travelmd/data/storage/entities/traveler_entity.dart';
import 'package:travelmd/data/storage/entities/plan_selection_entity.dart';
import 'package:travelmd/data/storage/entities/checklist_state_entity.dart';
import 'package:travelmd/domain/models/trip.dart';
import 'package:travelmd/domain/models/traveler_profile.dart';

void main() {
  late Isar isar;
  late StorageRepository storage;

  setUp(() async {
    isar = await Isar.open(
      [
        TripEntitySchema,
        TravelerEntitySchema,
        PlanSelectionEntitySchema,
        ChecklistStateEntitySchema,
      ],
      name: 'test',
      directory: null,
      memory: true,
    );
    storage = StorageRepository(isar);
  });

  tearDown(() async {
    await isar.close();
  });

  test('trip CRUD operations', () async {
    final trip = Trip(
      originCountry: 'USA',
      destinationCountry: 'ZAF',
      departDate: DateTime(2026, 6, 1),
      returnDate: DateTime(2026, 6, 15),
      transitCountries: ['AUT'],
    );

    final id = await storage.saveTrip(trip);
    expect(id, greaterThan(0));

    final fetched = await storage.getTrip(id);
    expect(fetched, isNotNull);
    expect(fetched?.destinationCountry, 'ZAF');

    final all = await storage.listTrips();
    expect(all.length, 1);

    await storage.deleteTrip(id);
    expect(await storage.getTrip(id), isNull);
  });

  test('traveler CRUD operations', () async {
    final traveler = TravelerProfile(
      nickname: 'Alex',
      ageYears: 30,
      isPregnant: false,
      isImmunocompromised: false,
      isVFR: false,
      purpose: 'tourism',
    );

    final id = await storage.saveTraveler(traveler);
    expect(id, greaterThan(0));

    final fetched = await storage.getTraveler(id);
    expect(fetched, isNotNull);
    expect(fetched?.nickname, 'Alex');

    final all = await storage.listTravelers();
    expect(all.length, 1);

    await storage.deleteTraveler(id);
    expect(await storage.getTraveler(id), isNull);
  });

  test('plan selection and checklist state', () async {
    final trip = Trip(
      originCountry: 'USA',
      destinationCountry: 'ZAF',
      departDate: DateTime.now(),
      returnDate: DateTime.now().add(const Duration(days: 10)),
      transitCountries: [],
    );
    final traveler = TravelerProfile(
      nickname: 'Sam',
      ageYears: 25,
      isPregnant: false,
      isImmunocompromised: false,
      isVFR: false,
      purpose: 'business',
    );

    final tripId = await storage.saveTrip(trip);
    final travelerId = await storage.saveTraveler(traveler);

    final planId = await storage.savePlanSelection(
      tripId: tripId,
      travelerId: travelerId,
      selectedCardIds: ['card1', 'card2'],
    );
    expect(planId, greaterThan(0));

    final sel = await storage.loadPlanSelection(
      tripId: tripId,
      travelerId: travelerId,
    );
    expect(sel, isNotNull);
    expect(sel?.selectedCardIds, contains('card2'));

    await storage.saveChecklistItemState(
      planSelectionId: planId,
      itemId: 'check1',
      isDone: true,
    );

    final states = await storage.loadChecklistStates(planId);
    expect(states['check1'], isTrue);

    // deletion cascade
    await storage.deleteTrip(tripId);
    expect(await storage.loadPlanSelection(tripId: tripId, travelerId: travelerId), isNull);
  });
}
