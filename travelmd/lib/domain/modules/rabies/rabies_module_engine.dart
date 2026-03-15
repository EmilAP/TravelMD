import 'package:travelmd/data/repositories/content_repository.dart';
import 'package:travelmd/domain/models/traveler_profile.dart';
import 'package:travelmd/domain/models/trip.dart';
import 'package:travelmd/domain/modules/module_definition.dart';
import 'package:travelmd/domain/modules/module_engine.dart';
import 'package:travelmd/domain/modules/module_evaluation_result.dart';
import 'package:travelmd/domain/modules/module_stream.dart';
import 'package:travelmd/domain/modules/rabies/rabies_incident_engine.dart';
import 'package:travelmd/domain/modules/rabies/rabies_prevention_engine.dart';

class RabiesModuleEngine implements ModuleEngine {
  final RabiesPreventionEngine _preventionEngine;
  final RabiesIncidentEngine _incidentEngine;

  const RabiesModuleEngine({
    RabiesPreventionEngine preventionEngine = const RabiesPreventionEngine(),
    RabiesIncidentEngine incidentEngine = const RabiesIncidentEngine(),
  })  : _preventionEngine = preventionEngine,
        _incidentEngine = incidentEngine;

  @override
  Future<ModuleEvaluationResult> evaluateModule({
    required ModuleDefinition module,
    required ModuleStream stream,
    required Trip trip,
    required TravelerProfile traveler,
    Object? intake,
    required ContentRepository contentRepository,
  }) {
    switch (stream) {
      case ModuleStream.prevention:
        return _preventionEngine.evaluateModule(
          module: module,
          stream: stream,
          trip: trip,
          traveler: traveler,
          intake: intake,
          contentRepository: contentRepository,
        );
      case ModuleStream.incidentResponse:
        return _incidentEngine.evaluateModule(
          module: module,
          stream: stream,
          trip: trip,
          traveler: traveler,
          intake: intake,
          contentRepository: contentRepository,
        );
    }
  }
}
