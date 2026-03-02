import 'package:flutter_test/flutter_test.dart';
import 'package:travelmd/data/parsers/rabies_geo_parser.dart';

void main() {
  group('RabiesGeoParser', () {
    const parser = RabiesGeoParser();

    test('parses valid endemic mapping', () {
      const yaml = '''
countries:
  AGO:
    endemic: true
  ARG:
    endemic: false
  IND:
    endemic: true
''';

      final result = parser.parse(yaml);
      expect(result['AGO'], true);
      expect(result['ARG'], false);
      expect(result['IND'], true);
    });

    test('throws on missing "countries" key', () {
      const yaml = 'other: {}';
      expect(() => parser.parse(yaml), throwsA(isA<FormatException>()));
    });

    test('throws on missing endemic field', () {
      const yaml = '''
countries:
  BAD:
    notEndemicField: true
''';
      expect(() => parser.parse(yaml), throwsA(isA<FormatException>()));
    });

    test('requires endemic to be boolean', () {
      const yaml = '''
countries:
  TST:
    endemic: "yes"
''';
      expect(() => parser.parse(yaml), throwsA(isA<FormatException>()));
    });
  });
}
