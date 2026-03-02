import 'package:yaml/yaml.dart';

/// Parsed source reference with metadata.
class SourceRef {
  final String id;
  final String title;
  final String organization;
  final String url;
  final String lastReviewed; // YYYY-MM-DD

  SourceRef({
    required this.id,
    required this.title,
    required this.organization,
    required this.url,
    required this.lastReviewed,
  });
}

/// Parses sources.yaml into SourceRef objects.
class SourcesParser {
  const SourcesParser();

  /// Parse YAML string into a map of source ID -> SourceRef.
  Map<String, SourceRef> parse(String yamlContent) {
    final doc = loadYaml(yamlContent) as YamlMap;
    final sourcesNode = doc['sources'] as YamlMap?;

    if (sourcesNode == null) {
      throw FormatException('Missing "sources" key in sources.yaml');
    }

    final result = <String, SourceRef>{};

    sourcesNode.forEach((sourceId, sourceData) {
      if (sourceData is! YamlMap) {
        throw FormatException('Source "$sourceId" must be a map, got ${sourceData.runtimeType}');
      }

      final title = sourceData['title'] as String?;
      final organization = sourceData['organization'] as String?;
      final url = sourceData['url'] as String?;
      final lastReviewed = sourceData['lastReviewed'] as String?;

      if (title == null || organization == null || url == null || lastReviewed == null) {
        throw FormatException(
          'Source "$sourceId" missing required fields: title, organization, url, lastReviewed',
        );
      }

      // Validate lastReviewed format YYYY-MM-DD
      if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(lastReviewed)) {
        throw FormatException(
          'Source "$sourceId" lastReviewed must be YYYY-MM-DD format, got "$lastReviewed"',
        );
      }

      result[sourceId] = SourceRef(
        id: sourceId,
        title: title,
        organization: organization,
        url: url,
        lastReviewed: lastReviewed,
      );
    });

    return result;
  }
}
