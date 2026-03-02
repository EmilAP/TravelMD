import 'package:flutter_test/flutter_test.dart';
import 'package:travelmd/data/parsers/sources_parser.dart';

void main() {
  group('SourcesParser', () {
    const parser = SourcesParser();

    test('parses valid sources.yaml', () {
      const yaml = '''
sources:
  who_rabies:
    title: "Rabies fact sheet"
    organization: "WHO"
    url: "https://who.int"
    lastReviewed: "2025-12-01"
  cdc_rabies:
    title: "CDC Rabies"
    organization: "CDC"
    url: "https://cdc.gov"
    lastReviewed: "2025-10-15"
''';

      final result = parser.parse(yaml);
      expect(result.length, 2);
      expect(result['who_rabies']?.title, 'Rabies fact sheet');
      expect(result['cdc_rabies']?.organization, 'CDC');
      expect(result['who_rabies']?.lastReviewed, '2025-12-01');
    });

    test('throws on missing "sources" key', () {
      const yaml = 'other: {}';
      expect(() => parser.parse(yaml), throwsA(isA<FormatException>()));
    });

    test('throws on missing required fields', () {
      const yaml = '''
sources:
  bad_source:
    title: "Missing org"
    url: "https://example.com"
''';
      expect(() => parser.parse(yaml), throwsA(isA<FormatException>()));
    });

    test('throws on invalid lastReviewed date format', () {
      const yaml = '''
sources:
  bad_date:
    title: "Test"
    organization: "Test"
    url: "https://test.com"
    lastReviewed: "2025/12/01"
''';
      expect(() => parser.parse(yaml), throwsA(isA<FormatException>()));
    });

    test('accepts valid YYYY-MM-DD dates', () {
      const yaml = '''
sources:
  date_test:
    title: "Test"
    organization: "Test"
    url: "https://test.com"
    lastReviewed: "2026-01-15"
''';
      final result = parser.parse(yaml);
      expect(result['date_test']?.lastReviewed, '2026-01-15');
    });
  });
}
