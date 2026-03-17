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
  cdc_travel_health_general:
    title: "Travelers' Health"
    organization: "CDC"
    url: "https://wwwnc.cdc.gov/travel"
    lastReviewed: "2026-03-17"
  who_food_safety:
    title: "Food safety"
    organization: "WHO"
    url: "https://www.who.int/health-topics/food-safety"
    lastReviewed: "2026-03-17"
  who_drinking_water:
    title: "Drinking-water"
    organization: "WHO"
    url: "https://www.who.int/news-room/fact-sheets/detail/drinking-water"
    lastReviewed: "2026-03-17"
  who_injury_prevention:
    title: "Injuries and violence"
    organization: "WHO"
    url: "https://www.who.int/teams/social-determinants-of-health/safety-and-mobility"
    lastReviewed: "2026-03-17"
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

  const pretravelCardsYaml = '''
cards:
  - id: "pretravel_visit_early"
    title: "Book a pre-travel health visit early"
    pillar: "preparedness"
    urgency: "important"
    summary: "Schedule pre-travel planning early."
    whyThisMatters: "Early planning improves readiness."
    whenToDoIt: "beforeTravel"
    tags: ["pretravel"]
    priority: "high"
    timing: "before_travel"
    relatedModules: ["rabies", "malaria"]
    steps:
      - label: "Book a visit before departure."
    sourceRefs: ["cdc_travel_health_general"]
    lastReviewed: "2026-03-17"
  - id: "pretravel_review_vaccines"
    title: "Review vaccines"
    pillar: "preparedness"
    urgency: "important"
    summary: "Check destination vaccine guidance."
    whyThisMatters: "Vaccine needs vary by trip."
    whenToDoIt: "beforeTravel"
    steps:
      - label: "Review recommendations with a clinician."
    sourceRefs: ["cdc_travel_health_general"]
    lastReviewed: "2026-03-17"
  - id: "pretravel_pack_medicines"
    title: "Pack medicines"
    pillar: "preparedness"
    urgency: "important"
    summary: "Bring routine meds and copies."
    whyThisMatters: "Refills can be difficult abroad."
    whenToDoIt: "beforeTravel"
    steps:
      - label: "Bring enough routine medicines."
    sourceRefs: ["cdc_travel_health_general"]
    lastReviewed: "2026-03-17"
  - id: "pretravel_check_insurance"
    title: "Check insurance"
    pillar: "preparedness"
    urgency: "important"
    summary: "Confirm emergency coverage details."
    whyThisMatters: "Coverage affects care access."
    whenToDoIt: "beforeTravel"
    steps:
      - label: "Save policy numbers and support contacts."
    sourceRefs: ["cdc_travel_health_general"]
    lastReviewed: "2026-03-17"
  - id: "pretravel_plan_care_access"
    title: "Plan care access"
    pillar: "preparedness"
    urgency: "important"
    summary: "Identify one clinic and one hospital."
    whyThisMatters: "Faster action helps in urgent moments."
    whenToDoIt: "beforeTravel"
    steps:
      - label: "Save local care locations."
    sourceRefs: ["cdc_travel_health_general"]
    lastReviewed: "2026-03-17"
  - id: "pretravel_build_health_kit"
    title: "Build a health kit"
    pillar: "preparedness"
    urgency: "routine"
    summary: "Pack practical health supplies."
    whyThisMatters: "Small issues are easier to manage prepared."
    whenToDoIt: "beforeTravel"
    steps:
      - label: "Include first aid and hydration supplies."
    sourceRefs: ["cdc_travel_health_general"]
    lastReviewed: "2026-03-17"
  - id: "pretravel_save_emergency_contacts"
    title: "Save emergency contacts"
    pillar: "preparedness"
    urgency: "important"
    summary: "Store emergency numbers and key records."
    whyThisMatters: "Quick access supports faster response."
    whenToDoIt: "beforeTravel"
    steps:
      - label: "Save local emergency numbers."
    sourceRefs: ["cdc_travel_health_general"]
    lastReviewed: "2026-03-17"
''';

  const foodWaterCardsYaml = '''
cards:
  - id: "foodwater_choose_hot_food"
    title: "Choose hot food"
    pillar: "prevention"
    urgency: "important"
    summary: "Prefer food cooked and served hot."
    whyThisMatters: "Helps lower foodborne risk."
    whenToDoIt: "duringTravel"
    steps:
      - label: "Prefer freshly cooked meals."
    sourceRefs: ["who_food_safety"]
    lastReviewed: "2026-03-17"
  - id: "foodwater_select_safer_water"
    title: "Use safer water"
    pillar: "prevention"
    urgency: "important"
    summary: "Plan safer water options."
    whyThisMatters: "Water quality varies by destination."
    whenToDoIt: "duringTravel"
    steps:
      - label: "Use treated or trusted water sources."
    sourceRefs: ["who_drinking_water"]
    lastReviewed: "2026-03-17"
  - id: "foodwater_hand_hygiene"
    title: "Use hand hygiene"
    pillar: "prevention"
    urgency: "routine"
    summary: "Wash or sanitize before meals."
    whyThisMatters: "Reduces contamination pathways."
    whenToDoIt: "duringTravel"
    steps:
      - label: "Wash hands or use sanitizer."
    sourceRefs: ["who_food_safety"]
    lastReviewed: "2026-03-17"
  - id: "foodwater_hydrate_safely"
    title: "Hydrate safely"
    pillar: "prevention"
    urgency: "important"
    summary: "Drink enough safe fluids."
    whyThisMatters: "Hydration supports safer travel in heat."
    whenToDoIt: "duringTravel"
    steps:
      - label: "Carry fluids and drink regularly."
    sourceRefs: ["cdc_travel_health_general"]
    lastReviewed: "2026-03-17"
  - id: "foodwater_pack_ors"
    title: "Pack oral rehydration"
    pillar: "preparedness"
    urgency: "routine"
    summary: "Pack oral rehydration packets."
    whyThisMatters: "Useful if stomach symptoms occur."
    whenToDoIt: "beforeTravel"
    steps:
      - label: "Pack oral rehydration packets."
    sourceRefs: ["who_drinking_water"]
    lastReviewed: "2026-03-17"
  - id: "foodwater_know_when_to_seek_care"
    title: "Know when to seek care"
    pillar: "preparedness"
    urgency: "important"
    summary: "Review severe symptom warning signs."
    whyThisMatters: "Prompt care can reduce complications."
    whenToDoIt: "duringTravel"
    steps:
      - label: "Seek care for worsening or severe symptoms."
    sourceRefs: ["cdc_travel_health_general"]
    lastReviewed: "2026-03-17"
''';

  const injuryCardsYaml = '''
cards:
  - id: "injury_safer_transport_choices"
    title: "Choose safer transport"
    pillar: "prevention"
    urgency: "important"
    summary: "Favor safer transport options."
    whyThisMatters: "Road injuries are a common travel risk."
    whenToDoIt: "duringTravel"
    steps:
      - label: "Use trusted transport options."
    sourceRefs: ["who_injury_prevention"]
    lastReviewed: "2026-03-17"
  - id: "injury_helmets_and_seatbelts"
    title: "Use helmets and seatbelts"
    pillar: "prevention"
    urgency: "important"
    summary: "Use protection every time."
    whyThisMatters: "Lowers severe injury risk."
    whenToDoIt: "duringTravel"
    steps:
      - label: "Do not ride without proper protection."
    sourceRefs: ["who_injury_prevention"]
    lastReviewed: "2026-03-17"
  - id: "injury_heat_and_sun_protection"
    title: "Prevent heat and sun injury"
    pillar: "prevention"
    urgency: "important"
    summary: "Hydrate and reduce heat exposure."
    whyThisMatters: "Heat illness can progress quickly."
    whenToDoIt: "duringTravel"
    steps:
      - label: "Plan around peak heat and use sun protection."
    sourceRefs: ["cdc_travel_health_general"]
    lastReviewed: "2026-03-17"
  - id: "injury_alcohol_risk_awareness"
    title: "Use caution with alcohol"
    pillar: "prevention"
    urgency: "routine"
    summary: "Avoid high-risk activities after drinking."
    whyThisMatters: "Impaired judgment raises injury risk."
    whenToDoIt: "duringTravel"
    steps:
      - label: "Set a safer transportation plan before events."
    sourceRefs: ["who_injury_prevention"]
    lastReviewed: "2026-03-17"
  - id: "injury_activity_fit_and_gear"
    title: "Match activities to your readiness"
    pillar: "prevention"
    urgency: "routine"
    summary: "Choose activities that match your skills and gear."
    whyThisMatters: "Preparation helps reduce preventable injuries."
    whenToDoIt: "duringTravel"
    steps:
      - label: "Check conditions and equipment before activities."
    sourceRefs: ["cdc_travel_health_general"]
    lastReviewed: "2026-03-17"
  - id: "injury_walking_and_night_movement"
    title: "Move more safely at night"
    pillar: "prevention"
    urgency: "routine"
    summary: "Use better lighting and awareness practices."
    whyThisMatters: "Injury and safety risks can increase after dark."
    whenToDoIt: "duringTravel"
    steps:
      - label: "Use well-lit routes and avoid isolated shortcuts."
    sourceRefs: ["who_injury_prevention"]
    lastReviewed: "2026-03-17"
  - id: "injury_plan_help_access"
    title: "Plan urgent help access"
    pillar: "preparedness"
    urgency: "important"
    summary: "Know where to get urgent care quickly."
    whyThisMatters: "Care delays can worsen outcomes."
    whenToDoIt: "beforeTravel"
    steps:
      - label: "Save local urgent care options."
    sourceRefs: ["cdc_travel_health_general"]
    lastReviewed: "2026-03-17"
''';

  final sources = const SourcesParser().parse(sourcesYaml);
  final endemic = const RabiesGeoParser().parse(geoYaml);
  final cards = const RabiesCardsParser().parse(cardsYaml);
  final malariaRelevant = const RabiesGeoParser().parse(malariaGeoYaml);
  final malariaCards = const RabiesCardsParser().parse(malariaCardsYaml);
  final pretravelCards = const RabiesCardsParser().parse(pretravelCardsYaml);
  final foodWaterCards = const RabiesCardsParser().parse(foodWaterCardsYaml);
  final injuryCards = const RabiesCardsParser().parse(injuryCardsYaml);

  return TestContentRepository(
    sources,
    endemic,
    cards,
    malariaRelevant,
    malariaCards,
    pretravelCards,
    foodWaterCards,
    injuryCards,
  );
}

class TestContentRepository extends ContentRepository {
  final Map<String, dynamic> _sources;
  final Map<String, bool> _rabiesEndemic;
  final List<GuidanceCard> _rabiesCards;
  final Map<String, bool> _malariaRelevant;
  final List<GuidanceCard> _malariaCards;
  final List<GuidanceCard> _pretravelCards;
  final List<GuidanceCard> _foodWaterCards;
  final List<GuidanceCard> _injuryCards;

  TestContentRepository(
    this._sources,
    this._rabiesEndemic,
    this._rabiesCards,
    this._malariaRelevant,
    this._malariaCards,
    this._pretravelCards,
    this._foodWaterCards,
    this._injuryCards,
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

  @override
  Future<List<GuidanceCard>> getPretravelReadinessCards() async {
    return _pretravelCards;
  }

  @override
  Future<List<GuidanceCard>> getFoodWaterSafetyCards() async {
    return _foodWaterCards;
  }

  @override
  Future<List<GuidanceCard>> getTravelInjuryPreventionCards() async {
    return _injuryCards;
  }
}
