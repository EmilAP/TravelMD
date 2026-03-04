import 'package:isar/isar.dart';

part 'plan_selection_entity.g.dart';

@collection
class PlanSelectionEntity {
  Id id = Isar.autoIncrement;

  late int tripId;
  late int travelerId;
  
  /// Card IDs selected for this plan (from YAML, e.g., 'rabies_prevent_avoid_animals').
  /// Cards are resolved at runtime from ContentRepository.
  late List<String> selectedCardIds;
  
  late DateTime createdAt;
  late DateTime updatedAt;
}
