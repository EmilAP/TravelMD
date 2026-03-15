import 'package:travelmd/domain/algorithms/prevention_strategy.dart';

const PreventionStrategy rabiesPreventionStrategy = PreventionStrategy(
  strategyId: 'rabies_prevention_public',
  moduleId: 'rabies',
  version: '1.0.0',
  tripSchemaRef: 'Trip.v1',
  travelerSchemaRef: 'TravelerProfile.v1',
  lastReviewed: '2026-03-15',
  defaultCardIds: [
    'rabies_prevent_avoid_animals',
  ],
  defaultRationaleSummary:
      'No endemic signal found, so baseline prevention guidance was added.',
  orderedRules: [
    PreventionRule(
      id: 'rule_unknown_destination_rabies',
      description: 'Unknown destination keeps baseline guidance and adds uncertainty alerting.',
      conditionKey: 'unknown_destination_rabies',
      checklistIds: ['uncertain_destination_rabies'],
      alerts: ['Destination rabies endemicity is unknown.'],
    ),
    PreventionRule(
      id: 'rule_endemic_destination_rabies',
      description:
          'Endemic destinations add broader prevention and preparedness guidance.',
      conditionKey: 'endemic_destination_rabies',
      cardIds: [
        'rabies_prevent_no_feed_touch',
        'rabies_prevent_bats_in_room',
        'rabies_prepare_know_where_to_go',
        'rabies_prepare_consider_preexposure_vaccine',
      ],
      checklistIds: [
        'rabies_checklist_hospital_address',
        'rabies_checklist_soap_sanitizer',
        'rabies_checklist_discuss_vaccines',
      ],
      rationaleSummaryOverride:
          'Destination appears endemic, so full prevention and preparedness guidance was added.',
    ),
    PreventionRule(
      id: 'rule_endemic_child_rabies',
      description: 'Children in endemic settings get extra supervision guidance.',
      conditionKey: 'endemic_child_rabies',
      cardIds: ['rabies_prevent_kids_supervision'],
    ),
  ],
);
