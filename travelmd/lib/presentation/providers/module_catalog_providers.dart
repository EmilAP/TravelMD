import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelmd/domain/catalog/module_category.dart';
import 'package:travelmd/domain/catalog/module_category_registry.dart';
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

final moduleCategoryRegistryProvider = Provider<ModuleCategoryRegistry>((ref) {
  return ModuleCategoryRegistry.defaultRegistry;
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

final moduleCategoriesProvider = Provider<List<ModuleCategory>>((ref) {
  final registry = ref.watch(moduleCategoryRegistryProvider);
  return registry.categories;
});

final preventionCategoriesProvider = Provider<List<ModuleCategory>>((ref) {
  final categories = ref.watch(moduleCategoriesProvider);
  return categories
      .where((category) => category.primaryStream == ModuleStream.prevention)
      .toList(growable: false);
});

final incidentCategoriesProvider = Provider<List<ModuleCategory>>((ref) {
  final categories = ref.watch(moduleCategoriesProvider);
  return categories
      .where((category) => category.primaryStream == ModuleStream.incidentResponse)
      .toList(growable: false);
});

final modulesByCategoryProvider = Provider.family<List<ModuleDefinition>, String>((ref, categoryId) {
  final categoryRegistry = ref.watch(moduleCategoryRegistryProvider);
  final category = categoryRegistry.byId(categoryId);
  if (category == null) {
    return const [];
  }

  final moduleRegistry = ref.watch(moduleRegistryProvider);
  final modules = <ModuleDefinition>[];
  for (final moduleId in category.moduleIds) {
    final module = moduleRegistry.byId(moduleId);
    if (module != null && module.enabled) {
      modules.add(module);
    }
  }
  return List.unmodifiable(modules);
});
