import 'package:travelmd/data/parsers/yaml_asset_loader.dart';
import 'package:travelmd/data/parsers/sources_parser.dart';
import 'package:travelmd/data/parsers/rabies_geo_parser.dart';
import 'package:travelmd/data/parsers/rabies_cards_parser.dart';
import 'package:travelmd/domain/models/guidance_card.dart';

/// Central repository for medical content (YAML-driven).
/// 
/// Responsibilities:
/// - Load and cache YAML assets
/// - Expose high-level queries
/// - Validate cross-references (e.g., sourceRefs exist)
class ContentRepository {
  final YamlAssetLoader _assetLoader;
  final SourcesParser _sourcesParser;
  final RabiesGeoParser _geoParser;
  final RabiesCardsParser _cardsParser;

  // Caches
  Future<Map<String, dynamic>>? _sourcesCache;
  Future<Map<String, bool>>? _rabiesEndemicCache;
  Future<Map<String, bool>>? _malariaRelevantCache;
  Future<List<GuidanceCard>>? _rabiesCardsCache;
  Future<List<GuidanceCard>>? _malariaCardsCache;
  Future<List<GuidanceCard>>? _pretravelReadinessCardsCache;
  Future<List<GuidanceCard>>? _foodWaterSafetyCardsCache;
  Future<List<GuidanceCard>>? _travelInjuryPreventionCardsCache;

  ContentRepository({
    YamlAssetLoader? assetLoader,
  })  : _assetLoader = assetLoader ?? const YamlAssetLoader(),
        _sourcesParser = const SourcesParser(),
        _geoParser = const RabiesGeoParser(),
        _cardsParser = const RabiesCardsParser();

  /// Load all content at once.
  Future<void> loadAll() async {
    await Future.wait([
      _loadSources(),
      _loadRabiesEndemic(),
      _loadMalariaRelevant(),
      _loadRabiesCards(),
      _loadMalariaCards(),
      _loadPretravelReadinessCards(),
      _loadFoodWaterSafetyCards(),
      _loadTravelInjuryPreventionCards(),
    ]);
  }

  Future<Map<String, dynamic>> _loadSources() async {
    _sourcesCache ??= (() async {
      final yaml = await _assetLoader.loadAssetYaml('assets/sources/sources.yaml');
      final parsed = _sourcesParser.parse(yaml);
      return parsed.map((k, v) => MapEntry(k, {
        'title': v.title,
        'organization': v.organization,
        'url': v.url,
        'lastReviewed': v.lastReviewed,
      }));
    })();
    return await _sourcesCache!;
  }

  Future<Map<String, bool>> _loadRabiesEndemic() async {
    _rabiesEndemicCache ??= (() async {
      final yaml = await _assetLoader.loadAssetYaml('assets/geo/rabies_endemic.yaml');
      return _geoParser.parse(yaml);
    })();
    return await _rabiesEndemicCache!;
  }

  Future<List<GuidanceCard>> _loadRabiesCards() async {
    _rabiesCardsCache ??= (() async {
      final yaml = await _assetLoader.loadAssetYaml('assets/content/rabies_public.yaml');
      final cards = _cardsParser.parse(yaml);
      // Validate sourceRefs
      final sources = await _loadSources();
      for (final card in cards) {
        for (final ref in card.sourceRefs) {
          if (!sources.containsKey(ref)) {
            throw FormatException('Card "${card.id}" references unknown source "$ref"');
          }
        }
      }
      return cards;
    })();
    return await _rabiesCardsCache!;
  }

  Future<Map<String, bool>> _loadMalariaRelevant() async {
    _malariaRelevantCache ??= (() async {
      final yaml = await _assetLoader.loadAssetYaml('assets/geo/malaria_relevant.yaml');
      return _geoParser.parse(yaml);
    })();
    return await _malariaRelevantCache!;
  }

  Future<List<GuidanceCard>> _loadMalariaCards() async {
    _malariaCardsCache ??= (() async {
      final yaml = await _assetLoader.loadAssetYaml('assets/content/malaria_public.yaml');
      final cards = _cardsParser.parse(yaml);
      final sources = await _loadSources();
      for (final card in cards) {
        for (final ref in card.sourceRefs) {
          if (!sources.containsKey(ref)) {
            throw FormatException('Card "${card.id}" references unknown source "$ref"');
          }
        }
      }
      return cards;
    })();
    return await _malariaCardsCache!;
  }

