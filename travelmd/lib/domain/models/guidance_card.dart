import 'package:travelmd/domain/enums/urgency.dart';
import 'package:travelmd/domain/enums/when_to_do.dart';
import 'package:travelmd/domain/enums/card_priority.dart';
import 'package:travelmd/domain/enums/content_timing.dart';

/// Public-facing action step for a guidance card.
class ActionStep {
  final String label;
  final String? details;
  final String? deepLinkRoute;

  ActionStep({
    required this.label,
    this.details,
    this.deepLinkRoute,
  });
}

/// A single piece of guidance shown to the user.
class GuidanceCard {
  final String id;
  final String title;
  final Urgency urgency;
  final CardPriority priority;
  final ContentTiming timing;
  final List<String> tags;
  final List<String> relatedModules;
  final String summary;
  final String whyThisMatters;
  final WhenToDo whenToDoIt;
  final List<ActionStep> steps;
  final List<String> sourceRefs;
  final String lastReviewed; // YYYY-MM-DD (required)

  GuidanceCard({
    required this.id,
    required this.title,
    required this.lastReviewed,
    this.urgency = Urgency.routine,
    this.priority = CardPriority.medium,
    this.timing = ContentTiming.both,
    this.tags = const [],
    this.relatedModules = const [],
    this.summary = '',
    this.whyThisMatters = '',
    this.whenToDoIt = WhenToDo.now,
    this.steps = const [],
    this.sourceRefs = const [],
  });
}
