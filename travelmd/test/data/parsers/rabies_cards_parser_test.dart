import 'package:flutter_test/flutter_test.dart';
import 'package:travelmd/data/parsers/rabies_cards_parser.dart';
import 'package:travelmd/domain/enums/urgency.dart';
import 'package:travelmd/domain/enums/when_to_do.dart';

void main() {
  group('RabiesCardsParser', () {
    const parser = RabiesCardsParser();

    test('parses valid guidance cards', () {
      const yaml = '''
cards:
  - id: "test_card_1"
    title: "Test Card"
    pillar: "prevention"
    urgency: "routine"
    summary: "Summary text"
    whyThisMatters: "Why text"
    whenToDoIt: "duringTravel"
    steps:
      - label: "Step 1"
        details: "Do this"
      - label: "Step 2"
    sourceRefs: ["source_1", "source_2"]
    lastReviewed: "2026-03-01"
''';

      final cards = parser.parse(yaml);
      expect(cards.length, 1);
      final card = cards.first;
      expect(card.id, 'test_card_1');
      expect(card.title, 'Test Card');
      expect(card.urgency, Urgency.routine);
      expect(card.whenToDoIt, WhenToDo.duringTravel);
      expect(card.steps.length, 2);
      expect(card.steps[0].label, 'Step 1');
      expect(card.sourceRefs.length, 2);
    });

    test('throws on missing required card fields', () {
      const yaml = '''
cards:
  - id: "incomplete"
    title: "Missing pillar"
    urgency: "routine"
''';
      expect(() => parser.parse(yaml), throwsA(isA<FormatException>()));
    });

    test('throws on invalid pillar value', () {
      const yaml = '''
cards:
  - id: "bad_pillar"
    title: "Test"
    pillar: "invalid_pillar"
    urgency: "routine"
    summary: "Test"
    whyThisMatters: "Test"
    whenToDoIt: "now"
    steps:
      - label: "Step"
    sourceRefs: []
    lastReviewed: "2026-03-01"
''';
      expect(() => parser.parse(yaml), throwsA(isA<FormatException>()));
    });

    test('throws on invalid urgency enum', () {
      const yaml = '''
cards:
  - id: "bad_urgency"
    title: "Test"
    pillar: "prevention"
    urgency: "critical"
    summary: "Test"
    whyThisMatters: "Test"
    whenToDoIt: "now"
    steps:
      - label: "Step"
    sourceRefs: []
    lastReviewed: "2026-03-01"
''';
      expect(() => parser.parse(yaml), throwsA(isA<FormatException>()));
    });

    test('throws on invalid whenToDoIt enum', () {
      const yaml = '''
cards:
  - id: "bad_when"
    title: "Test"
    pillar: "prevention"
    urgency: "routine"
    summary: "Test"
    whyThisMatters: "Test"
    whenToDoIt: "nextWeek"
    steps:
      - label: "Step"
    sourceRefs: []
    lastReviewed: "2026-03-01"
''';
      expect(() => parser.parse(yaml), throwsA(isA<FormatException>()));
    });

    test('throws on invalid lastReviewed date format', () {
      const yaml = '''
cards:
  - id: "bad_date"
    title: "Test"
    pillar: "prevention"
    urgency: "routine"
    summary: "Test"
    whyThisMatters: "Test"
    whenToDoIt: "now"
    steps:
      - label: "Step"
    sourceRefs: []
    lastReviewed: "03/01/2026"
''';
      expect(() => parser.parse(yaml), throwsA(isA<FormatException>()));
    });

    test('throws on empty steps list', () {
      const yaml = '''
cards:
  - id: "no_steps"
    title: "Test"
    pillar: "prevention"
    urgency: "routine"
    summary: "Test"
    whyThisMatters: "Test"
    whenToDoIt: "now"
    steps: []
    sourceRefs: []
    lastReviewed: "2026-03-01"
''';
      expect(() => parser.parse(yaml), throwsA(isA<FormatException>()));
    });

    test('throws on missing step label', () {
      const yaml = '''
cards:
  - id: "bad_step"
    title: "Test"
    pillar: "prevention"
    urgency: "routine"
    summary: "Test"
    whyThisMatters: "Test"
    whenToDoIt: "now"
    steps:
      - details: "Missing label"
    sourceRefs: []
    lastReviewed: "2026-03-01"
''';
      expect(() => parser.parse(yaml), throwsA(isA<FormatException>()));
    });

    test('accepts optional step details and deepLinkRoute', () {
      const yaml = '''
cards:
  - id: "optional_test"
    title: "Test"
    pillar: "prevention"
    urgency: "routine"
    summary: "Test"
    whyThisMatters: "Test"
    whenToDoIt: "now"
    steps:
      - label: "Step 1"
      - label: "Step 2"
        details: "Extra info"
      - label: "Step 3"
        deepLinkRoute: "/some/route"
    sourceRefs: []
    lastReviewed: "2026-03-01"
''';
      final cards = parser.parse(yaml);
      expect(cards.length, 1);
      expect(cards[0].steps[0].details, isNull);
      expect(cards[0].steps[1].details, 'Extra info');
      expect(cards[0].steps[2].deepLinkRoute, '/some/route');
    });

    test('validates all valid pillar values', () {
      for (final pillar in ['prevention', 'preparedness', 'exposure_response']) {
        final yaml = '''
cards:
  - id: "pillar_test"
    title: "Test"
    pillar: "$pillar"
    urgency: "routine"
    summary: "Test"
    whyThisMatters: "Test"
    whenToDoIt: "now"
    steps:
      - label: "Step"
    sourceRefs: []
    lastReviewed: "2026-03-01"
''';
        expect(() => parser.parse(yaml), returnsNormally);
      }
    });
  });
}
