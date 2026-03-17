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

class FoodWaterSafetyPreventionEngine implements ModuleEngine {
  const FoodWaterSafetyPreventionEngine();

  static const List<String> _defaultCardIds = [
    'foodwater_choose_hot_food',
    'foodwater_select_safer_water',
    'foodwater_hand_hygiene',
    'foodwater_hydrate_safely',
    'foodwater_pack_ors',
    'foodwater_know_when_to_seek_care',
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
    if (module.id != 'food_water_safety') {
      throw ArgumentError.value(module.id, 'module.id', 'Unsupported module');
    }
    if (stream != ModuleStream.prevention) {
      throw ArgumentError.value(
        stream,
        'stream',
        'FoodWaterSafetyPreventionEngine only supports prevention stream',
      );
    }

    final allCards = await contentRepository.getFoodWaterSafetyCards();
    final cardMap = {for (final card in allCards) card.id: card};

    final cardsToAdd = <GuidanceCard>[
      for (final cardId in _defaultCardIds) _getCardOrThrow(cardMap, cardId),
    ];

    final checklistItems = <ChecklistItem>[
      ChecklistItem(
        id: 'foodwater_pack_hand_sanitizer',
        label: 'Pack hand sanitizer and handwashing supplies.',
        timing: ContentTiming.beforeTravel,
        category: ChecklistCategory.other,
      ),
      ChecklistItem(
        id: 'foodwater_plan_safe_water',
        label: 'Plan your safer drinking water options before arrival.',
        timing: ContentTiming.beforeTravel,
        isCritical: true,
        category: ChecklistCategory.safety,
      ),
      ChecklistItem(
        id: 'foodwater_pack_ors_kit',
        label: 'Pack oral rehydration packets in your health kit.',
        timing: ContentTiming.beforeTravel,
        category: ChecklistCategory.meds,
      ),
      ChecklistItem(
        id: 'foodwater_use_food_habits_daily',
        label: 'Use safer food and water habits throughout your trip.',
        timing: ContentTiming.duringTravel,
        isCritical: true,
        category: ChecklistCategory.safety,
      ),
      ChecklistItem(
        id: 'foodwater_watch_warning_signs',
        label: 'Review warning signs that need medical care.',
        timing: ContentTiming.both,
        isCritical: true,
        category: ChecklistCategory.emergency,
      ),
    ];

    return ModuleEvaluationResult(
      moduleId: module.id,
      stream: stream,
      algorithmId: 'food_water_safety_defaults',
      algorithmVersion: '1.0.0',
      cardsToAdd: cardsToAdd,
      checklists: [
        ModuleChecklist(
          checklistId: 'food_water_safety_basics',
          items: checklistItems,
        ),
      ],
      checklistToAdd: checklistItems,
      timelineToAdd: const [],
      alerts: const [],
      rationaleSummary:
          'Informational guide focused on practical food, water, and hydration habits to reduce illness risk.',
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
        'Food and water safety card "$cardId" not found in YAML content. Verify assets/content/food_water_safety_public.yaml contains this card ID.',
      );
    }
    return card;
  }
}
