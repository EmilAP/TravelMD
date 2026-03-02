import 'package:flutter_test/flutter_test.dart';
import 'package:travelmd/domain/models/trip.dart';
import 'package:travelmd/domain/models/traveler_profile.dart';
import 'package:travelmd/domain/models/exposure_intake.dart';
import 'package:travelmd/domain/models/guidance_card.dart';
import 'package:travelmd/domain/enums/animal_type.dart';
import 'package:travelmd/domain/enums/exposure_contact_type.dart';
import 'package:travelmd/domain/enums/checklist_category.dart';
import 'package:travelmd/domain/rules/rabies_plan_builder.dart';
import 'package:travelmd/data/parsers/yaml_asset_loader.dart';
import 'package:travelmd/data/parsers/sources_parser.dart';
import 'package:travelmd/data/parsers/rabies_geo_parser.dart';
import 'package:travelmd/data/parsers/rabies_cards_parser.dart';
import 'package:travelmd/data/repositories/content_repository.dart';

void main() {
  group('RabiesPlanBuilder', () {
    const builder = RabiesPlanBuilder();
    late ContentRepository contentRepo;

    // Helper to create a mock ContentRepository with test YAML
    ContentRepository _createMockRepo() {
      // Inline YAML for testing
      const sourcesYaml = '''
sources:
  who_rabies:
    title: "WHO Rabies"
    organization: "WHO"
    url: "https://who.int"
    lastReviewed: "2025-12-01"
  cdc_rabies:
    title: "CDC Rabies"
    organization: "CDC"
    url: "https://cdc.gov"
    lastReviewed: "2025-10-01"
''';

      const geoYaml = '''
countries:
  IND:
    endemic: true
  ZAF:
    endemic: true
  USA:
    endemic: false
  AUS:
    endemic: false
''';

      const cardsYaml = '''
cards:
  - id: "rabies_prevent_avoid_animals"
    title: "Avoid contact with animals"
    pillar: "prevention"
    urgency: "routine"
    summary: "Keep distance from stray animals"
    whyThisMatters: "Prevention is key"
    whenToDoIt: "duringTravel"
    steps:
      - label: "Do not pet stray dogs"
    sourceRefs: ["cdc_rabies"]
    lastReviewed: "2026-03-01"
  - id: "rabies_prevent_kids_supervision"
    title: "Supervise children closely"
    pillar: "prevention"
    urgency: "routine"
    summary: "Watch children around animals"
    whyThisMatters: "Children are at risk"
    whenToDoIt: "duringTravel"
    steps:
      - label: "Keep children indoors at dusk"
    sourceRefs: ["cdc_rabies"]
    lastReviewed: "2026-03-01"
  - id: "rabies_prevent_no_feed_touch"
    title: "Never feed or touch street animals"
    pillar: "prevention"
    urgency: "routine"
    summary: "Feeding increases bite risk"
    whyThisMatters: "Animals become aggressive"
    whenToDoIt: "duringTravel"
    steps:
      - label: "Do not offer food"
    sourceRefs: ["cdc_rabies"]
    lastReviewed: "2026-03-01"
  - id: "rabies_prevent_bats_in_room"
    title: "Keep bats out of sleeping areas"
    pillar: "prevention"
    urgency: "important"
    summary: "Seal gaps and use nets"
    whyThisMatters: "Bat bites are silent"
    whenToDoIt: "duringTravel"
    steps:
      - label: "Sleep under a net"
    sourceRefs: ["who_rabies"]
    lastReviewed: "2026-03-01"
  - id: "rabies_prepare_know_where_to_go"
    title: "Know where to find care"
    pillar: "preparedness"
    urgency: "important"
    summary: "Research local hospitals"
    whyThisMatters: "Time is critical"
    whenToDoIt: "beforeTravel"
    steps:
      - label: "Find local clinic address"
    sourceRefs: ["cdc_rabies"]
    lastReviewed: "2026-03-01"
  - id: "rabies_prepare_consider_preexposure_vaccine"
    title: "Modern vaccines are safe"
    pillar: "preparedness"
    urgency: "important"
    summary: "Consider pre-exposure vaccination"
    whyThisMatters: "Simplifies post-exposure care"
    whenToDoIt: "beforeTravel"
    steps:
      - label: "Ask your doctor"
    sourceRefs: ["cdc_rabies"]
    lastReviewed: "2026-03-01"
  - id: "rabies_exposure_wound_wash_now"
    title: "Wash the wound immediately"
    pillar: "exposure_response"
    urgency: "urgent"
    summary: "Use soap and water for 15 minutes"
    whyThisMatters: "Reduces virus load"
    whenToDoIt: "now"
    steps:
      - label: "Wash wound with soap and water"
      - label: "Apply iodine or alcohol"
    sourceRefs: ["cdc_rabies", "who_rabies"]
    lastReviewed: "2026-03-01"
  - id: "rabies_exposure_seek_care_now"
    title: "Seek medical care immediately"
    pillar: "exposure_response"
    urgency: "urgent"
    summary: "Go to a clinic now"
    whyThisMatters: "Time is critical"
    whenToDoIt: "now"
    steps:
      - label: "Go to hospital"
    sourceRefs: ["cdc_rabies"]
    lastReviewed: "2026-03-01"
  - id: "rabies_exposure_reassure_no_risk"
    title: "This exposure carries very low risk"
    pillar: "exposure_response"
    urgency: "routine"
    summary: "Lick on intact skin is safe"
    whyThisMatters: "Skin is a barrier"
    whenToDoIt: "now"
    steps:
      - label: "Wash and observe"
    sourceRefs: ["cdc_rabies"]
    lastReviewed: "2026-03-01"
''';

      final sourcesParser = SourcesParser();
      final geoParser = RabiesGeoParser();
      final cardsParser = RabiesCardsParser();

      // Pre-parse to avoid async issues in setup
      final _sources = sourcesParser.parse(sourcesYaml);
      final _endemic = geoParser.parse(geoYaml);
      final _cards = cardsParser.parse(cardsYaml);

      // Return a mock repository
      return _MockContentRepository(_sources, _endemic, _cards);
    }

    setUp(() {
      contentRepo = _createMockRepo();
    });

    test('endemic destination + adult => prevention + preparedness cards (no kids)', () async {
      final trip = Trip(
        originCountry: 'USA',
        destinationCountry: 'IND',
        departDate: DateTime(2026, 3, 10),
        returnDate: DateTime(2026, 3, 20),
      );
      final traveler = TravelerProfile(ageYears: 35);

      final patch = await builder.build(
        trip: trip,
        traveler: traveler,
        contentRepo: contentRepo,
      );

      // Should include prevention and preparedness
      final cardIds = patch.cardsToAdd.map((c) => c.id).toList();
      expect(cardIds, containsAll([
        'rabies_prevent_avoid_animals',
        'rabies_prevent_no_feed_touch',
        'rabies_prevent_bats_in_room',
        'rabies_prepare_know_where_to_go',
        'rabies_prepare_consider_preexposure_vaccine',
      ]));
      // Should NOT include kids supervision
      expect(cardIds, isNot(contains('rabies_prevent_kids_supervision')));
      // Should have checklist items
      expect(patch.checklistToAdd.length, greaterThan(0));
    });

    test('endemic destination + child <16 => includes kids supervision', () async {
      final trip = Trip(
        originCountry: 'USA',
        destinationCountry: 'ZAF',
        departDate: DateTime(2026, 3, 10),
        returnDate: DateTime(2026, 3, 20),
      );
      final traveler = TravelerProfile(ageYears: 12);

      final patch = await builder.build(
        trip: trip,
        traveler: traveler,
        contentRepo: contentRepo,
      );

      final cardIds = patch.cardsToAdd.map((c) => c.id).toList();
      expect(cardIds, contains('rabies_prevent_kids_supervision'));
    });

    test('non-endemic destination => only avoid_animals card', () async {
      final trip = Trip(
        originCountry: 'USA',
        destinationCountry: 'AUS',
        departDate: DateTime(2026, 3, 10),
        returnDate: DateTime(2026, 3, 20),
      );
      final traveler = TravelerProfile(ageYears: 40);

      final patch = await builder.build(
        trip: trip,
        traveler: traveler,
        contentRepo: contentRepo,
      );

      final cardIds = patch.cardsToAdd.map((c) => c.id).toList();
      expect(cardIds, equals(['rabies_prevent_avoid_animals']));
    });

    test('bat exposure => wound_wash_now + seek_care_now', () async {
      final trip = Trip(
        originCountry: 'USA',
        destinationCountry: 'IND',
        departDate: DateTime(2026, 3, 10),
        returnDate: DateTime(2026, 3, 20),
      );
      final traveler = TravelerProfile(ageYears: 30);
      final exposure = ExposureIntake(
        animalType: AnimalType.bat,
        contactType: ExposureContactType.lickOnIntactSkin, // Even lick from bat
        countryIso3: 'IND',
      );

      final patch = await builder.build(
        trip: trip,
        traveler: traveler,
        exposure: exposure,
        contentRepo: contentRepo,
      );

      final cardIds = patch.cardsToAdd.map((c) => c.id).toList();
      expect(cardIds, containsAll([
        'rabies_exposure_wound_wash_now',
        'rabies_exposure_seek_care_now',
      ]));
    });

    test('dog bite with skin break in endemic => wound_wash_now + seek_care_now', () async {
      final trip = Trip(
        originCountry: 'USA',
        destinationCountry: 'ZAF',
        departDate: DateTime(2026, 3, 10),
        returnDate: DateTime(2026, 3, 20),
      );
      final traveler = TravelerProfile(ageYears: 25);
      final exposure = ExposureIntake(
        animalType: AnimalType.dog,
        contactType: ExposureContactType.bite,
        countryIso3: 'ZAF',
        skinBroken: true,
      );

      final patch = await builder.build(
        trip: trip,
        traveler: traveler,
        exposure: exposure,
        contentRepo: contentRepo,
      );

      final cardIds = patch.cardsToAdd.map((c) => c.id).toList();
      expect(cardIds, containsAll([
        'rabies_exposure_wound_wash_now',
        'rabies_exposure_seek_care_now',
      ]));
    });

    test('lick intact skin no mucosa => wound_wash_now + reassure_no_risk', () async {
      final trip = Trip(
        originCountry: 'USA',
        destinationCountry: 'IND',
        departDate: DateTime(2026, 3, 10),
        returnDate: DateTime(2026, 3, 20),
      );
      final traveler = TravelerProfile(ageYears: 28);
      final exposure = ExposureIntake(
        animalType: AnimalType.dog,
        contactType: ExposureContactType.lickOnIntactSkin,
        countryIso3: 'IND',
        skinBroken: false,
        mucousMembrane: false,
      );

      final patch = await builder.build(
        trip: trip,
        traveler: traveler,
        exposure: exposure,
        contentRepo: contentRepo,
      );

      final cardIds = patch.cardsToAdd.map((c) => c.id).toList();
      expect(cardIds, containsAll([
        'rabies_exposure_wound_wash_now',
        'rabies_exposure_reassure_no_risk',
      ]));
      expect(cardIds, isNot(contains('rabies_exposure_seek_care_now')));
    });

    test('unknown ISO3 => fallback to non-endemic + uncertain warning checklist', () async {
      final trip = Trip(
        originCountry: 'USA',
        destinationCountry: 'XXX', // Unknown
        departDate: DateTime(2026, 3, 10),
        returnDate: DateTime(2026, 3, 20),
      );
      final traveler = TravelerProfile(ageYears: 40);

      final patch = await builder.build(
        trip: trip,
        traveler: traveler,
        contentRepo: contentRepo,
      );

      // Should add uncertain destination checklist
      final checklistIds = patch.checklistToAdd.map((c) => c.id).toList();
      expect(checklistIds, contains('uncertain_destination_rabies'));

      // Should add only avoid_animals (treat as non-endemic fallback)
      final cardIds = patch.cardsToAdd.map((c) => c.id).toList();
      expect(cardIds, equals(['rabies_prevent_avoid_animals']));
    });

    test('multi-destination trip => uses Trip.destinationCountry', () async {
      final trip = Trip(
        originCountry: 'USA',
        destinationCountry: 'ZAF', // Final destination (endemic)
        transitCountries: ['IND'], // Transit is not used for endemicity
        departDate: DateTime(2026, 3, 10),
        returnDate: DateTime(2026, 3, 20),
      );
      final traveler = TravelerProfile(ageYears: 35);

      final patch = await builder.build(
        trip: trip,
        traveler: traveler,
        contentRepo: contentRepo,
      );

      // Should use ZAF (destinationCountry), which is endemic
      final cardIds = patch.cardsToAdd.map((c) => c.id).toList();
      expect(cardIds, containsAll([
        'rabies_prevent_avoid_animals',
        'rabies_prevent_no_feed_touch',
        'rabies_prevent_bats_in_room',
      ]));
    });

    test('checklist items have stable deterministic IDs', () async {
      final trip = Trip(
        originCountry: 'USA',
        destinationCountry: 'IND',
        departDate: DateTime(2026, 3, 10),
        returnDate: DateTime(2026, 3, 20),
      );
      final traveler = TravelerProfile(ageYears: 30);

      final patch1 = await builder.build(
        trip: trip,
        traveler: traveler,
        contentRepo: contentRepo,
      );

      final patch2 = await builder.build(
        trip: trip,
        traveler: traveler,
        contentRepo: contentRepo,
      );

      expect(
        patch1.checklistToAdd.map((c) => c.id),
        equals(patch2.checklistToAdd.map((c) => c.id)),
      );
    });
  });
}

/// Mock ContentRepository for testing with inline YAML.
class _MockContentRepository extends ContentRepository {
  final Map<String, dynamic> _sources;
  final Map<String, bool> _endemic;
  final List<GuidanceCard> _cards;

  _MockContentRepository(this._sources, this._endemic, this._cards)
      : super(assetLoader: const YamlAssetLoader());

  @override
  Future<void> loadAll() async {
    // Already loaded
  }

  @override
  Future<Map<String, dynamic>?> getSource(String sourceId) async {
    return _sources[sourceId];
  }

  @override
  Future<bool> isRabiesEndemic(String iso3) async {
    final result = _endemic[iso3];
    if (result == null) {
      throw FormatException('Unknown ISO3: $iso3');
    }
    return result;
  }

  @override
  Future<List<GuidanceCard>> getRabiesCards() async {
    return _cards;
  }

  @override
  Future<List<GuidanceCard>> getRabiesCardsByPillar(String pillar) async {
    return _cards; // Not filtered in this version
  }
}
