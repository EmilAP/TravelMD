import 'package:travelmd/domain/modules/module_definition.dart';
import 'package:travelmd/domain/modules/malaria/malaria_prevention_engine.dart';
import 'package:travelmd/domain/modules/module_registration.dart';
import 'package:travelmd/domain/modules/module_stream.dart';
import 'package:travelmd/domain/modules/rabies/rabies_incident_engine.dart';
import 'package:travelmd/domain/modules/rabies/rabies_prevention_engine.dart';

const ModuleDefinition rabiesModuleDefinition = ModuleDefinition(
  id: 'rabies',
  title: 'Rabies',
  description:
      'Prevention and incident support for animal exposures while traveling.',
  preventionFocus: 'Animal bite and saliva exposure prevention around animals.',
  iconKey: 'pets',
  requiresTripContext: true,
  supportedStreams: [
    ModuleStream.prevention,
    ModuleStream.incidentResponse,
  ],
  enabled: true,
);

const ModuleDefinition malariaModuleDefinition = ModuleDefinition(
  id: 'malaria',
  title: 'Malaria',
  description: 'Prevention-focused malaria guidance for travelers.',
  preventionFocus: 'Mosquito bite prevention and pre-travel malaria protection planning.',
  iconKey: 'bug_report',
  requiresTripContext: true,
  supportedStreams: [
    ModuleStream.prevention,
  ],
  enabled: true,
);

const ModuleRegistration rabiesModuleRegistration = ModuleRegistration(
  definition: rabiesModuleDefinition,
  preventionEngine: RabiesPreventionEngine(),
  incidentEngine: RabiesIncidentEngine(),
);

const ModuleRegistration malariaModuleRegistration = ModuleRegistration(
  definition: malariaModuleDefinition,
  preventionEngine: MalariaPreventionEngine(),
);

class ModuleRegistry {
  final List<ModuleRegistration> registrations;

  const ModuleRegistry({required this.registrations});

  List<ModuleDefinition> get modules =>
      registrations.map((registration) => registration.definition).toList(growable: false);

  static const ModuleRegistry defaultRegistry = ModuleRegistry(
    registrations: [
      rabiesModuleRegistration,
      malariaModuleRegistration,
    ],
  );

  ModuleDefinition? byId(String id) {
    for (final registration in registrations) {
      if (registration.definition.id == id) {
        return registration.definition;
      }
    }
    return null;
  }

  ModuleRegistration? registrationById(String id) {
    for (final registration in registrations) {
      if (registration.definition.id == id) {
        return registration;
      }
    }
    return null;
  }
}
