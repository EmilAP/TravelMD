import 'package:travelmd/data/repositories/content_repository.dart';
import 'package:travelmd/domain/algorithms/incident_algorithm.dart';
import 'package:travelmd/domain/algorithms/rabies_incident_algorithm.dart';
import 'package:travelmd/domain/enums/animal_type.dart';
import 'package:travelmd/domain/enums/exposure_contact_type.dart';
import 'package:travelmd/domain/models/exposure_intake.dart';
import 'package:travelmd/domain/models/guidance_card.dart';
import 'package:travelmd/domain/models/traveler_profile.dart';
import 'package:travelmd/domain/models/trip.dart';
import 'package:travelmd/domain/modules/module_definition.dart';
import 'package:travelmd/domain/modules/module_engine.dart';
import 'package:travelmd/domain/modules/module_evaluation_result.dart';
import 'package:travelmd/domain/modules/module_stream.dart';

class RabiesIncidentEngine implements ModuleEngine {
  const RabiesIncidentEngine();

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
    if (stream != ModuleStream.incidentResponse) {
      throw ArgumentError.value(
        stream,
        'stream',
        'RabiesIncidentEngine only supports incidentResponse stream',
      );
    }
    if (intake is! ExposureIntake) {
      throw ArgumentError.value(
        intake,
        'intake',
        'Rabies incident evaluation requires ExposureIntake',
      );
    }

    final exposure = intake;
    final trace = <String>[
      'algorithm=${rabiesIncidentAlgorithm.algorithmId}',
      'version=${rabiesIncidentAlgorithm.version}',
      'style=${rabiesIncidentAlgorithm.style.name}',
    ];

    final allCards = await contentRepository.getRabiesCards();
    final cardMap = {for (final card in allCards) card.id: card};

    final cardsToAdd = <GuidanceCard>[];
    for (final cardId in rabiesIncidentAlgorithm.alwaysCardIds) {
      cardsToAdd.add(_getCardOrThrow(cardMap, cardId));
    }

    final destIso3 = _getDestinationIso3(trip);
    bool isEndemic = false;
    try {
      isEndemic = await contentRepository.isRabiesEndemic(destIso3);
    } catch (_) {
      isEndemic = false;
    }

    IncidentOutcome? selectedOutcome;

    for (final rule in rabiesIncidentAlgorithm.orderedRules) {
      final matched = _evaluateCondition(
        conditionKey: rule.conditionKey,
        exposure: exposure,
        isEndemic: isEndemic,
      );
      trace.add('rule:${rule.id}:matched=$matched');
      if (matched) {
        selectedOutcome = rabiesIncidentAlgorithm.outcomes[rule.outcomeId];
        if (selectedOutcome == null) {
          throw StateError(
            'Rabies incident algorithm outcome "${rule.outcomeId}" is missing.',
          );
        }
        break;
      }
    }

    selectedOutcome ??= rabiesIncidentAlgorithm.outcomes[rabiesIncidentAlgorithm.defaultOutcomeId];
    if (selectedOutcome == null) {
      throw StateError(
        'Rabies incident algorithm default outcome "${rabiesIncidentAlgorithm.defaultOutcomeId}" is missing.',
      );
    }

    for (final cardId in selectedOutcome.cardIds) {
      cardsToAdd.add(_getCardOrThrow(cardMap, cardId));
    }
    trace.add('selected_outcome:${selectedOutcome.id}');

    return ModuleEvaluationResult(
      moduleId: module.id,
      stream: stream,
      algorithmId: rabiesIncidentAlgorithm.algorithmId,
      algorithmVersion: rabiesIncidentAlgorithm.version,
      cardsToAdd: cardsToAdd,
      checklistToAdd: const [],
      timelineToAdd: const [],
      alerts: selectedOutcome.alerts,
      rationaleSummary: selectedOutcome.rationaleSummary,
      evaluationTrace: trace,
    );
  }

  bool _evaluateCondition({
    required String conditionKey,
    required ExposureIntake exposure,
    required bool isEndemic,
  }) {
    switch (conditionKey) {
      case 'low_risk_lick_intact_non_bat':
        return exposure.animalType != AnimalType.bat &&
            exposure.contactType == ExposureContactType.lickOnIntactSkin &&
            !exposure.skinBroken &&
            !exposure.mucousMembrane;
      case 'bat_contact_any':
        return exposure.animalType == AnimalType.bat;
      case 'high_risk_contact_type':
        return [
          ExposureContactType.bite,
          ExposureContactType.scratch,
          ExposureContactType.salivaOnMucosa,
          ExposureContactType.salivaOnBrokenSkin,
        ].contains(exposure.contactType);
      case 'endemic_skin_broken_non_bat_mammal':
        return isEndemic &&
            exposure.skinBroken &&
            [AnimalType.dog, AnimalType.cat, AnimalType.monkey, AnimalType.other]
                .contains(exposure.animalType);
      default:
        throw StateError('Unknown rabies incident condition key "$conditionKey".');
    }
  }

  String _getDestinationIso3(Trip trip) {
    return trip.destinationCountry;
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
