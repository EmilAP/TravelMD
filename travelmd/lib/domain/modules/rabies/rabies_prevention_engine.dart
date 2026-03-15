import 'package:travelmd/data/repositories/content_repository.dart';
import 'package:travelmd/domain/algorithms/prevention_strategy_evaluator.dart';
import 'package:travelmd/domain/algorithms/rabies_prevention_strategy.dart';
import 'package:travelmd/domain/enums/checklist_category.dart';
import 'package:travelmd/domain/models/checklist_item.dart';
import 'package:travelmd/domain/models/guidance_card.dart';
import 'package:travelmd/domain/models/traveler_profile.dart';
import 'package:travelmd/domain/models/trip.dart';
import 'package:travelmd/domain/modules/module_definition.dart';
import 'package:travelmd/domain/modules/module_engine.dart';
import 'package:travelmd/domain/modules/module_evaluation_result.dart';
import 'package:travelmd/domain/modules/module_stream.dart';

class RabiesPreventionEngine implements ModuleEngine {
  final PreventionStrategyEvaluator _strategyEvaluator;

  const RabiesPreventionEngine({
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
    if (module.id != 'rabies') {
      throw ArgumentError.value(module.id, 'module.id', 'Unsupported module');
    }
    if (stream != ModuleStream.prevention) {
      throw ArgumentError.value(
        stream,
        'stream',
        'RabiesPreventionEngine only supports prevention stream',
      );
    }

    final destIso3 = _getDestinationIso3(trip);
    bool isEndemic = false;
    bool unknownDestination = false;
    try {
      isEndemic = await contentRepository.isRabiesEndemic(destIso3);
    } catch (_) {
      unknownDestination = true;
      isEndemic = false;
    }

    final allCards = await contentRepository.getRabiesCards();
    final cardMap = {for (final card in allCards) card.id: card};

    final evaluation = await _strategyEvaluator.evaluate(
      strategy: rabiesPreventionStrategy,
      conditionEvaluator: (conditionKey) async {
        switch (conditionKey) {
          case 'unknown_destination_rabies':
            return unknownDestination;
          case 'endemic_destination_rabies':
            return isEndemic;
          case 'endemic_child_rabies':
            return isEndemic && traveler.ageYears < 16;
          default:
            throw StateError('Unknown rabies prevention condition key "$conditionKey".');
        }
      },
    );

    final cardsToAdd = [
      for (final cardId in evaluation.cardIds) _getCardOrThrow(cardMap, cardId),
    ];
    final checklistToAdd = [
      for (final checklistId in evaluation.checklistIds) _getChecklistItemById(checklistId),
    ];

    return ModuleEvaluationResult(
      moduleId: module.id,
      stream: stream,
      algorithmId: rabiesPreventionStrategy.strategyId,
      algorithmVersion: rabiesPreventionStrategy.version,
      cardsToAdd: cardsToAdd,
      checklistToAdd: checklistToAdd,
      timelineToAdd: const [],
      alerts: evaluation.alerts,
      rationaleSummary: evaluation.rationaleSummary,
      evaluationTrace: evaluation.evaluationTrace,
    );
  }

  String _getDestinationIso3(Trip trip) {
    return trip.destinationCountry;
  }

  ChecklistItem _getChecklistItemById(String checklistId) {
    switch (checklistId) {
      case 'uncertain_destination_rabies':
        return ChecklistItem(
          id: 'uncertain_destination_rabies',
          label: 'Destination not in our database-ask your doctor about rabies risk',
          category: ChecklistCategory.emergency,
        );
      case 'rabies_checklist_hospital_address':
        return ChecklistItem(
        id: 'rabies_checklist_hospital_address',
        label: 'Save the address and phone of a nearby clinic or hospital',
        category: ChecklistCategory.emergency,
        );
      case 'rabies_checklist_soap_sanitizer':
        return ChecklistItem(
        id: 'rabies_checklist_soap_sanitizer',
        label: 'Pack soap, hand sanitizer, or alcohol wipes for wound cleaning',
        category: ChecklistCategory.safety,
        );
      case 'rabies_checklist_discuss_vaccines':
        return ChecklistItem(
        id: 'rabies_checklist_discuss_vaccines',
        label:
            'Ask your doctor about pre-exposure rabies vaccine if visiting endemic areas for extended periods',
        category: ChecklistCategory.vaccines,
        );
      default:
        throw StateError('Unknown rabies checklist item "$checklistId".');
    }
  }

  GuidanceCard _getCardOrThrow(Map<String, GuidanceCard> cardMap, String cardId) {
    final card = cardMap[cardId];
    if (card == null) {
      throw StateError('Rabies card "$cardId" not found in YAML content. '
          'Verify assets/content/rabies_public.yaml contains this card ID.');
    }
    return card;
  }
}
