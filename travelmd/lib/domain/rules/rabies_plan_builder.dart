import 'package:travelmd/domain/models/trip.dart';
import 'package:travelmd/domain/models/traveler_profile.dart';
import 'package:travelmd/domain/models/exposure_intake.dart';
import 'package:travelmd/domain/models/public_plan_patch.dart';
import 'package:travelmd/domain/models/guidance_card.dart';
import 'package:travelmd/domain/models/checklist_item.dart';
import 'package:travelmd/domain/enums/checklist_category.dart';
import 'package:travelmd/domain/enums/animal_type.dart';
import 'package:travelmd/domain/enums/exposure_contact_type.dart';
import 'package:travelmd/data/repositories/content_repository.dart';

/// Deterministic, public-facing Rabies plan builder.
/// 
/// Generates a PublicPlanPatch by combining Trip, TravelerProfile, and optional ExposureIntake
/// with YAML-driven GuidanceCards. Emphasizes prevention/preparedness by default.
class RabiesPlanBuilder {
  const RabiesPlanBuilder();

  /// Build a rabies prevention/response plan patch.
  /// 
  /// If [exposure] is null, generates prevention+preparedness cards.
  /// If [exposure] is provided, adds exposure_response cards.
  Future<PublicPlanPatch> build({
    required Trip trip,
    required TravelerProfile traveler,
    ExposureIntake? exposure,
    required ContentRepository contentRepo,
  }) async {
    final cardsToAdd = <GuidanceCard>[];
    final checklistToAdd = <ChecklistItem>[];

    if (exposure == null) {
      // Prevention-first mode: no exposure reported
      await _addPreventionAndPreparednessCards(
        trip: trip,
        traveler: traveler,
        contentRepo: contentRepo,
        cardsToAdd: cardsToAdd,
        checklistToAdd: checklistToAdd,
      );
    } else {
      // Exposure response mode
      await _addExposureResponseCards(
        trip: trip,
        exposure: exposure,
        contentRepo: contentRepo,
        cardsToAdd: cardsToAdd,
      );
    }

    return PublicPlanPatch(
      cardsToAdd: cardsToAdd,
      checklistToAdd: checklistToAdd,
      timelineToAdd: const [],
    );
  }

  /// Determine the destination ISO3 from the trip.
  /// Strategy: Use Trip.destinationCountry as the primary destination.
  /// Transit countries represent intermediate stops but are not the final destination.
  /// This ensures medical preparation is aligned with the main destination.
  String _getDestinationIso3(Trip trip) {
    return trip.destinationCountry;
  }

  /// Privacy-first prevention and preparedness cards for a safe trip.
  Future<void> _addPreventionAndPreparednessCards({
    required Trip trip,
    required TravelerProfile traveler,
    required ContentRepository contentRepo,
    required List<GuidanceCard> cardsToAdd,
    required List<ChecklistItem> checklistToAdd,
  }) async {
    final destIso3 = _getDestinationIso3(trip);
    bool isEndemic = false;
    try {
      isEndemic = await contentRepo.isRabiesEndemic(destIso3);
    } catch (e) {
      // Unknown country: treat as non-endemic, add warning checklist item
      checklistToAdd.add(
        ChecklistItem(
          id: 'uncertain_destination_rabies',
          label: 'Destination not in our database—ask your doctor about rabies risk',
          category: ChecklistCategory.emergency,
        ),
      );
      isEndemic = false;
    }

    final allCards = await contentRepo.getRabiesCards();
    final cardMap = {for (final card in allCards) card.id: card};

    if (isEndemic) {
      // Endemic region: full prevention + preparedness
      final preventionCardIds = [
        'rabies_prevent_avoid_animals',
        'rabies_prevent_no_feed_touch',
        'rabies_prevent_bats_in_room',
      ];

      // Add child supervision if needed
      if (traveler.ageYears < 16) {
        preventionCardIds.add('rabies_prevent_kids_supervision');
      }

      // Preparedness cards
      final preparednessCardIds = [
        'rabies_prepare_know_where_to_go',
        'rabies_prepare_consider_preexposure_vaccine',
      ];

      // Fetch and add all cards
      for (final cardId in preventionCardIds + preparednessCardIds) {
        final card = _getCardOrThrow(cardMap, cardId);
        cardsToAdd.add(card);
      }

      // Create prevention/preparedness checklist
      _addPreparednessChecklist(checklistToAdd);
    } else {
      // Non-endemic: minimal prevention guidance
      final cardId = 'rabies_prevent_avoid_animals';
      final card = _getCardOrThrow(cardMap, cardId);
      cardsToAdd.add(card);
    }
  }

