import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelmd/domain/modules/module_stream.dart';
import 'package:travelmd/presentation/providers/app_providers.dart';
import 'package:travelmd/presentation/providers/module_catalog_providers.dart';

final preventionEntryRouteProvider = Provider.family<String, String>((ref, moduleId) {
  final module = ref.watch(moduleRegistryProvider).byId(moduleId);
  if (module == null || !module.supportsStream(ModuleStream.prevention)) {
    return '/modules?focus=prevention';
  }

  final hasTripContext = ref.watch(tripProvider) != null;
  final hasTravelerContext = ref.watch(travelerProvider) != null;
  final hasReadyContext = hasTripContext && hasTravelerContext;

  if (module.requiresTripContext && !hasReadyContext) {
    return '/trip';
  }

  return '/trip/traveler/plan';
});

final incidentEntryRouteProvider = Provider.family<String, String>((ref, moduleId) {
  final module = ref.watch(moduleRegistryProvider).byId(moduleId);
  if (module == null || !module.supportsStream(ModuleStream.incidentResponse)) {
    return '/modules?focus=incidentResponse';
  }

  switch (module.id) {
    case 'rabies':
      return '/trip/traveler/plan/exposure';
    default:
      return '/modules/$moduleId?stream=incidentResponse';
  }
});
