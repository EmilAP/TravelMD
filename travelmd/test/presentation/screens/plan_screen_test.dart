import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:travelmd/domain/models/trip.dart';
import 'package:travelmd/domain/models/traveler_profile.dart';
import 'package:travelmd/domain/models/checklist_item.dart';
import 'package:travelmd/domain/enums/checklist_category.dart';
import 'package:travelmd/domain/models/public_plan.dart';
import 'package:travelmd/presentation/providers/app_providers.dart';
import 'package:travelmd/presentation/screens/plan_screen.dart';
import 'package:travelmd/data/storage/storage_repository.dart';
import 'package:travelmd/data/storage/entities/trip_entity.dart';
import 'package:travelmd/data/storage/entities/traveler_entity.dart';
import 'package:travelmd/data/storage/entities/plan_selection_entity.dart';
import 'package:travelmd/data/storage/entities/checklist_state_entity.dart';

void main() {
  testWidgets('Checklist state persists and reloads from storage',
      (tester) async {
    // prepare in-memory storage
    final isar = await Isar.open(
      [
        TripEntitySchema,
        TravelerEntitySchema,
        PlanSelectionEntitySchema,
        ChecklistStateEntitySchema,
      ],
      name: 'widget_test',
      directory: null,
      memory: true,
    );
    final storage = StorageRepository(isar);

    final trip = Trip(
      originCountry: 'USA',
      destinationCountry: 'ZAF',
      departDate: DateTime.now(),
      returnDate: DateTime.now().add(const Duration(days: 5)),
      transitCountries: [],
    );
    final traveler = TravelerProfile(
      nickname: 'Widget',
      ageYears: 40,
      isPregnant: false,
      isImmunocompromised: false,
      isVFR: false,
      purpose: 'tourism',
    );
    final tripId = await storage.saveTrip(trip);
    final travelerId = await storage.saveTraveler(traveler);

    final planId = await storage.savePlanSelection(
      tripId: tripId,
      travelerId: travelerId,
      selectedCardIds: ['c1'],
    );

    // pre-fill checklist state
    await storage.saveChecklistItemState(
      planSelectionId: planId,
      itemId: 'foo',
      isDone: true,
    );

    final fakePlan = PublicPlan(
      id: 'p1',
      tripId: 't1',
      travelerId: 'tr1',
      title: 'Test',
      summary: 'Summary',
      cards: [],
      checklist: [
        ChecklistItem(id: 'foo', label: 'Foo', category: ChecklistCategory.safety),
      ],
      timeline: [],
    );

    await tester.pumpWidget(
      ProviderScope(overrides: [
        storageRepositoryProvider.overrideWithValue(Future.value(storage)),
        tripProvider.overrideWithValue(trip),
        tripIsarIdProvider.overrideWithValue(tripId),
        travelerProvider.overrideWithValue(traveler),
        travelerIsarIdProvider.overrideWithValue(travelerId),
        preventionPlanProvider.overrideWithValue(AsyncValue.data(fakePlan)),
      ], child: const MaterialApp(home: PlanScreen())),
    );
    await tester.pumpAndSettle();

    // checkbox should be checked initially
    final checkbox = find.byType(CheckboxListTile);
    expect(checkbox, findsOneWidget);
    var tile = tester.widget<CheckboxListTile>(checkbox);
    expect(tile.value, isTrue);

    // tap to uncheck
    await tester.tap(checkbox);
    await tester.pumpAndSettle();

    // storage should reflect change
    final states = await storage.loadChecklistStates(planId);
    expect(states['foo'], isFalse);

    // rebuild widget to simulate reload
    await tester.pumpWidget(
      ProviderScope(overrides: [
        storageRepositoryProvider.overrideWithValue(Future.value(storage)),
        tripProvider.overrideWithValue(trip),
        tripIsarIdProvider.overrideWithValue(tripId),
        travelerProvider.overrideWithValue(traveler),
        travelerIsarIdProvider.overrideWithValue(travelerId),
        preventionPlanProvider.overrideWithValue(AsyncValue.data(fakePlan)),
      ], child: const MaterialApp(home: PlanScreen())),
    );
    await tester.pumpAndSettle();

    tile = tester.widget<CheckboxListTile>(checkbox);
    expect(tile.value, isFalse);

    await isar.close();
  });
}
