import 'package:travelmd/data/repositories/content_repository.dart';
import 'package:travelmd/domain/algorithms/malaria_prevention_strategy.dart';
import 'package:travelmd/domain/algorithms/prevention_strategy_evaluator.dart';
import 'package:travelmd/domain/models/guidance_card.dart';
import 'package:travelmd/domain/models/traveler_profile.dart';
import 'package:travelmd/domain/models/trip.dart';
import 'package:travelmd/domain/modules/module_definition.dart';
import 'package:travelmd/domain/modules/module_engine.dart';
import 'package:travelmd/domain/modules/module_evaluation_result.dart';
import 'package:travelmd/domain/modules/module_stream.dart';

/// Prevention-only malaria engine used to validate module extensibility.
class MalariaPreventionEngine implements ModuleEngine {
  final PreventionStrategyEvaluator _strategyEvaluator;

  const MalariaPreventionEngine({
    PreventionStrategyEvaluator strategyEvaluator = const PreventionStrategyEvaluator(),
  }) : _strategyEvaluator = strategyEvaluator;

  @override
  Future<ModuleEvaluationResult> evaluateModule({
    required ModuleDefinition module,
    required ModuleStream stream,
    required Trip trip,
    required TravelerProfile traveler,
    Object? intake,
    required ContentRepository contentRepository,
  }) async {
    if (module.id != 'malaria') {
      throw ArgumentError.value(module.id, 'module.id', 'Unsupported module');
    }
    if (stream != ModuleStream.prevention) {
      throw ArgumentError.value(
        stream,
        'stream',
        'MalariaPreventionEngine only supports prevention stream',
      );
    }

    final allCards = await contentRepository.getMalariaCards();
    final cardMap = {for (final card in allCards) card.id: card};

    final destinationIso3 = trip.destinationCountry;
    bool malariaRelevant;
    try {
      malariaRelevant = await contentRepository.isMalariaRelevant(destinationIso3);
    } catch (_) {
      malariaRelevant = false;
    }

    final evaluation = await _strategyEvaluator.evaluate(
      strategy: malariaPreventionStrategy,
      conditionEvaluator: (conditionKey) async {
        switch (conditionKey) {
          case 'malaria_relevant_destination':
            return malariaRelevant;
          case 'malaria_not_relevant_destination':
            return !malariaRelevant;
          default:
            throw StateError('Unknown malaria prevention condition key "$conditionKey".');
        }
      },
    );

    final cardsToAdd = <GuidanceCard>[
      for (final cardId in evaluation.cardIds) _getCardOrThrow(cardMap, cardId),
    ];

    return ModuleEvaluationResult(
      moduleId: module.id,
      stream: stream,
      algorithmId: malariaPreventionStrategy.strategyId,
      algorithmVersion: malariaPreventionStrategy.version,
      cardsToAdd: cardsToAdd,
      checklistToAdd: const [],
      timelineToAdd: const [],
      alerts: evaluation.alerts,
      rationaleSummary: evaluation.rationaleSummary,
      evaluationTrace: evaluation.evaluationTrace,
    );
  }

  GuidanceCard _getCardOrThrow(Map<String, GuidanceCard> cardMap, String cardId) {
    final card = cardMap[cardId];
    if (card == null) {
      throw StateError(
        'Malaria card "$cardId" not found in YAML content. Verify assets/content/malaria_public.yaml contains this card ID.',
      );
    }
    return card;
  }
}
