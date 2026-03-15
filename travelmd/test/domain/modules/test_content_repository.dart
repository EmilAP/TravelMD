import 'package:travelmd/data/parsers/rabies_cards_parser.dart';
import 'package:travelmd/data/parsers/rabies_geo_parser.dart';
import 'package:travelmd/data/parsers/sources_parser.dart';
import 'package:travelmd/data/parsers/yaml_asset_loader.dart';
import 'package:travelmd/data/repositories/content_repository.dart';
import 'package:travelmd/domain/models/guidance_card.dart';

ContentRepository createTestContentRepository() {
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
  who_malaria:
    title: "WHO Malaria"
    organization: "WHO"
    url: "https://who.int/malaria"
    lastReviewed: "2026-03-15"
  cdc_malaria:
    title: "CDC Malaria"
    organization: "CDC"
    url: "https://cdc.gov/malaria"
    lastReviewed: "2026-03-15"
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

  const malariaGeoYaml = '''
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

  const malariaCardsYaml = '''
cards:
  - id: "malaria_prevent_general_mosquito_avoidance"
    title: "Avoid mosquito bites"
    pillar: "prevention"
    urgency: "routine"
    summary: "Use bite prevention in all destinations."
    whyThisMatters: "Mosquitoes can spread infections."
    whenToDoIt: "duringTravel"
    steps:
      - label: "Reduce bite exposure throughout your trip."
    sourceRefs: ["who_malaria"]
    lastReviewed: "2026-03-15"
  - id: "malaria_prevent_use_repellent"
    title: "Use repellent"
    pillar: "prevention"
    urgency: "important"
    summary: "Apply and reapply repellent as directed."
    whyThisMatters: "Repellent lowers bite risk."
    whenToDoIt: "duringTravel"
    steps:
      - label: "Follow product label instructions."
    sourceRefs: ["cdc_malaria"]
    lastReviewed: "2026-03-15"
  - id: "malaria_prevent_bed_nets_room_protection"
    title: "Protect sleeping space"
    pillar: "prevention"
    urgency: "important"
    summary: "Use bed nets and room barriers."
    whyThisMatters: "Nighttime bites can transmit malaria."
    whenToDoIt: "duringTravel"
    steps:
      - label: "Use bed nets where needed."
    sourceRefs: ["who_malaria"]
    lastReviewed: "2026-03-15"
  - id: "malaria_prevent_cover_skin"
    title: "Cover skin"
    pillar: "prevention"
    urgency: "routine"
    summary: "Wear longer clothing when possible."
    whyThisMatters: "Less exposed skin can reduce bites."
    whenToDoIt: "duringTravel"
    steps:
      - label: "Wear long sleeves and pants when practical."
    sourceRefs: ["who_malaria"]
    lastReviewed: "2026-03-15"
  - id: "malaria_prevent_discuss_medication"
    title: "Discuss preventive medication"
    pillar: "prevention"
    urgency: "important"
    summary: "Talk with a travel health professional before departure."
    whyThisMatters: "Medication planning is destination-specific."
    whenToDoIt: "beforeTravel"
    steps:
      - label: "Review itinerary and health history before travel."
    sourceRefs: ["cdc_malaria"]
    lastReviewed: "2026-03-15"
  - id: "malaria_prevent_plan_early_care"
    title: "Plan where to seek care"
    pillar: "prevention"
    urgency: "important"
    summary: "Know where to seek urgent care for fever."
    whyThisMatters: "Prompt evaluation matters in risk areas."
    whenToDoIt: "beforeTravel"
    steps:
      - label: "Save local clinic and hospital contacts."
    sourceRefs: ["cdc_malaria"]
    lastReviewed: "2026-03-15"
''';

  final sources = const SourcesParser().parse(sourcesYaml);
  final endemic = const RabiesGeoParser().parse(geoYaml);
  final cards = const RabiesCardsParser().parse(cardsYaml);
  final malariaRelevant = const RabiesGeoParser().parse(malariaGeoYaml);
  final malariaCards = const RabiesCardsParser().parse(malariaCardsYaml);

  return TestContentRepository(
    sources,
    endemic,
    cards,
    malariaRelevant,
    malariaCards,
  );
}

class TestContentRepository extends ContentRepository {
  final Map<String, dynamic> _sources;
  final Map<String, bool> _rabiesEndemic;
  final List<GuidanceCard> _rabiesCards;
  final Map<String, bool> _malariaRelevant;
  final List<GuidanceCard> _malariaCards;

  TestContentRepository(
    this._sources,
    this._rabiesEndemic,
    this._rabiesCards,
    this._malariaRelevant,
    this._malariaCards,
  )
      : super(assetLoader: const YamlAssetLoader());

  @override
  Future<void> loadAll() async {}

  @override
  Future<Map<String, dynamic>?> getSource(String sourceId) async {
    return _sources[sourceId];
  }

  @override
  Future<bool> isRabiesEndemic(String iso3) async {
    final result = _rabiesEndemic[iso3];
    if (result == null) {
      throw FormatException('Unknown ISO3: $iso3');
    }
    return result;
  }

  @override
  Future<List<GuidanceCard>> getRabiesCards() async {
    return _rabiesCards;
  }

  @override
  Future<List<GuidanceCard>> getRabiesCardsByPillar(String pillar) async {
    return _rabiesCards;
  }

  @override
  Future<bool> isMalariaRelevant(String iso3) async {
    final result = _malariaRelevant[iso3];
    if (result == null) {
      throw FormatException('Unknown ISO3: $iso3');
    }
    return result;
  }

  @override
  Future<List<GuidanceCard>> getMalariaCards() async {
    return _malariaCards;
  }
}
