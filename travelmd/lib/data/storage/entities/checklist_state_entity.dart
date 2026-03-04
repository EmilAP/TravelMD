import 'package:isar/isar.dart';

part 'checklist_state_entity.g.dart';

@collection
class ChecklistStateEntity {
  Id id = Isar.autoIncrement;

  late int planSelectionId;
  
  /// Stable ID of the checklist item (from RabiesPlanBuilder, e.g., 'rabies_checklist_hospital_address').
  late String checklistItemId;
  
  late bool isDone;
}
