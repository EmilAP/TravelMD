import 'package:travelmd/data/repositories/content_repository.dart';
import 'package:travelmd/domain/models/traveler_profile.dart';
import 'package:travelmd/domain/models/trip.dart';
import 'package:travelmd/domain/modules/module_evaluation_result.dart';
import 'package:travelmd/domain/modules/module_registry.dart';
import 'package:travelmd/domain/modules/module_stream.dart';

class ModuleExecutionService {
  final ModuleRegistry registry;

  const ModuleExecutionService({
    this.registry = ModuleRegistry.defaultRegistry,
  });

  Future<ModuleEvaluationResult> evaluatePrevention({
    required String moduleId,
    required Trip trip,
    required TravelerProfile traveler,
    required ContentRepository contentRepository,
  }) {
    final registration = _getRegistration(moduleId);
    final engine = registration.preventionEngine;
    if (engine == null) {
      throw StateError(
        'Module "$moduleId" does not support prevention evaluation.',
      );
    }

    return engine.evaluateModule(
      module: registration.definition,
      stream: ModuleStream.prevention,
      trip: trip,
      traveler: traveler,
      contentRepository: contentRepository,
    );
  }

  Future<ModuleEvaluationResult> evaluateIncident({
    required String moduleId,
    required Trip trip,
    required TravelerProfile traveler,
    Object? intake,
    required ContentRepository contentRepository,
  }) {
    final registration = _getRegistration(moduleId);
    final engine = registration.incidentEngine;
    if (engine == null) {
      throw StateError(
        'Module "$moduleId" does not support incidentResponse evaluation.',
      );
    }

    return engine.evaluateModule(
      module: registration.definition,
      stream: ModuleStream.incidentResponse,
      trip: trip,
      traveler: traveler,
      intake: intake,
      contentRepository: contentRepository,
    );
  }

  ModuleRegistration _getRegistration(String moduleId) {
    final registration = registry.registrationById(moduleId);
    if (registration == null || !registration.definition.enabled) {
      throw StateError('Module "$moduleId" is not available in the module registry.');
    }
    return registration;
  }
}
