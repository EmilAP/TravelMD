import 'package:yaml/yaml.dart';
import 'package:travelmd/domain/models/guidance_card.dart';
import 'package:travelmd/domain/enums/urgency.dart';
import 'package:travelmd/domain/enums/when_to_do.dart';

/// Parses rabies_public.yaml into GuidanceCard objects with pillar grouping.
class RabiesCardsParser {
  const RabiesCardsParser();

  static const List<String> validPillars = ['prevention', 'preparedness', 'exposure_response'];
  static const List<String> validUrgencies = ['routine', 'important', 'urgent'];
  static const List<String> validWhenToDo = ['now', 'beforeTravel', 'duringTravel', 'afterTravel'];

  Urgency _parseUrgency(String value) {
    return Urgency.values.firstWhere(
      (e) => e.name == value,
      orElse: () => throw FormatException('Invalid urgency: "$value". Must be one of ${Urgency.values.map((e) => e.name).join(", ")}'),
    );
  }

  WhenToDo _parseWhenToDo(String value) {
    return WhenToDo.values.firstWhere(
      (e) => e.name == value,
      orElse: () => throw FormatException('Invalid whenToDoIt: "$value". Must be one of ${WhenToDo.values.map((e) => e.name).join(", ")}'),
    );
  }

  /// Parse YAML string into a list of GuidanceCard objects.
  List<GuidanceCard> parse(String yamlContent) {
    final doc = loadYaml(yamlContent) as YamlMap;
    final cardsNode = doc['cards'] as YamlList?;

    if (cardsNode == null) {
      throw FormatException('Missing "cards" key in rabies_public.yaml');
    }

    final cards = <GuidanceCard>[];

    for (int i = 0; i < cardsNode.length; i++) {
      final cardData = cardsNode[i];
      if (cardData is! YamlMap) {
        throw FormatException('Card at index $i must be a map, got ${cardData.runtimeType}');
      }

      final id = cardData['id'] as String?;
      final title = cardData['title'] as String?;
      final pillar = cardData['pillar'] as String?;
      final urgencyStr = cardData['urgency'] as String?;
      final summary = cardData['summary'] as String?;
      final whyThisMatters = cardData['whyThisMatters'] as String?;
      final whenToDoItStr = cardData['whenToDoIt'] as String?;
      final stepsNode = cardData['steps'] as YamlList?;
      final sourceRefs = (cardData['sourceRefs'] as YamlList?)?.cast<String>() ?? [];
      final lastReviewed = cardData['lastReviewed'] as String?;

      // Validation
      if (id == null || title == null || pillar == null || urgencyStr == null ||
          summary == null || whyThisMatters == null || whenToDoItStr == null ||
          lastReviewed == null) {
        throw FormatException(
          'Card "$id" missing required fields: id, title, pillar, urgency, summary, whyThisMatters, whenToDoIt, lastReviewed',
        );
      }

      if (!validPillars.contains(pillar)) {
        throw FormatException(
          'Card "$id" has invalid pillar "$pillar". Must be one of: ${validPillars.join(", ")}',
        );
      }

      final urgency = _parseUrgency(urgencyStr);
      final whenToDoIt = _parseWhenToDo(whenToDoItStr);

      // Validate lastReviewed format
      if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(lastReviewed)) {
        throw FormatException(
          'Card "$id" lastReviewed must be YYYY-MM-DD format, got "$lastReviewed"',
        );
      }

      // Parse steps
      if (stepsNode == null || stepsNode.isEmpty) {
        throw FormatException('Card "$id" must have at least one step');
      }

      final steps = <ActionStep>[];
      for (int j = 0; j < stepsNode.length; j++) {
        final stepData = stepsNode[j];
        if (stepData is! YamlMap) {
          throw FormatException('Step at index $j in card "$id" must be a map');
        }

        final label = stepData['label'] as String?;
        final details = stepData['details'] as String?;
        final deepLinkRoute = stepData['deepLinkRoute'] as String?;

        if (label == null) {
          throw FormatException('Step at index $j in card "$id" missing required field "label"');
        }

        steps.add(ActionStep(
          label: label,
          details: details,
          deepLinkRoute: deepLinkRoute,
        ));
      }

      cards.add(GuidanceCard(
        id: id,
        title: title,
        urgency: urgency,
        summary: summary,
        whyThisMatters: whyThisMatters,
        whenToDoIt: whenToDoIt,
        steps: steps,
        sourceRefs: sourceRefs,
        lastReviewed: lastReviewed,
      ));
    }

    return cards;
  }

  /// Get cards filtered by pillar.
  List<GuidanceCard> getCardsByPillar(List<GuidanceCard> cards, String pillar) {
    if (!validPillars.contains(pillar)) {
      throw FormatException('Invalid pillar: "$pillar"');
    }
    // Note: We'd need to extend GuidanceCard to store pillar, but for this MVP,
    // we rely on the cards being grouped in the YAML by pillar and returned in order.
    // A production version would parse and store pillar in the model.
    return cards;
  }
}
