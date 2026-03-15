# Module Architecture (Prevention + Incident Streams)

TravelMD uses a public-first dual-stream module model:

- Prevention stream (primary): routine prevention and preparedness guidance.
- Incident/response stream (secondary): guidance after an event/exposure.

This keeps prevention as the core user experience while preserving clear incident support.

## Core Concepts

- ModuleDefinition
  - Defines a topic (for example, rabies, malaria, food-water safety).
  - Includes metadata, supported streams, and enabled state.
- ModuleStream
  - `prevention`
  - `incidentResponse`
- ModuleEngine
  - Common evaluation contract for all module engines.
  - Inputs: module definition, stream, trip, traveler, optional intake, content repository.
  - Output: ModuleEvaluationResult.
- ModuleEvaluationResult
  - Normalized output for UI composition:
    - cardsToAdd
    - checklistToAdd
    - timelineToAdd
    - alerts
    - rationaleSummary

## Registry

- `ModuleRegistry` is the central list of enabled module definitions.
- The current registry includes `rabies` with both streams enabled.
- The UI discovers modules from the registry through catalog providers:
  - enabled modules
  - prevention-capable modules
  - incident-capable modules
- Screens should read those providers instead of hardcoding module lists.

Discovery vs execution:

- Discovery uses `ModuleDefinition` metadata.
- Execution uses registry bindings that associate each module with:
  - an optional prevention engine
  - an optional incident engine

## Rabies Reference Implementation

- Prevention logic lives in `RabiesPreventionEngine`.
- Incident logic lives in `RabiesIncidentEngine`.
- `RabiesModuleEngine` dispatches by stream.
- Legacy `RabiesPlanBuilder` remains as a compatibility adapter for existing screens/providers:
  - Maps `exposure == null` to `ModuleStream.prevention`.
  - Maps `exposure != null` to `ModuleStream.incidentResponse`.
  - Converts `ModuleEvaluationResult` back to `PublicPlanPatch`.

## Malaria Skeleton (Prevention-Only)

- `malaria` is registered as a prevention-only module.
- It demonstrates how a new topic can launch with prevention support first.
- The engine reads YAML guidance cards and deterministic destination relevance mapping.
- Incident/response support can be added later by:
  1. enabling `incidentResponse` in the module definition
  2. adding a dedicated incident engine
  3. dispatching by stream (as done in rabies)

## Prevention Entry In App Navigation

- Prevention-capable modules are discovered from registry-backed providers.
- The module detail screen is the generic prevention preview entry point.
- Primary CTA: `Start prevention planning`.
- The entry resolver decides whether to:
  - go to trip setup when context is required and missing
  - go directly to prevention plan when context is already present

Prevention-only vs dual-stream behavior:

- Prevention-only modules (for example, malaria):
  - show prevention CTA only
  - no incident CTA
- Dual-stream modules (for example, rabies):
  - show prevention CTA
  - show secondary incident CTA (`Learn what to do if something happens`)

## YAML and Engines

- Engines contain deterministic decision rules only.
- Card content remains YAML-driven through `ContentRepository`.
- Engines select card IDs and checklist IDs; they do not embed large UI content.

## Execution

- `ModuleExecutionService` is the generic evaluator used by app providers and compatibility adapters.
- App-level providers should call generic execution methods instead of switching on module ids.
- A new module binds execution by being registered with:
  - its definition
  - prevention engine if supported
  - incident engine if supported

For incident algorithm schema details and rabies reference mapping, see `docs/incident-algorithms.md`.

For prevention strategy schema details and rabies/malaria reference mapping, see `docs/prevention-algorithms.md`.

## Adding a Future Module

1. Add a module definition in `ModuleRegistry`.
2. Start with prevention-only if incident workflows are not ready.
3. Implement engine(s) using `ModuleEngine`.
4. Keep prevention and incident logic in separate evaluators when both streams apply.
5. Use `ModuleEvaluationResult` as the only engine output shape.
6. Add deterministic unit tests for:
   - prevention stream behavior
   - incident stream behavior (if supported)
   - registry exposure

## Product Constraints

- Public-first only (no clinician mode).
- No dosing calculators.
- No evidence-tier UI.
- No hardcoded long-form card text outside YAML.