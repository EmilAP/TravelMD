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
}
