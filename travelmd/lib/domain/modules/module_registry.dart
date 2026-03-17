import 'package:travelmd/domain/modules/food_water_safety/food_water_safety_prevention_engine.dart';
import 'package:travelmd/domain/modules/module_definition.dart';
import 'package:travelmd/domain/modules/malaria/malaria_prevention_engine.dart';
import 'package:travelmd/domain/modules/module_registration.dart';
import 'package:travelmd/domain/modules/module_stream.dart';
import 'package:travelmd/domain/modules/pretravel_readiness/pretravel_readiness_prevention_engine.dart';
import 'package:travelmd/domain/modules/rabies/rabies_incident_engine.dart';
import 'package:travelmd/domain/modules/rabies/rabies_prevention_engine.dart';
import 'package:travelmd/domain/modules/travel_injury_prevention/travel_injury_prevention_engine.dart';

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

const ModuleDefinition pretravelReadinessModuleDefinition = ModuleDefinition(
  id: 'pretravel_readiness',
  title: 'Prepare Before You Go',
  description:
      'High-level pre-departure planning guidance for vaccines, medicines, insurance, and care access.',
  preventionFocus:
      'Pre-travel readiness steps that reduce preventable health risks before departure.',
  iconKey: 'luggage',
  requiresTripContext: true,
  isInformationalGuide: true,
  supportedStreams: [
    ModuleStream.prevention,
  ],
  enabled: true,
);

const ModuleDefinition foodWaterSafetyModuleDefinition = ModuleDefinition(
  id: 'food_water_safety',
  title: 'Eat and Drink Safer',
  description:
      'Practical food, water, and hydration habits to lower travel-related illness risk.',
  preventionFocus:
      'Safer daily food and water choices, hygiene, hydration, and care-seeking awareness.',
  iconKey: 'restaurant',
  requiresTripContext: true,
  isInformationalGuide: true,
  supportedStreams: [
    ModuleStream.prevention,
  ],
  enabled: true,
);

const ModuleDefinition travelInjuryPreventionModuleDefinition = ModuleDefinition(
  id: 'travel_injury_prevention',
  title: 'Avoid Injuries',
  description:
      'Prevention-first guidance for transport, heat, alcohol, activities, and daily movement safety.',
  preventionFocus:
      'Road safety, protective behaviors, heat and sun safety, and early help planning.',
  iconKey: 'health_and_safety',
  requiresTripContext: true,
  isInformationalGuide: true,
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

const ModuleRegistration pretravelReadinessModuleRegistration = ModuleRegistration(
  definition: pretravelReadinessModuleDefinition,
  preventionEngine: PretravelReadinessPreventionEngine(),
);

const ModuleRegistration foodWaterSafetyModuleRegistration = ModuleRegistration(
  definition: foodWaterSafetyModuleDefinition,
  preventionEngine: FoodWaterSafetyPreventionEngine(),
);

const ModuleRegistration travelInjuryPreventionModuleRegistration = ModuleRegistration(
  definition: travelInjuryPreventionModuleDefinition,
  preventionEngine: TravelInjuryPreventionEngine(),
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
      pretravelReadinessModuleRegistration,
      foodWaterSafetyModuleRegistration,
      travelInjuryPreventionModuleRegistration,
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
