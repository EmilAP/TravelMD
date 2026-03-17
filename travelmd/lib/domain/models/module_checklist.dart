import 'package:travelmd/domain/models/checklist_item.dart';

class ModuleChecklist {
  final String checklistId;
  final List<ChecklistItem> items;

  const ModuleChecklist({
    required this.checklistId,
    required this.items,
  });
}