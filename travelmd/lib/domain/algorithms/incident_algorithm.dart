enum IncidentAlgorithmStyle {
  deterministicRuleSet,
  weighted,
}

class IncidentAlgorithm {
  final String algorithmId;
  final String moduleId;
  final String version;
  final String intakeSchemaRef;
  final String? lastReviewed;
  final IncidentAlgorithmStyle style;
  final List<String> alwaysCardIds;
  final List<IncidentRule> orderedRules;
  final String defaultOutcomeId;
  final Map<String, IncidentOutcome> outcomes;

  const IncidentAlgorithm({
    required this.algorithmId,
    required this.moduleId,
    required this.version,
    required this.intakeSchemaRef,
    this.lastReviewed,
    this.style = IncidentAlgorithmStyle.deterministicRuleSet,
    this.alwaysCardIds = const [],
    required this.orderedRules,
    required this.defaultOutcomeId,
    required this.outcomes,
  });
}

class IncidentRule {
  final String id;
  final String description;
  final String conditionKey;
  final String outcomeId;

  const IncidentRule({
    required this.id,
    required this.description,
    required this.conditionKey,
    required this.outcomeId,
  });
}

class IncidentOutcome {
  final String id;
  final List<String> cardIds;
  final List<String> checklistIds;
  final List<String> alerts;
  final String rationaleSummary;

  const IncidentOutcome({
    required this.id,
    this.cardIds = const [],
    this.checklistIds = const [],
    this.alerts = const [],
    required this.rationaleSummary,
  });
}
