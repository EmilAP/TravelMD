import 'package:travelmd/domain/algorithms/incident_algorithm.dart';

const IncidentAlgorithm rabiesIncidentAlgorithm = IncidentAlgorithm(
  algorithmId: 'rabies_incident_public',
  moduleId: 'rabies',
  version: '1.0.0',
  intakeSchemaRef: 'ExposureIntake.v1',
  lastReviewed: '2026-03-15',
  style: IncidentAlgorithmStyle.deterministicRuleSet,
  alwaysCardIds: [
    'rabies_exposure_wound_wash_now',
  ],
  orderedRules: [
    IncidentRule(
      id: 'rule_low_risk_lick_intact_non_bat',
      description:
          'Non-bat lick on intact skin without mucosal contact is very low risk.',
      conditionKey: 'low_risk_lick_intact_non_bat',
      outcomeId: 'outcome_low_risk_reassure',
    ),
    IncidentRule(
      id: 'rule_bat_contact_any',
      description: 'Bat contact is treated as high concern and needs urgent care.',
      conditionKey: 'bat_contact_any',
      outcomeId: 'outcome_seek_care_now',
    ),
    IncidentRule(
      id: 'rule_high_risk_contact_type',
      description: 'Bite, scratch, or saliva to mucosa/broken skin needs urgent care.',
      conditionKey: 'high_risk_contact_type',
      outcomeId: 'outcome_seek_care_now',
    ),
    IncidentRule(
      id: 'rule_endemic_skin_broken_non_bat_mammal',
      description:
          'In endemic settings, broken skin contact with common mammal exposures needs urgent care.',
      conditionKey: 'endemic_skin_broken_non_bat_mammal',
      outcomeId: 'outcome_seek_care_now',
    ),
  ],
  defaultOutcomeId: 'outcome_wound_wash_only',
  outcomes: {
    'outcome_low_risk_reassure': IncidentOutcome(
      id: 'outcome_low_risk_reassure',
      cardIds: ['rabies_exposure_reassure_no_risk'],
      rationaleSummary:
          'Low-risk contact pattern detected (lick on intact skin, no mucosa).',
    ),
    'outcome_seek_care_now': IncidentOutcome(
      id: 'outcome_seek_care_now',
      cardIds: ['rabies_exposure_seek_care_now'],
      rationaleSummary:
          'Exposure pattern indicates immediate medical evaluation is advised.',
    ),
    'outcome_wound_wash_only': IncidentOutcome(
      id: 'outcome_wound_wash_only',
      rationaleSummary:
          'Immediate wound care guidance was added while monitoring for concerning exposure features.',
    ),
  },
);
