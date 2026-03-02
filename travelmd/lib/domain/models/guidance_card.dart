import 'package:travelmd/domain/enums/urgency.dart';
import 'package:travelmd/domain/enums/when_to_do.dart';

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
    this.summary = '',
    this.whyThisMatters = '',
    this.whenToDoIt = WhenToDo.now,
    this.steps = const [],
    this.sourceRefs = const [],
  });
}
