import 'package:flutter_test/flutter_test.dart';
import 'package:travelmd/domain/enums/animal_type.dart';
import 'package:travelmd/domain/enums/exposure_contact_type.dart';
import 'package:travelmd/domain/models/exposure_intake.dart';
import 'package:travelmd/domain/models/traveler_profile.dart';
import 'package:travelmd/domain/models/trip.dart';
import 'package:travelmd/domain/modules/module_execution_service.dart';

import 'test_content_repository.dart';

void main() {
  group('ModuleExecutionService', () {
    const service = ModuleExecutionService();
    final trip = Trip(
      originCountry: 'USA',
      destinationCountry: 'IND',
      departDate: DateTime(2026, 6, 1),
      returnDate: DateTime(2026, 6, 20),
    );
    final traveler = TravelerProfile(ageYears: 31);

    test('resolves rabies prevention through registry binding', () async {
      final result = await service.evaluatePrevention(
        moduleId: 'rabies',
        trip: trip,
        traveler: traveler,
        contentRepository: createTestContentRepository(),
      );

      final cardIds = result.cardsToAdd.map((card) => card.id).toList();
      expect(cardIds, contains('rabies_prevent_avoid_animals'));
      expect(cardIds, contains('rabies_prepare_know_where_to_go'));
    });

    test('resolves rabies incident through registry binding', () async {
      final result = await service.evaluateIncident(
        moduleId: 'rabies',
        trip: trip,
        traveler: traveler,
        intake: ExposureIntake(
          animalType: AnimalType.bat,
          contactType: ExposureContactType.lickOnIntactSkin,
          countryIso3: 'IND',
        ),
        contentRepository: createTestContentRepository(),
      );

      final cardIds = result.cardsToAdd.map((card) => card.id).toList();
      expect(cardIds, contains('rabies_exposure_wound_wash_now'));
      expect(cardIds, contains('rabies_exposure_seek_care_now'));
    });

    test('resolves malaria prevention through registry binding', () async {
      final result = await service.evaluatePrevention(
        moduleId: 'malaria',
        trip: trip,
        traveler: traveler,
        contentRepository: createTestContentRepository(),
      );

      final cardIds = result.cardsToAdd.map((card) => card.id).toList();
      expect(cardIds, contains('malaria_prevent_general_mosquito_avoidance'));
      expect(cardIds, contains('malaria_prevent_discuss_medication'));
    });

    test('malaria incident fails predictably as unsupported stream', () async {
      expect(
        () => service.evaluateIncident(
          moduleId: 'malaria',
          trip: trip,
          traveler: traveler,
          intake: null,
          contentRepository: createTestContentRepository(),
        ),
        throwsA(
          isA<StateError>().having(
            (error) => error.message,
            'message',
            contains('does not support incidentResponse evaluation'),
          ),
        ),
      );
    });

    test('registry-driven prevention evaluation remains deterministic', () async {
      final result1 = await service.evaluatePrevention(
        moduleId: 'malaria',
        trip: trip,
        traveler: traveler,
        contentRepository: createTestContentRepository(),
      );
      final result2 = await service.evaluatePrevention(
        moduleId: 'malaria',
        trip: trip,
        traveler: traveler,
        contentRepository: createTestContentRepository(),
      );

      expect(
        result1.cardsToAdd.map((card) => card.id).toList(),
        equals(result2.cardsToAdd.map((card) => card.id).toList()),
      );
      expect(result1.alerts, equals(result2.alerts));
    });
  });
}
