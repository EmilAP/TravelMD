import 'package:flutter_test/flutter_test.dart';
import 'package:travelmd/domain/enums/animal_type.dart';
import 'package:travelmd/domain/enums/exposure_contact_type.dart';
import 'package:travelmd/domain/models/exposure_intake.dart';
import 'package:travelmd/domain/models/traveler_profile.dart';
import 'package:travelmd/domain/models/trip.dart';
import 'package:travelmd/domain/modules/module_registry.dart';
import 'package:travelmd/domain/modules/module_stream.dart';
import 'package:travelmd/domain/modules/rabies/rabies_incident_engine.dart';

import 'test_content_repository.dart';

void main() {
  group('RabiesIncidentEngine', () {
    const engine = RabiesIncidentEngine();
    final module = ModuleRegistry.defaultRegistry.byId('rabies')!;
    final trip = Trip(
      originCountry: 'USA',
      destinationCountry: 'IND',
      departDate: DateTime(2026, 3, 10),
      returnDate: DateTime(2026, 3, 20),
    );
    final traveler = TravelerProfile(ageYears: 30);

    test('bat exposure returns wound wash and seek care cards', () async {
      final result = await engine.evaluateModule(
        module: module,
        stream: ModuleStream.incidentResponse,
        trip: trip,
        traveler: traveler,
        intake: ExposureIntake(
          animalType: AnimalType.bat,
          contactType: ExposureContactType.lickOnIntactSkin,
          countryIso3: 'IND',
        ),
        contentRepository: createTestContentRepository(),
      );

      final cardIds = result.cardsToAdd.map((c) => c.id).toList();
      expect(cardIds, contains('rabies_exposure_wound_wash_now'));
      expect(cardIds, contains('rabies_exposure_seek_care_now'));
      expect(result.algorithmId, equals('rabies_incident_public'));
      expect(result.algorithmVersion, equals('1.0.0'));
      expect(result.evaluationTrace, isNotEmpty);
    });

    test('lick on intact skin returns reassure card without seek care', () async {
      final result = await engine.evaluateModule(
        module: module,
        stream: ModuleStream.incidentResponse,
        trip: trip,
        traveler: traveler,
        intake: ExposureIntake(
          animalType: AnimalType.dog,
          contactType: ExposureContactType.lickOnIntactSkin,
          countryIso3: 'IND',
          skinBroken: false,
          mucousMembrane: false,
        ),
        contentRepository: createTestContentRepository(),
      );

      final cardIds = result.cardsToAdd.map((c) => c.id).toList();
      expect(cardIds, contains('rabies_exposure_wound_wash_now'));
      expect(cardIds, contains('rabies_exposure_reassure_no_risk'));
      expect(cardIds, isNot(contains('rabies_exposure_seek_care_now')));
      expect(result.rationaleSummary, contains('Low-risk contact pattern'));
      expect(
        result.evaluationTrace.any((line) => line.contains('selected_outcome:outcome_low_risk_reassure')),
        isTrue,
      );
    });
  });
}
