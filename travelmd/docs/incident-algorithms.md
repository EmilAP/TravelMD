# Incident Algorithms

TravelMD is prevention-first, but incident engines are essential for "what do I do now?" workflows.

This document defines the incident algorithm contract used by incident-capable modules.

## Why Incident Algorithms Need A Contract

- Deterministic behavior: the same intake should produce the same outcome.
- Versioning: algorithm metadata can be tracked and tested over time.
- Explainability: evaluation traces can show which rules matched.
- Compatibility: output shape remains aligned with `ModuleEvaluationResult`.

## Contract Shape

`IncidentAlgorithm` includes:

- `algorithmId`
- `moduleId`
- `version`
- `intakeSchemaRef`
- `lastReviewed` (optional)
- `style` (`deterministicRuleSet` now, `weighted` reserved for future)
- `alwaysCardIds`
- ordered rules (`orderedRules`)
- terminal outcomes (`outcomes`)
- `defaultOutcomeId`

Each rule includes:

- rule id
- condition key
- description
- outcome id

Each outcome includes:

- card ids
- optional checklist ids
- optional alerts
- rationale summary

## Rabies Reference Implementation

- Rabies incident evaluation maps to a versioned algorithm contract:
  - algorithm id: `rabies_incident_public`
  - version: `1.0.0`
  - module id: `rabies`
- The engine executes rules in deterministic order and emits:
  - stable card IDs
  - rationale summary
  - evaluation trace
  - algorithm metadata in result fields

## Prevention Engines vs Incident Algorithms

- Prevention engines remain topic-level evaluators for pre-travel guidance.
- Incident algorithms formalize urgent decision logic with explicit rule ordering and outcomes.
- Both still return normalized `ModuleEvaluationResult` output.

## Future Weighted / Probabilistic Approaches

- The `style` field reserves room for future weighted logic.
- Weighted implementations should still map to normalized public outputs.
- Public interface to app providers should not change.
