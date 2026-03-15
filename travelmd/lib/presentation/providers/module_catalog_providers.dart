import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelmd/domain/modules/module_definition.dart';
import 'package:travelmd/domain/modules/module_execution_service.dart';
import 'package:travelmd/domain/modules/module_registry.dart';
import 'package:travelmd/domain/modules/module_stream.dart';

final moduleRegistryProvider = Provider<ModuleRegistry>((ref) {
  return ModuleRegistry.defaultRegistry;
});

final moduleExecutionServiceProvider = Provider<ModuleExecutionService>((ref) {
  final registry = ref.watch(moduleRegistryProvider);
  return ModuleExecutionService(registry: registry);
});

final enabledModulesProvider = Provider<List<ModuleDefinition>>((ref) {
  final registry = ref.watch(moduleRegistryProvider);
  return registry.modules.where((module) => module.enabled).toList(growable: false);
});

final preventionModulesProvider = Provider<List<ModuleDefinition>>((ref) {
  final modules = ref.watch(enabledModulesProvider);
  return modules
      .where((module) => module.supportsStream(ModuleStream.prevention))
      .toList(growable: false);
});

final incidentModulesProvider = Provider<List<ModuleDefinition>>((ref) {
  final modules = ref.watch(enabledModulesProvider);
  return modules
      .where((module) => module.supportsStream(ModuleStream.incidentResponse))
      .toList(growable: false);
});
