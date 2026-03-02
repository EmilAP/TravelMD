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

  /// Create a copy of this plan with updated fields.
  PublicPlan copyWith({
    String? id,
    String? tripId,
    String? travelerId,
    String? title,
    String? summary,
    List<GuidanceCard>? cards,
    List<ChecklistItem>? checklist,
    List<TimelineItem>? timeline,
  }) {
    return PublicPlan(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      travelerId: travelerId ?? this.travelerId,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      cards: cards ?? this.cards,
      checklist: checklist ?? this.checklist,
      timeline: timeline ?? this.timeline,
    );
  }
}
