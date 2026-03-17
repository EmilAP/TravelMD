import 'package:travelmd/data/repositories/content_repository.dart';
import 'package:travelmd/domain/enums/checklist_category.dart';
import 'package:travelmd/domain/enums/content_timing.dart';
import 'package:travelmd/domain/models/checklist_item.dart';
import 'package:travelmd/domain/models/guidance_card.dart';
import 'package:travelmd/domain/models/module_checklist.dart';
import 'package:travelmd/domain/models/traveler_profile.dart';
import 'package:travelmd/domain/models/trip.dart';
import 'package:travelmd/domain/modules/module_definition.dart';
import 'package:travelmd/domain/modules/module_engine.dart';
import 'package:travelmd/domain/modules/module_evaluation_result.dart';
import 'package:travelmd/domain/modules/module_stream.dart';

class TravelInjuryPreventionEngine implements ModuleEngine {
  const TravelInjuryPreventionEngine();

  static const List<String> _defaultCardIds = [
    'injury_safer_transport_choices',
    'injury_helmets_and_seatbelts',
    'injury_heat_and_sun_protection',
    'injury_alcohol_risk_awareness',
    'injury_activity_fit_and_gear',
    'injury_walking_and_night_movement',
    'injury_plan_help_access',
  ];

  @override
  Future<ModuleEvaluationResult> evaluateModule({
    required ModuleDefinition module,
    required ModuleStream stream,
    required Trip trip,
    required TravelerProfile traveler,
    Object? intake,
    required ContentRepository contentRepository,
  }) async {
    if (module.id != 'travel_injury_prevention') {
      throw ArgumentError.value(module.id, 'module.id', 'Unsupported module');
    }
    if (stream != ModuleStream.prevention) {
      throw ArgumentError.value(
        stream,
        'stream',
        'TravelInjuryPreventionEngine only supports prevention stream',
      );
    }

    final allCards = await contentRepository.getTravelInjuryPreventionCards();
    final cardMap = {for (final card in allCards) card.id: card};

    final cardsToAdd = <GuidanceCard>[
      for (final cardId in _defaultCardIds) _getCardOrThrow(cardMap, cardId),
    ];

    final checklistItems = <ChecklistItem>[
      ChecklistItem(
        id: 'injury_pack_sun_and_first_aid',
        label: 'Pack sun protection and a basic first-aid kit.',
        timing: ContentTiming.beforeTravel,
        category: ChecklistCategory.safety,
      ),
      ChecklistItem(
        id: 'injury_transport_plan',
        label: 'Choose safer transportation options in advance.',
        timing: ContentTiming.beforeTravel,
        isCritical: true,
        category: ChecklistCategory.safety,
      ),
      ChecklistItem(
        id: 'injury_helmet_seatbelt_rule',
        label: 'Commit to using helmets and seatbelts whenever available.',
        timing: ContentTiming.duringTravel,
        isCritical: true,
        category: ChecklistCategory.safety,
      ),
      ChecklistItem(
        id: 'injury_heat_warning_signs',
        label: 'Review heat illness warning signs and response basics.',
        timing: ContentTiming.both,
        category: ChecklistCategory.emergency,
      ),
      ChecklistItem(
        id: 'injury_save_urgent_contact',
        label: 'Save one urgent care contact for your destination.',
        timing: ContentTiming.beforeTravel,
        isCritical: true,
        category: ChecklistCategory.emergency,
      ),
    ];

    return ModuleEvaluationResult(
      moduleId: module.id,
      stream: stream,
      algorithmId: 'travel_injury_prevention_defaults',
      algorithmVersion: '1.0.0',
      cardsToAdd: cardsToAdd,
      checklists: [
        ModuleChecklist(
          checklistId: 'travel_injury_prevention_basics',
          items: checklistItems,
        ),
      ],
      checklistToAdd: checklistItems,
      timelineToAdd: const [],
      alerts: const [],
      rationaleSummary:
          'Informational guide focused on common travel injury risks and prevention habits.',
      evaluationTrace: const [
        'default_cards_selected',
        'default_checklist_selected',
      ],
    );
  }

  GuidanceCard _getCardOrThrow(Map<String, GuidanceCard> cardMap, String cardId) {
    final card = cardMap[cardId];
    if (card == null) {
      throw StateError(
        'Travel injury prevention card "$cardId" not found in YAML content. Verify assets/content/travel_injury_prevention_public.yaml contains this card ID.',
      );
    }
    return card;
  }
}
