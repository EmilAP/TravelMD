import 'package:flutter_test/flutter_test.dart';
import 'package:travelmd/domain/modules/module_registry.dart';
import 'package:travelmd/domain/modules/module_stream.dart';

void main() {
  test('module registry exposes rabies with both streams', () {
    final module = ModuleRegistry.defaultRegistry.byId('rabies');

    expect(module, isNotNull);
    expect(module!.enabled, isTrue);
    expect(module.supportedStreams, contains(ModuleStream.prevention));
    expect(module.supportedStreams, contains(ModuleStream.incidentResponse));
  });

  test('module registry exposes malaria as prevention-only', () {
    final module = ModuleRegistry.defaultRegistry.byId('malaria');

    expect(module, isNotNull);
    expect(module!.enabled, isTrue);
    expect(module.supportedStreams, equals([ModuleStream.prevention]));
  });

  test('module registry exposes pretravel_readiness as prevention-only', () {
    final module = ModuleRegistry.defaultRegistry.byId('pretravel_readiness');

    expect(module, isNotNull);
    expect(module!.enabled, isTrue);
    expect(module.supportedStreams, equals([ModuleStream.prevention]));
    expect(module.isInformationalGuide, isTrue);
  });

  test('module registry exposes food_water_safety as prevention-only', () {
    final module = ModuleRegistry.defaultRegistry.byId('food_water_safety');

    expect(module, isNotNull);
    expect(module!.enabled, isTrue);
    expect(module.supportedStreams, equals([ModuleStream.prevention]));
    expect(module.isInformationalGuide, isTrue);
  });

  test('module registry exposes travel_injury_prevention as prevention-only', () {
    final module = ModuleRegistry.defaultRegistry.byId('travel_injury_prevention');

    expect(module, isNotNull);
    expect(module!.enabled, isTrue);
    expect(module.supportedStreams, equals([ModuleStream.prevention]));
    expect(module.isInformationalGuide, isTrue);
  });
}
