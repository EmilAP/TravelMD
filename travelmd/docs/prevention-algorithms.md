# Prevention Strategies

TravelMD is prevention-first, so prevention logic needs a formal contract that is deterministic, testable, and easy to extend across modules.

This document defines the prevention strategy contract used by prevention-capable modules.

## Why Prevention Uses A Lighter Contract

- Prevention logic is usually additive rather than terminal.
- A user may receive baseline guidance plus extra destination-specific or traveler-specific guidance.
- The same public interface still needs versioning, rationale, and explainability.

## Contract Shape

`PreventionStrategy` includes:

- `strategyId`
- `moduleId`
- `version`
- optional `tripSchemaRef`
- optional `travelerSchemaRef`
- optional `lastReviewed`
- `style` (`deterministicAdditive` for now)
- `defaultCardIds`
- `defaultChecklistIds`
- `defaultAlerts`
- `defaultRationaleSummary`
- ordered additive rules (`orderedRules`)

Each rule includes:

- rule id
- condition key
- description
- card ids to add
- checklist ids to add
- alerts to add
- optional rationale summary override

## Rabies And Malaria Reference Mapping

- Rabies prevention strategy:
  - baseline avoidance card
  - endemic destination rule adds preparedness cards and checklist items
  - child-in-endemic rule adds supervision card
  - unknown destination rule adds uncertainty checklist item and alert

- Malaria prevention strategy:
  - baseline mosquito-avoidance card
  - malaria-relevant destination rule adds full prevention set
  - non-relevant destination rule adds deterministic alert

## Prevention Strategies vs Incident Algorithms

- Prevention strategies are lighter and additive.
- Incident algorithms are more explicit about terminal outcomes and urgent rule ordering.
- Both still return normalized `ModuleEvaluationResult` with metadata, rationale, and evaluation trace.

## Future Modules

Future modules such as food/water safety, altitude, mosquito avoidance, and STI prevention should:

1. define a prevention strategy with stable ids and versioning
2. keep public text in YAML-driven cards/checklists where possible
3. evaluate deterministic conditions in code
4. expose rationale and trace through `ModuleEvaluationResult`
