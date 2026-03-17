import 'package:travelmd/domain/models/checklist_item.dart';
import 'package:travelmd/domain/models/guidance_card.dart';
import 'package:travelmd/domain/models/module_checklist.dart';
import 'package:travelmd/domain/models/timeline_item.dart';
import 'package:travelmd/domain/modules/module_stream.dart';

class ModuleEvaluationResult {
  final String moduleId;
  final ModuleStream stream;
  final String? algorithmId;
  final String? algorithmVersion;
  final List<GuidanceCard> cardsToAdd;
  final List<ModuleChecklist> checklists;
  final List<ChecklistItem> checklistToAdd;
  final List<TimelineItem> timelineToAdd;
  final List<String> alerts;
  final String? rationaleSummary;
  final List<String> evaluationTrace;

  const ModuleEvaluationResult({
    required this.moduleId,
    required this.stream,
    this.algorithmId,
    this.algorithmVersion,
    this.cardsToAdd = const [],
    this.checklists = const [],
    this.checklistToAdd = const [],
    this.timelineToAdd = const [],
    this.alerts = const [],
    this.rationaleSummary,
    this.evaluationTrace = const [],
  });
}
