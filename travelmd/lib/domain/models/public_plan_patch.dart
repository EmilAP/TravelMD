import 'package:travelmd/domain/models/guidance_card.dart';
import 'package:travelmd/domain/models/checklist_item.dart';
import 'package:travelmd/domain/models/timeline_item.dart';

/// A patch of changes to apply to a PublicPlan: cards and checklist items to add.
class PublicPlanPatch {
  final List<GuidanceCard> cardsToAdd;
  final List<ChecklistItem> checklistToAdd;
  final List<TimelineItem> timelineToAdd;

  PublicPlanPatch({
    this.cardsToAdd = const [],
    this.checklistToAdd = const [],
    this.timelineToAdd = const [],
  });

  /// Deduplicates cards by ID and merges with existing cards.
  /// Returns a new list with no duplicate IDs (later items overwrite earlier).
  static List<GuidanceCard> deduplicateCards(
    List<GuidanceCard> existingCards,
    List<GuidanceCard> patchCards,
  ) {
    final cardMap = <String, GuidanceCard>{};
    for (final card in existingCards) {
      cardMap[card.id] = card;
    }
    for (final card in patchCards) {
      cardMap[card.id] = card;
    }
    return cardMap.values.toList();
  }

  /// Deduplicates checklist items by ID.
  static List<ChecklistItem> deduplicateChecklist(
    List<ChecklistItem> existingChecklist,
    List<ChecklistItem> patchChecklist,
  ) {
    final itemMap = <String, ChecklistItem>{};
    for (final item in existingChecklist) {
      itemMap[item.id] = item;
    }
    for (final item in patchChecklist) {
      itemMap[item.id] = item;
    }
    return itemMap.values.toList();
  }
}
