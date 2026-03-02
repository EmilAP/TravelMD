// DEPRECATED: this was originally intended for clinician-facing output.
// Public-first architecture now uses GuidanceCard, PublicPlan, etc.
// The class remains here temporarily for compatibility but should be removed
// once all consumers have migrated.

@deprecated
class ModuleResult {
  final String id;
  final String title;
  final String priority;
  final String summary;
  final List<String> actions;
  final List<String> sourceRefs;
  final String? clinicianNotes;
  final DateTime lastReviewed;

  ModuleResult({
    required this.id,
    required this.title,
    required this.priority,
    required this.summary,
    this.actions = const [],
    this.sourceRefs = const [],
    this.clinicianNotes,
    DateTime? lastReviewed,
  }) : lastReviewed = lastReviewed ?? DateTime.now();
}
