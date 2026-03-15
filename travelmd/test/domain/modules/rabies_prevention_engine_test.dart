import 'package:flutter_test/flutter_test.dart';
import 'package:travelmd/domain/models/traveler_profile.dart';
import 'package:travelmd/domain/models/trip.dart';
import 'package:travelmd/domain/modules/module_registry.dart';
import 'package:travelmd/domain/modules/module_stream.dart';
import 'package:travelmd/domain/modules/rabies/rabies_prevention_engine.dart';

import 'test_content_repository.dart';

void main() {
  group('RabiesPreventionEngine', () {
    const engine = RabiesPreventionEngine();
    final module = ModuleRegistry.defaultRegistry.byId('rabies')!;

    test('returns prevention and preparedness cards for endemic destination', () async {
      final result = await engine.evaluateModule(
        module: module,
        stream: ModuleStream.prevention,
        trip: Trip(
          originCountry: 'USA',
          destinationCountry: 'IND',
          departDate: DateTime(2026, 3, 10),
          returnDate: DateTime(2026, 3, 20),
        ),
        traveler: TravelerProfile(ageYears: 35),
        contentRepository: createTestContentRepository(),
      );

      final cardIds = result.cardsToAdd.map((c) => c.id).toList();
      expect(cardIds, contains('rabies_prevent_avoid_animals'));
      expect(cardIds, contains('rabies_prepare_know_where_to_go'));
      expect(cardIds, contains('rabies_prepare_consider_preexposure_vaccine'));
      expect(result.checklistToAdd, isNotEmpty);
      expect(result.alerts, isEmpty);
      expect(result.algorithmId, equals('rabies_prevention_public'));
      expect(result.algorithmVersion, equals('1.0.0'));
      expect(result.evaluationTrace, isNotEmpty);
    });

    test('unknown destination adds uncertainty alert and checklist item', () async {
      final result = await engine.evaluateModule(
        module: module,
        stream: ModuleStream.prevention,
        trip: Trip(
          originCountry: 'USA',
          destinationCountry: 'XXX',
          departDate: DateTime(2026, 3, 10),
          returnDate: DateTime(2026, 3, 20),
        ),
        traveler: TravelerProfile(ageYears: 35),
        contentRepository: createTestContentRepository(),
      );

      expect(result.alerts, contains('Destination rabies endemicity is unknown.'));
      expect(
        result.checklistToAdd.map((c) => c.id).toList(),
        contains('uncertain_destination_rabies'),
      );
      expect(
        result.evaluationTrace.any((line) => line.contains('rule:rule_unknown_destination_rabies:matched=true')),
        isTrue,
      );
    });
  });
}
