import 'package:flutter_test/flutter_test.dart';
import 'package:travelmd/domain/algorithms/malaria_prevention_strategy.dart';
import 'package:travelmd/domain/algorithms/rabies_prevention_strategy.dart';
import 'package:travelmd/domain/models/traveler_profile.dart';
import 'package:travelmd/domain/models/trip.dart';
import 'package:travelmd/domain/modules/malaria/malaria_prevention_engine.dart';
import 'package:travelmd/domain/modules/module_registry.dart';
import 'package:travelmd/domain/modules/module_stream.dart';
import 'package:travelmd/domain/modules/rabies/rabies_prevention_engine.dart';

import '../modules/test_content_repository.dart';

void main() {
  group('Prevention strategy contract', () {
    test('rabies prevention strategy exposes metadata', () {
      expect(rabiesPreventionStrategy.moduleId, 'rabies');
      expect(rabiesPreventionStrategy.strategyId, 'rabies_prevention_public');
      expect(rabiesPreventionStrategy.version, '1.0.0');
      expect(rabiesPreventionStrategy.orderedRules, isNotEmpty);
    });

    test('malaria prevention strategy exposes metadata', () {
      expect(malariaPreventionStrategy.moduleId, 'malaria');
      expect(malariaPreventionStrategy.strategyId, 'malaria_prevention_public');
      expect(malariaPreventionStrategy.version, '1.0.0');
      expect(malariaPreventionStrategy.orderedRules, isNotEmpty);
    });

    test('rabies prevention remains deterministic with stable trace', () async {
      const engine = RabiesPreventionEngine();
      final module = ModuleRegistry.defaultRegistry.byId('rabies')!;
      final trip = Trip(
        originCountry: 'USA',
        destinationCountry: 'IND',
        departDate: DateTime(2026, 8, 1),
        returnDate: DateTime(2026, 8, 14),
      );
      final traveler = TravelerProfile(ageYears: 35);

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
        result1.cardsToAdd.map((card) => card.id).toList(),
        equals(result2.cardsToAdd.map((card) => card.id).toList()),
      );
      expect(result1.algorithmId, equals(result2.algorithmId));
      expect(result1.algorithmVersion, equals(result2.algorithmVersion));
      expect(result1.evaluationTrace, equals(result2.evaluationTrace));
    });

    test('malaria prevention remains deterministic with stable trace', () async {
      const engine = MalariaPreventionEngine();
      final module = ModuleRegistry.defaultRegistry.byId('malaria')!;
      final trip = Trip(
        originCountry: 'USA',
        destinationCountry: 'IND',
        departDate: DateTime(2026, 8, 1),
        returnDate: DateTime(2026, 8, 14),
      );
      final traveler = TravelerProfile(ageYears: 35);

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
        result1.cardsToAdd.map((card) => card.id).toList(),
        equals(result2.cardsToAdd.map((card) => card.id).toList()),
      );
      expect(result1.algorithmId, equals(result2.algorithmId));
      expect(result1.algorithmVersion, equals(result2.algorithmVersion));
      expect(result1.evaluationTrace, equals(result2.evaluationTrace));
    });
  });
}
