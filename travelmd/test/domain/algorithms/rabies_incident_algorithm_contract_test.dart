import 'package:flutter_test/flutter_test.dart';
import 'package:travelmd/domain/algorithms/rabies_incident_algorithm.dart';
import 'package:travelmd/domain/enums/animal_type.dart';
import 'package:travelmd/domain/enums/exposure_contact_type.dart';
import 'package:travelmd/domain/models/exposure_intake.dart';
import 'package:travelmd/domain/models/traveler_profile.dart';
import 'package:travelmd/domain/models/trip.dart';
import 'package:travelmd/domain/modules/module_registry.dart';
import 'package:travelmd/domain/modules/module_stream.dart';
import 'package:travelmd/domain/modules/rabies/rabies_incident_engine.dart';

import '../modules/test_content_repository.dart';

void main() {
  group('Rabies incident algorithm contract', () {
    test('exposes algorithm metadata and deterministic ordering contract', () {
      expect(rabiesIncidentAlgorithm.moduleId, 'rabies');
      expect(rabiesIncidentAlgorithm.algorithmId, 'rabies_incident_public');
      expect(rabiesIncidentAlgorithm.version, '1.0.0');
      expect(rabiesIncidentAlgorithm.intakeSchemaRef, 'ExposureIntake.v1');
      expect(rabiesIncidentAlgorithm.orderedRules, isNotEmpty);
      expect(rabiesIncidentAlgorithm.defaultOutcomeId, isNotEmpty);
      expect(rabiesIncidentAlgorithm.outcomes, isNotEmpty);
    });

    test('same intake produces stable cards and trace', () async {
      const engine = RabiesIncidentEngine();
      final module = ModuleRegistry.defaultRegistry.byId('rabies')!;
      final trip = Trip(
        originCountry: 'USA',
        destinationCountry: 'IND',
        departDate: DateTime(2026, 7, 1),
        returnDate: DateTime(2026, 7, 14),
      );
      final traveler = TravelerProfile(ageYears: 29);
      final intake = ExposureIntake(
        animalType: AnimalType.dog,
        contactType: ExposureContactType.lickOnIntactSkin,
        countryIso3: 'IND',
        skinBroken: false,
        mucousMembrane: false,
      );

      final result1 = await engine.evaluateModule(
        module: module,
        stream: ModuleStream.incidentResponse,
        trip: trip,
        traveler: traveler,
        intake: intake,
        contentRepository: createTestContentRepository(),
      );
      final result2 = await engine.evaluateModule(
        module: module,
        stream: ModuleStream.incidentResponse,
        trip: trip,
        traveler: traveler,
        intake: intake,
        contentRepository: createTestContentRepository(),
      );

      expect(
        result1.cardsToAdd.map((card) => card.id).toList(),
        equals(result2.cardsToAdd.map((card) => card.id).toList()),
      );
      expect(result1.algorithmId, equals(result2.algorithmId));
      expect(result1.algorithmVersion, equals(result2.algorithmVersion));
      expect(result1.evaluationTrace, equals(result2.evaluationTrace));
    });
  });
}
