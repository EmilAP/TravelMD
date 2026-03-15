import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelmd/domain/models/traveler_profile.dart';
import 'package:travelmd/domain/models/trip.dart';
import 'package:travelmd/presentation/providers/app_providers.dart';
import 'package:travelmd/presentation/providers/module_navigation_providers.dart';

import '../../domain/modules/test_content_repository.dart';

void main() {
  group('Prevention module entry flow', () {
    test('malaria prevention route requires trip setup without context', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final route = container.read(preventionEntryRouteProvider('malaria'));
      expect(route, '/trip');
    });

    test('malaria prevention route goes to plan with existing context', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(tripProvider.notifier).setTrip(
            Trip(
              originCountry: 'USA',
              destinationCountry: 'IND',
              departDate: DateTime(2026, 6, 1),
              returnDate: DateTime(2026, 6, 20),
            ),
          );
      container.read(travelerProvider.notifier).setTraveler(
            TravelerProfile(ageYears: 30),
          );

      final route = container.read(preventionEntryRouteProvider('malaria'));
      expect(route, '/trip/traveler/plan');
    });

    test('malaria module generates module-focused prevention plan', () async {
      final container = ProviderContainer(
        overrides: [
          contentRepositoryProvider.overrideWithValue(createTestContentRepository()),
        ],
      );
      addTearDown(container.dispose);

      container.read(selectedPreventionModuleIdProvider.notifier).state = 'malaria';
      container.read(tripProvider.notifier).setTrip(
            Trip(
              originCountry: 'USA',
              destinationCountry: 'IND',
              departDate: DateTime(2026, 6, 1),
              returnDate: DateTime(2026, 6, 20),
            ),
          );
      container.read(travelerProvider.notifier).setTraveler(
            TravelerProfile(ageYears: 30),
          );

      final plan = await container.read(preventionPlanProvider.future);
      final cardIds = plan.cards.map((card) => card.id).toList();

      expect(plan.title, 'Malaria Prevention Plan');
      expect(cardIds, contains('malaria_prevent_general_mosquito_avoidance'));
      expect(cardIds, contains('malaria_prevent_discuss_medication'));
    });
  });
}
