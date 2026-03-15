import 'package:travelmd/data/repositories/content_repository.dart';
import 'package:travelmd/domain/models/traveler_profile.dart';
import 'package:travelmd/domain/models/trip.dart';
import 'package:travelmd/domain/modules/module_definition.dart';
import 'package:travelmd/domain/modules/module_evaluation_result.dart';
import 'package:travelmd/domain/modules/module_stream.dart';

abstract class ModuleEngine {
  const ModuleEngine();

  Future<ModuleEvaluationResult> evaluateModule({
    required ModuleDefinition module,
    required ModuleStream stream,
    required Trip trip,
    required TravelerProfile traveler,
    Object? intake,
    required ContentRepository contentRepository,
  });
}
