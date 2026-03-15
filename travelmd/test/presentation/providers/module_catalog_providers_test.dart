import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelmd/domain/modules/module_stream.dart';
import 'package:travelmd/presentation/providers/module_catalog_providers.dart';

void main() {
  test('module catalog providers expose rabies and malaria correctly', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final enabledModules = container.read(enabledModulesProvider);
    final preventionModules = container.read(preventionModulesProvider);
    final incidentModules = container.read(incidentModulesProvider);

    expect(enabledModules.map((module) => module.id).toList(), containsAll(['rabies', 'malaria']));
    expect(preventionModules.map((module) => module.id).toList(), containsAll(['rabies', 'malaria']));
    expect(incidentModules.map((module) => module.id).toList(), equals(['rabies']));

    final malaria = enabledModules.firstWhere((module) => module.id == 'malaria');
    expect(malaria.supportedStreams, equals([ModuleStream.prevention]));
  });
}
