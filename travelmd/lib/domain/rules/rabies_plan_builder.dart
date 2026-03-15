import 'package:travelmd/domain/models/trip.dart';
import 'package:travelmd/domain/models/traveler_profile.dart';
import 'package:travelmd/domain/models/exposure_intake.dart';
import 'package:travelmd/domain/models/public_plan_patch.dart';
import 'package:travelmd/domain/modules/module_execution_service.dart';
import 'package:travelmd/data/repositories/content_repository.dart';

/// Deterministic, public-facing Rabies plan builder.
/// 
/// Generates a PublicPlanPatch by combining Trip, TravelerProfile, and optional ExposureIntake
/// with YAML-driven GuidanceCards. Emphasizes prevention/preparedness by default.
class RabiesPlanBuilder {
  final ModuleExecutionService _executionService;

  const RabiesPlanBuilder({
    ModuleExecutionService executionService = const ModuleExecutionService(),
  }) : _executionService = executionService;

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
    final result = exposure == null
        ? await _executionService.evaluatePrevention(
            moduleId: 'rabies',
            trip: trip,
            traveler: traveler,
            contentRepository: contentRepo,
          )
        : await _executionService.evaluateIncident(
            moduleId: 'rabies',
            trip: trip,
            traveler: traveler,
            intake: exposure,
            contentRepository: contentRepo,
          );

    return PublicPlanPatch(
      cardsToAdd: result.cardsToAdd,
      checklistToAdd: result.checklistToAdd,
      timelineToAdd: result.timelineToAdd,
    );
  }
}
