import 'package:travelmd/domain/enums/checklist_category.dart';

/// Public checklist item displayed to the user.
class ChecklistItem {
  final String id;
  final String label;
  final ChecklistCategory category;
  bool isDone;
  final String? dueBy; // YYYY-MM-DD
  final List<String> sourceRefs;

  ChecklistItem({
    required this.id,
    required this.label,
    this.category = ChecklistCategory.other,
    this.isDone = false,
    this.dueBy,
    this.sourceRefs = const [],
  });
}
