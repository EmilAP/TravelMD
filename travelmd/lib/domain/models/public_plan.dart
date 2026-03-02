import 'package:travelmd/domain/models/guidance_card.dart';
import 'package:travelmd/domain/models/checklist_item.dart';
import 'package:travelmd/domain/models/timeline_item.dart';

/// A public-facing plan generated from user input; contains guidance cards,
/// a checklist, and a high-level timeline.
class PublicPlan {
  final String id;
  final String tripId;
  final String travelerId;
  final String title;
  final String summary;
  final List<GuidanceCard> cards;
  final List<ChecklistItem> checklist;
  final List<TimelineItem> timeline;

  PublicPlan({
    required this.id,
    required this.tripId,
    required this.travelerId,
    required this.title,
    required this.summary,
    this.cards = const [],
    this.checklist = const [],
    this.timeline = const [],
  });
}
