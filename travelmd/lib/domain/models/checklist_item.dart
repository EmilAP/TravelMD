import 'package:travelmd/domain/enums/checklist_category.dart';
import 'package:travelmd/domain/enums/content_timing.dart';

/// Public checklist item displayed to the user.
class ChecklistItem {
  final String id;
  final String label;
  final ContentTiming timing;
  final bool isCritical;
  final ChecklistCategory category;
  bool isDone;
  final String? dueBy; // YYYY-MM-DD
  final List<String> sourceRefs;

  ChecklistItem({
    required this.id,
    required this.label,
    this.timing = ContentTiming.both,
    this.isCritical = false,
    this.category = ChecklistCategory.other,
    this.isDone = false,
    this.dueBy,
    this.sourceRefs = const [],
  });
}
