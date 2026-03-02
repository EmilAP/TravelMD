import 'package:yaml/yaml.dart';

/// Parsed country rabies endemicity.
class CountryRabiesInfo {
  final String iso3;
  final bool endemic;

  CountryRabiesInfo({
    required this.iso3,
    required this.endemic,
  });
}

/// Parses rabies_endemic.yaml to determine rabies endemicity by ISO3 country code.
class RabiesGeoParser {
  const RabiesGeoParser();

  /// Parse YAML string into a map of ISO3 -> endemic (bool).
  Map<String, bool> parse(String yamlContent) {
    final doc = loadYaml(yamlContent) as YamlMap;
    final countriesNode = doc['countries'] as YamlMap?;

    if (countriesNode == null) {
      throw FormatException('Missing "countries" key in rabies_endemic.yaml');
    }

    final result = <String, bool>{};

    countriesNode.forEach((iso3, countryData) {
      if (countryData is! YamlMap) {
        throw FormatException('Country "$iso3" must be a map, got ${countryData.runtimeType}');
      }

      final endemicData = countryData['endemic'];
      if (endemicData is! bool) {
        throw FormatException('Country "$iso3" endemic field must be boolean, got ${endemicData.runtimeType}');
      }

      result[iso3] = endemicData;
    });

    return result;
  }
}
