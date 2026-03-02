/// An item representing a point on a timeline (e.g. vaccine dates, follow-up).
class TimelineItem {
  final DateTime date;
  final String description;

  TimelineItem({
    required this.date,
    required this.description,
  });
}