  Future<List<GuidanceCard>> _loadPretravelReadinessCards() async {
    _pretravelReadinessCardsCache ??= (() async {
      final yaml = await _assetLoader.loadAssetYaml('assets/content/pretravel_readiness_public.yaml');
      final cards = _cardsParser.parse(yaml);
      final sources = await _loadSources();
      for (final card in cards) {
        for (final ref in card.sourceRefs) {
          if (!sources.containsKey(ref)) {
            throw FormatException('Card "${card.id}" references unknown source "$ref"');
          }
        }
      }
      return cards;
    })();
    return await _pretravelReadinessCardsCache!;
  }

  Future<List<GuidanceCard>> _loadFoodWaterSafetyCards() async {
    _foodWaterSafetyCardsCache ??= (() async {
      final yaml = await _assetLoader.loadAssetYaml('assets/content/food_water_safety_public.yaml');
      final cards = _cardsParser.parse(yaml);
      final sources = await _loadSources();
      for (final card in cards) {
        for (final ref in card.sourceRefs) {
          if (!sources.containsKey(ref)) {
            throw FormatException('Card "${card.id}" references unknown source "$ref"');
          }
        }
      }
      return cards;
    })();
    return await _foodWaterSafetyCardsCache!;
  }

  Future<List<GuidanceCard>> _loadTravelInjuryPreventionCards() async {
    _travelInjuryPreventionCardsCache ??= (() async {
      final yaml = await _assetLoader.loadAssetYaml('assets/content/travel_injury_prevention_public.yaml');
      final cards = _cardsParser.parse(yaml);
      final sources = await _loadSources();
      for (final card in cards) {
        for (final ref in card.sourceRefs) {
          if (!sources.containsKey(ref)) {
            throw FormatException('Card "${card.id}" references unknown source "$ref"');
          }
        }
      }
      return cards;
    })();
    return await _travelInjuryPreventionCardsCache!;
  }

  /// Get a source by ID.
  Future<Map<String, dynamic>?> getSource(String sourceId) async {
    final sources = await _loadSources();
    return sources[sourceId];
  }

  /// Check if rabies is endemic in a country (ISO3).
  Future<bool> isRabiesEndemic(String iso3) async {
    final endemic = await _loadRabiesEndemic();
    final result = endemic[iso3];
    if (result == null) {
      throw FormatException('Country ISO3 "$iso3" not found in rabies endemic mapping');
    }
    return result;
  }

  /// Get all rabies guidance cards.
  Future<List<GuidanceCard>> getRabiesCards() async {
    return await _loadRabiesCards();
  }

  /// Get rabies cards filtered by pillar.
  /// Note: In this MVP, pillar is stored in YAML but not in the GuidanceCard model.
  /// For production, extend GuidanceCard to include pillar.
  Future<List<GuidanceCard>> getRabiesCardsByPillar(String pillar) async {
    final cards = await _loadRabiesCards();
    // This is a simplification. In production, GuidanceCard would have a pillar field.
    // For now, cards are grouped in YAML in pillar order but we can't filter programmatically.
    return cards;
  }

  /// Check if malaria prevention guidance is relevant for a country (ISO3).
  Future<bool> isMalariaRelevant(String iso3) async {
    final relevantMap = await _loadMalariaRelevant();
    final result = relevantMap[iso3];
    if (result == null) {
      throw FormatException('Country ISO3 "$iso3" not found in malaria relevance mapping');
    }
    return result;
  }

  /// Get all malaria guidance cards.
  Future<List<GuidanceCard>> getMalariaCards() async {
    return await _loadMalariaCards();
  }

  Future<List<GuidanceCard>> getPretravelReadinessCards() async {
    return await _loadPretravelReadinessCards();
  }

  Future<List<GuidanceCard>> getFoodWaterSafetyCards() async {
    return await _loadFoodWaterSafetyCards();
  }

  Future<List<GuidanceCard>> getTravelInjuryPreventionCards() async {
    return await _loadTravelInjuryPreventionCards();
  }
}
