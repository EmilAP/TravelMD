import 'package:travelmd/domain/algorithms/prevention_strategy.dart';

class PreventionStrategyEvaluator {
  const PreventionStrategyEvaluator();

  Future<PreventionStrategyEvaluation> evaluate({
    required PreventionStrategy strategy,
    required Future<bool> Function(String conditionKey) conditionEvaluator,
  }) async {
    final cardIds = <String>[];
    final checklistIds = <String>[];
    final alerts = <String>[];
    final trace = <String>[
      'strategy=${strategy.strategyId}',
      'version=${strategy.version}',
      'style=${strategy.style.name}',
    ];

    _appendUnique(cardIds, strategy.defaultCardIds);
    _appendUnique(checklistIds, strategy.defaultChecklistIds);
    _appendUnique(alerts, strategy.defaultAlerts);

    var rationaleSummary = strategy.defaultRationaleSummary;

    for (final rule in strategy.orderedRules) {
      final matched = await conditionEvaluator(rule.conditionKey);
      trace.add('rule:${rule.id}:matched=$matched');
      if (!matched) {
        continue;
      }

      _appendUnique(cardIds, rule.cardIds);
      _appendUnique(checklistIds, rule.checklistIds);
      _appendUnique(alerts, rule.alerts);
      if (rule.rationaleSummaryOverride != null) {
        rationaleSummary = rule.rationaleSummaryOverride!;
      }
    }

    return PreventionStrategyEvaluation(
      cardIds: List.unmodifiable(cardIds),
      checklistIds: List.unmodifiable(checklistIds),
      alerts: List.unmodifiable(alerts),
      rationaleSummary: rationaleSummary,
      evaluationTrace: List.unmodifiable(trace),
    );
  }

  void _appendUnique(List<String> target, List<String> values) {
    for (final value in values) {
      if (!target.contains(value)) {
        target.add(value);
      }
    }
  }
}
