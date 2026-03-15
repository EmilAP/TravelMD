enum PreventionStrategyStyle {
  deterministicAdditive,
}

class PreventionStrategy {
  final String strategyId;
  final String moduleId;
  final String version;
  final String? tripSchemaRef;
  final String? travelerSchemaRef;
  final String? lastReviewed;
  final PreventionStrategyStyle style;
  final List<String> defaultCardIds;
  final List<String> defaultChecklistIds;
  final List<String> defaultAlerts;
  final String defaultRationaleSummary;
  final List<PreventionRule> orderedRules;

  const PreventionStrategy({
    required this.strategyId,
    required this.moduleId,
    required this.version,
    this.tripSchemaRef,
    this.travelerSchemaRef,
    this.lastReviewed,
    this.style = PreventionStrategyStyle.deterministicAdditive,
    this.defaultCardIds = const [],
    this.defaultChecklistIds = const [],
    this.defaultAlerts = const [],
    required this.defaultRationaleSummary,
    required this.orderedRules,
  });
}

class PreventionRule {
  final String id;
  final String description;
  final String conditionKey;
  final List<String> cardIds;
  final List<String> checklistIds;
  final List<String> alerts;
  final String? rationaleSummaryOverride;

  const PreventionRule({
    required this.id,
    required this.description,
    required this.conditionKey,
    this.cardIds = const [],
    this.checklistIds = const [],
    this.alerts = const [],
    this.rationaleSummaryOverride,
  });
}

class PreventionStrategyEvaluation {
  final List<String> cardIds;
  final List<String> checklistIds;
  final List<String> alerts;
  final String rationaleSummary;
  final List<String> evaluationTrace;

  const PreventionStrategyEvaluation({
    required this.cardIds,
    required this.checklistIds,
    required this.alerts,
    required this.rationaleSummary,
    required this.evaluationTrace,
  });
}
