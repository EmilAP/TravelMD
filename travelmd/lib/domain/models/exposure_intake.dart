import 'package:travelmd/domain/enums/animal_type.dart';
import 'package:travelmd/domain/enums/exposure_contact_type.dart';
import 'package:travelmd/domain/enums/yes_no_unknown.dart';
import 'package:travelmd/domain/enums/body_location.dart';

/// Public-facing intake questions for an exposure event.
class ExposureIntake {
  final AnimalType animalType;
  final ExposureContactType contactType;
  final String countryIso3; // ISO3
  final bool skinBroken;
  final bool mucousMembrane;
  final bool? bleeding;
  final YesNoUnknown animalAvailableForObservationOrTesting;
  final int? timeSinceExposureHours;
  final BodyLocation? bodyLocation;

  ExposureIntake({
    this.animalType = AnimalType.other,
    this.contactType = ExposureContactType.other,
    this.countryIso3 = '',
    this.skinBroken = false,
    this.mucousMembrane = false,
    this.bleeding,
    this.animalAvailableForObservationOrTesting = YesNoUnknown.unknown,
    this.timeSinceExposureHours,
    this.bodyLocation,
  });
}