  /// Exposure response cards: immediate wound care and seeking care.
  Future<void> _addExposureResponseCards({
    required Trip trip,
    required ExposureIntake exposure,
    required ContentRepository contentRepo,
    required List<GuidanceCard> cardsToAdd,
  }) async {
    final allCards = await contentRepo.getRabiesCards();
    final cardMap = {for (final card in allCards) card.id: card};

    // Always: immediate wound washing
    cardsToAdd.add(_getCardOrThrow(cardMap, 'rabies_exposure_wound_wash_now'));

    final destIso3 = _getDestinationIso3(trip);
    bool isEndemic = false;
    try {
      isEndemic = await contentRepo.isRabiesEndemic(destIso3);
    } catch (_) {
      isEndemic = false;
    }

    // Determine if this exposure warrants seeking care
    bool shouldSeekCare = false;

    // Rule 1: Bat exposure always requires care (even lick/saliva-only)
    if (exposure.animalType == AnimalType.bat) {
      shouldSeekCare = true;
    }

    // Rule 2: High-risk contact types
    if ([
      ExposureContactType.bite,
      ExposureContactType.scratch,
      ExposureContactType.salivaOnMucosa,
      ExposureContactType.salivaOnBrokenSkin,
    ].contains(exposure.contactType)) {
      shouldSeekCare = true;
    }

    // Rule 3: Endemic + bite/scratch with broken skin
    if (isEndemic &&
        exposure.skinBroken &&
        [AnimalType.dog, AnimalType.cat, AnimalType.monkey, AnimalType.other]
            .contains(exposure.animalType)) {
      shouldSeekCare = true;
    }

    // Rule 4: Low-risk scenario: lick on intact skin, no mucosa (only if NOT bat)
    if (exposure.animalType != AnimalType.bat &&
        exposure.contactType == ExposureContactType.lickOnIntactSkin &&
        !exposure.skinBroken &&
        !exposure.mucousMembrane) {
      cardsToAdd.add(_getCardOrThrow(cardMap, 'rabies_exposure_reassure_no_risk'));
      return; // No seek_care for low-risk
    }

    if (shouldSeekCare) {
      cardsToAdd.add(_getCardOrThrow(cardMap, 'rabies_exposure_seek_care_now'));
    }
  }

  /// Create deterministic checklist items for prevention/preparedness.
  void _addPreparednessChecklist(List<ChecklistItem> checklistToAdd) {
    checklistToAdd.addAll([
      ChecklistItem(
        id: 'rabies_checklist_hospital_address',
        label: 'Save the address and phone of a nearby clinic or hospital',
        category: ChecklistCategory.emergency,
      ),
      ChecklistItem(
        id: 'rabies_checklist_soap_sanitizer',
        label: 'Pack soap, hand sanitizer, or alcohol wipes for wound cleaning',
        category: ChecklistCategory.safety,
      ),
      ChecklistItem(
        id: 'rabies_checklist_discuss_vaccines',
        label:
            'Ask your doctor about pre-exposure rabies vaccine if visiting endemic areas for extended periods',
        category: ChecklistCategory.vaccines,
      ),
    ]);
  }

  /// Helper: fetch a card by ID and throw if missing.
  GuidanceCard _getCardOrThrow(Map<String, GuidanceCard> cardMap, String cardId) {
    final card = cardMap[cardId];
    if (card == null) {
      throw StateError('Rabies card "$cardId" not found in YAML content. '
          'Verify assets/content/rabies_public.yaml contains this card ID.');
    }
    return card;
  }
}
