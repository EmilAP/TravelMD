import 'package:flutter/services.dart';

/// Loads YAML content from assets.
class YamlAssetLoader {
  const YamlAssetLoader();

  /// Load a YAML file from assets as a string.
  Future<String> loadAssetYaml(String assetPath) async {
    try {
      return await rootBundle.loadString(assetPath);
    } catch (e) {
      throw Exception('Failed to load asset: $assetPath. Error: $e');
    }
  }
}
