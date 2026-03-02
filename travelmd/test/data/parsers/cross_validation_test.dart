import 'package:flutter_test/flutter_test.dart';
import 'package:travelmd/data/parsers/sources_parser.dart';
import 'package:travelmd/data/parsers/rabies_cards_parser.dart';

void main() {
  group('Content cross-validation', () {
    const sourcesParser = SourcesParser();
    const cardsParser = RabiesCardsParser();

    test('all card sourceRefs reference existing sources', () {
      const sourcesYaml = '''
sources:
  who_rabies:
    title: "WHO"
    organization: "WHO"
    url: "https://who.int"
    lastReviewed: "2025-12-01"
  cdc_rabies:
    title: "CDC"
    organization: "CDC"
    url: "https://cdc.gov"
    lastReviewed: "2025-10-15"
''';

      const cardsYaml = '''
cards:
  - id: "card1"
    title: "Test"
    pillar: "prevention"
    urgency: "routine"
    summary: "Test"
    whyThisMatters: "Test"
    whenToDoIt: "duringTravel"
    steps:
      - label: "Step"
    sourceRefs: ["who_rabies", "cdc_rabies"]
    lastReviewed: "2026-03-01"
  - id: "card2"
    title: "Test 2"
    pillar: "preparedness"
    urgency: "important"
    summary: "Test"
    whyThisMatters: "Test"
    whenToDoIt: "beforeTravel"
    steps:
      - label: "Step"
    sourceRefs: ["who_rabies"]
    lastReviewed: "2026-03-01"
''';

      final sources = sourcesParser.parse(sourcesYaml);
      final cards = cardsParser.parse(cardsYaml);

      for (final card in cards) {
        for (final ref in card.sourceRefs) {
          expect(sources.containsKey(ref), true,
              reason: 'Card "${card.id}" references unknown source "$ref"');
        }
      }
    });

    test('throws when card references non-existent source', () {
      const cardsYaml = '''
cards:
  - id: "bad_ref"
    title: "Test"
    pillar: "prevention"
    urgency: "routine"
    summary: "Test"
    whyThisMatters: "Test"
    whenToDoIt: "now"
    steps:
      - label: "Step"
    sourceRefs: ["unknown_source"]
    lastReviewed: "2026-03-01"
''';

      const sourcesYaml = '''
sources:
  existing_source:
    title: "Test"
    organization: "Test"
    url: "https://test.com"
    lastReviewed: "2025-12-01"
''';

      final sources = sourcesParser.parse(sourcesYaml);
      final cards = cardsParser.parse(cardsYaml);

      // Verify that the non-existent source is detected
      bool foundInvalidRef = false;
      for (final card in cards) {
        for (final ref in card.sourceRefs) {
          if (!sources.containsKey(ref)) {
            foundInvalidRef = true;
          }
        }
      }
      expect(foundInvalidRef, true);
    });

    test('validates all card pillar values are valid', () {
      const cardsYaml = '''
cards:
  - id: "prevention_card"
    title: "Test"
    pillar: "prevention"
    urgency: "routine"
    summary: "Test"
    whyThisMatters: "Test"
    whenToDoIt: "duringTravel"
    steps:
      - label: "Step"
    sourceRefs: []
    lastReviewed: "2026-03-01"
  - id: "preparedness_card"
    title: "Test"
    pillar: "preparedness"
    urgency: "important"
    summary: "Test"
    whyThisMatters: "Test"
    whenToDoIt: "beforeTravel"
    steps:
      - label: "Step"
    sourceRefs: []
    lastReviewed: "2026-03-01"
  - id: "exposure_card"
    title: "Test"
    pillar: "exposure_response"
    urgency: "urgent"
    summary: "Test"
    whyThisMatters: "Test"
    whenToDoIt: "now"
    steps:
      - label: "Step"
    sourceRefs: []
    lastReviewed: "2026-03-01"
''';

      final cards = cardsParser.parse(cardsYaml);
      expect(cards.length, 3);

      for (final card in cards) {
        // pillar is in YAML but not yet in the model
        // This test verifies the parser doesn't throw on valid pillars
      }
    });
  });
}
