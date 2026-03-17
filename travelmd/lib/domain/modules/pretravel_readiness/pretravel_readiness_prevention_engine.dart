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

class PretravelReadinessPreventionEngine implements ModuleEngine {
  const PretravelReadinessPreventionEngine();

  static const List<String> _defaultCardIds = [
    'pretravel_visit_early',
    'pretravel_review_vaccines',
    'pretravel_pack_medicines',
    'pretravel_check_insurance',
    'pretravel_plan_care_access',
    'pretravel_build_health_kit',
    'pretravel_save_emergency_contacts',
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
    if (module.id != 'pretravel_readiness') {
      throw ArgumentError.value(module.id, 'module.id', 'Unsupported module');
    }
    if (stream != ModuleStream.prevention) {
      throw ArgumentError.value(
        stream,
        'stream',
        'PretravelReadinessPreventionEngine only supports prevention stream',
      );
    }

    final allCards = await contentRepository.getPretravelReadinessCards();
    final cardMap = {for (final card in allCards) card.id: card};

    final cardsToAdd = <GuidanceCard>[
      for (final cardId in _defaultCardIds) _getCardOrThrow(cardMap, cardId),
    ];

    final checklistItems = <ChecklistItem>[
      ChecklistItem(
        id: 'pretravel_book_health_visit',
        label: 'Book a pre-travel health visit.',
        timing: ContentTiming.beforeTravel,
        isCritical: true,
        category: ChecklistCategory.other,
      ),
      ChecklistItem(
        id: 'pretravel_review_vaccine_needs',
        label: 'Review vaccine recommendations for your itinerary.',
        timing: ContentTiming.beforeTravel,
        category: ChecklistCategory.vaccines,
      ),
      ChecklistItem(
        id: 'pretravel_refill_prescriptions',
        label: 'Refill routine medicines and pack prescription copies.',
        timing: ContentTiming.beforeTravel,
        isCritical: true,
        category: ChecklistCategory.meds,
      ),
      ChecklistItem(
        id: 'pretravel_confirm_insurance',
        label: 'Confirm travel insurance and emergency care coverage details.',
        timing: ContentTiming.beforeTravel,
        category: ChecklistCategory.documents,
      ),
      ChecklistItem(
        id: 'pretravel_save_local_care',
        label: 'Save one clinic or hospital contact near your destination.',
        timing: ContentTiming.beforeTravel,
        isCritical: true,
        category: ChecklistCategory.emergency,
      ),
    ];

    return ModuleEvaluationResult(
      moduleId: module.id,
      stream: stream,
      algorithmId: 'pretravel_readiness_defaults',
      algorithmVersion: '1.0.0',
      cardsToAdd: cardsToAdd,
      checklists: [
        ModuleChecklist(
          checklistId: 'pretravel_readiness_basics',
          items: checklistItems,
        ),
      ],
      checklistToAdd: checklistItems,
      timelineToAdd: const [],
      alerts: const [],
      rationaleSummary:
          'Informational guide with essential pre-departure preparation steps for most travelers.',
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
        'Pretravel readiness card "$cardId" not found in YAML content. Verify assets/content/pretravel_readiness_public.yaml contains this card ID.',
      );
    }
    return card;
  }
}
