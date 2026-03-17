import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelmd/domain/modules/module_stream.dart';
import 'package:travelmd/presentation/providers/module_catalog_providers.dart';

void main() {
  test('category-driven catalog providers resolve modules correctly', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final preventionCategories = container.read(preventionCategoriesProvider);
    final incidentCategories = container.read(incidentCategoriesProvider);
    final pretravelModules = container.read(modulesByCategoryProvider('prepare_before_you_go'));
    final animalBiteModules = container.read(modulesByCategoryProvider('avoid_animal_bites'));
    final eatDrinkModules = container.read(modulesByCategoryProvider('eat_and_drink_safer'));
    final ifSomethingHappensModules = container.read(modulesByCategoryProvider('if_something_happens'));
    final injuryModules = container.read(modulesByCategoryProvider('avoid_injuries'));
    final bugBiteModules = container.read(modulesByCategoryProvider('avoid_bug_bites'));

    expect(preventionCategories.map((category) => category.id).toList(), contains('prepare_before_you_go'));
    expect(preventionCategories.map((category) => category.id).toList(), contains('avoid_animal_bites'));
    expect(preventionCategories.map((category) => category.id).toList(), contains('avoid_bug_bites'));
    expect(preventionCategories.map((category) => category.id).toList(), contains('eat_and_drink_safer'));
    expect(preventionCategories.map((category) => category.id).toList(), contains('avoid_injuries'));
    expect(incidentCategories.map((category) => category.id).toList(), equals(['if_something_happens']));
    expect(pretravelModules.map((module) => module.id).toList(), equals(['pretravel_readiness']));
    expect(animalBiteModules.map((module) => module.id).toList(), equals(['rabies']));
    expect(eatDrinkModules.map((module) => module.id).toList(), equals(['food_water_safety']));
    expect(ifSomethingHappensModules.map((module) => module.id).toList(), equals(['rabies']));
    expect(injuryModules.map((module) => module.id).toList(), equals(['travel_injury_prevention']));
    expect(bugBiteModules.map((module) => module.id).toList(), equals(['malaria']));

    final malaria = bugBiteModules.single;
    expect(malaria.supportedStreams, equals([ModuleStream.prevention]));
  });
}
