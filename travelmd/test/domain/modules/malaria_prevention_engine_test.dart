import 'package:flutter_test/flutter_test.dart';
import 'package:travelmd/domain/models/traveler_profile.dart';
import 'package:travelmd/domain/models/trip.dart';
import 'package:travelmd/domain/modules/malaria/malaria_prevention_engine.dart';
import 'package:travelmd/domain/modules/module_registry.dart';
import 'package:travelmd/domain/modules/module_stream.dart';

import 'test_content_repository.dart';

void main() {
  group('MalariaPreventionEngine', () {
    const engine = MalariaPreventionEngine();
    final module = ModuleRegistry.defaultRegistry.byId('malaria')!;
    final traveler = TravelerProfile(ageYears: 33);

    test('malaria-relevant destination returns full prevention set', () async {
      final result = await engine.evaluateModule(
        module: module,
        stream: ModuleStream.prevention,
        trip: Trip(
          originCountry: 'USA',
          destinationCountry: 'IND',
          departDate: DateTime(2026, 5, 1),
          returnDate: DateTime(2026, 5, 14),
        ),
        traveler: traveler,
        contentRepository: createTestContentRepository(),
      );

      final cardIds = result.cardsToAdd.map((c) => c.id).toList();
      expect(cardIds, equals([
        'malaria_prevent_general_mosquito_avoidance',
        'malaria_prevent_use_repellent',
        'malaria_prevent_bed_nets_room_protection',
        'malaria_prevent_cover_skin',
        'malaria_prevent_discuss_medication',
        'malaria_prevent_plan_early_care',
      ]));
      expect(result.alerts, isEmpty);
      expect(result.algorithmId, equals('malaria_prevention_public'));
      expect(result.algorithmVersion, equals('1.0.0'));
      expect(result.evaluationTrace, isNotEmpty);
    });

    test('non-relevant destination returns baseline card deterministically', () async {
      final trip = Trip(
        originCountry: 'USA',
        destinationCountry: 'AUS',
        departDate: DateTime(2026, 5, 1),
        returnDate: DateTime(2026, 5, 14),
      );

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
        equals(['malaria_prevent_general_mosquito_avoidance']),
      );
      expect(
        result1.cardsToAdd.map((c) => c.id).toList(),
        equals(result2.cardsToAdd.map((c) => c.id).toList()),
      );
      expect(
        result1.alerts,
        equals(['Destination not flagged as malaria-relevant in current mapping.']),
      );
      expect(result1.alerts, equals(result2.alerts));
      expect(
        result1.evaluationTrace.any((line) => line.contains('rule:rule_malaria_not_relevant_destination:matched=true')),
        isTrue,
      );
    });
  });
}
