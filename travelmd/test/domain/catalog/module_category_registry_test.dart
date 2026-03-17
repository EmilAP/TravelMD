import 'package:flutter_test/flutter_test.dart';
import 'package:travelmd/domain/catalog/module_category_registry.dart';

void main() {
  test('public category registry maps current modules correctly', () {
    final registry = ModuleCategoryRegistry.defaultRegistry;

    expect(registry.byId('prepare_before_you_go')?.moduleIds, contains('pretravel_readiness'));
    expect(registry.byId('eat_and_drink_safer')?.moduleIds, contains('food_water_safety'));
    expect(registry.byId('avoid_injuries')?.moduleIds, contains('travel_injury_prevention'));
    expect(registry.byId('avoid_animal_bites')?.moduleIds, contains('rabies'));
    expect(registry.byId('if_something_happens')?.moduleIds, contains('rabies'));
    expect(registry.byId('avoid_bug_bites')?.moduleIds, contains('malaria'));
  });
}
