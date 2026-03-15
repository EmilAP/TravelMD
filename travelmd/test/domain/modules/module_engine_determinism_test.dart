import 'package:flutter_test/flutter_test.dart';
import 'package:travelmd/domain/enums/animal_type.dart';
import 'package:travelmd/domain/enums/exposure_contact_type.dart';
import 'package:travelmd/domain/models/exposure_intake.dart';
import 'package:travelmd/domain/models/traveler_profile.dart';
import 'package:travelmd/domain/models/trip.dart';
import 'package:travelmd/domain/modules/module_registry.dart';
import 'package:travelmd/domain/modules/module_stream.dart';
import 'package:travelmd/domain/modules/rabies/rabies_module_engine.dart';

import 'test_content_repository.dart';

void main() {
  group('ModuleEngine determinism', () {
    const engine = RabiesModuleEngine();
    final module = ModuleRegistry.defaultRegistry.byId('rabies')!;
    final trip = Trip(
      originCountry: 'USA',
      destinationCountry: 'ZAF',
      departDate: DateTime(2026, 3, 10),
      returnDate: DateTime(2026, 3, 20),
    );
    final traveler = TravelerProfile(ageYears: 25);

    test('same prevention input returns stable output', () async {
      final result1 = await engine.evaluateModule(
        module: module,
        stream: ModuleStream.prevention,
        trip: trip,
        traveler: traveler,
        contentRepository: createTestContentRepository(),
      );
      final result2 = await engine.evaluateModule(
        module: module,
        stream: ModuleStream.prevention,
        trip: trip,
        traveler: traveler,
        contentRepository: createTestContentRepository(),
      );

      expect(
        result1.cardsToAdd.map((c) => c.id).toList(),
        equals(result2.cardsToAdd.map((c) => c.id).toList()),
      );
      expect(
        result1.checklistToAdd.map((c) => c.id).toList(),
        equals(result2.checklistToAdd.map((c) => c.id).toList()),
      );
      expect(result1.alerts, equals(result2.alerts));
    });

    test('same incident input returns stable output', () async {
      final exposure = ExposureIntake(
        animalType: AnimalType.dog,
        contactType: ExposureContactType.bite,
        countryIso3: 'ZAF',
        skinBroken: true,
      );

      final result1 = await engine.evaluateModule(
        module: module,
        stream: ModuleStream.incidentResponse,
        trip: trip,
        traveler: traveler,
        intake: exposure,
        contentRepository: createTestContentRepository(),
      );
      final result2 = await engine.evaluateModule(
        module: module,
        stream: ModuleStream.incidentResponse,
        trip: trip,
        traveler: traveler,
        intake: exposure,
        contentRepository: createTestContentRepository(),
      );

      expect(
        result1.cardsToAdd.map((c) => c.id).toList(),
        equals(result2.cardsToAdd.map((c) => c.id).toList()),
      );
      expect(result1.alerts, equals(result2.alerts));
      expect(result1.rationaleSummary, equals(result2.rationaleSummary));
    });
  });
}
