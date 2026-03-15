import 'package:flutter_test/flutter_test.dart';
import 'package:travelmd/domain/enums/animal_type.dart';
import 'package:travelmd/domain/enums/exposure_contact_type.dart';
import 'package:travelmd/domain/models/exposure_intake.dart';
import 'package:travelmd/domain/models/traveler_profile.dart';
import 'package:travelmd/domain/models/trip.dart';
import 'package:travelmd/domain/modules/module_registry.dart';
import 'package:travelmd/domain/rules/rabies_plan_builder.dart';

import 'test_content_repository.dart';

void main() {
  group('Rabies behavior unchanged after malaria module addition', () {
    const builder = RabiesPlanBuilder();

    test('prevention still returns endemic prevention cards', () async {
      final patch = await builder.build(
        trip: Trip(
          originCountry: 'USA',
          destinationCountry: 'IND',
          departDate: DateTime(2026, 4, 2),
          returnDate: DateTime(2026, 4, 20),
        ),
        traveler: TravelerProfile(ageYears: 34),
        contentRepo: createTestContentRepository(),
      );

      final cardIds = patch.cardsToAdd.map((c) => c.id).toList();
      expect(cardIds, contains('rabies_prevent_avoid_animals'));
      expect(cardIds, contains('rabies_prepare_know_where_to_go'));
      expect(ModuleRegistry.defaultRegistry.byId('malaria'), isNotNull);
    });

    test('incident still returns wound wash + seek care for bat exposure', () async {
      final patch = await builder.build(
        trip: Trip(
          originCountry: 'USA',
          destinationCountry: 'IND',
          departDate: DateTime(2026, 4, 2),
          returnDate: DateTime(2026, 4, 20),
        ),
        traveler: TravelerProfile(ageYears: 34),
        exposure: ExposureIntake(
          animalType: AnimalType.bat,
          contactType: ExposureContactType.lickOnIntactSkin,
          countryIso3: 'IND',
        ),
        contentRepo: createTestContentRepository(),
      );

      final cardIds = patch.cardsToAdd.map((c) => c.id).toList();
      expect(cardIds, contains('rabies_exposure_wound_wash_now'));
      expect(cardIds, contains('rabies_exposure_seek_care_now'));
    });
  });
}
