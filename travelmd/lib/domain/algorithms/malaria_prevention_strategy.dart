import 'package:travelmd/domain/algorithms/prevention_strategy.dart';

const PreventionStrategy malariaPreventionStrategy = PreventionStrategy(
  strategyId: 'malaria_prevention_public',
  moduleId: 'malaria',
  version: '1.0.0',
  tripSchemaRef: 'Trip.v1',
  travelerSchemaRef: 'TravelerProfile.v1',
  lastReviewed: '2026-03-15',
  defaultCardIds: [
    'malaria_prevent_general_mosquito_avoidance',
  ],
  defaultRationaleSummary:
      'Destination is not flagged as malaria-relevant; baseline mosquito prevention returned.',
  orderedRules: [
    PreventionRule(
      id: 'rule_malaria_relevant_destination',
      description: 'Malaria-relevant destinations get the full prevention card set.',
      conditionKey: 'malaria_relevant_destination',
      cardIds: [
        'malaria_prevent_use_repellent',
        'malaria_prevent_bed_nets_room_protection',
        'malaria_prevent_cover_skin',
        'malaria_prevent_discuss_medication',
        'malaria_prevent_plan_early_care',
      ],
      rationaleSummaryOverride:
          'Destination is flagged as malaria-relevant; full prevention set returned.',
    ),
    PreventionRule(
      id: 'rule_malaria_not_relevant_destination',
      description: 'Non-relevant destinations keep baseline prevention and add a deterministic alert.',
      conditionKey: 'malaria_not_relevant_destination',
      alerts: ['Destination not flagged as malaria-relevant in current mapping.'],
    ),
  ],
);
