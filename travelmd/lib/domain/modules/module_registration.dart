import 'package:travelmd/domain/modules/module_definition.dart';
import 'package:travelmd/domain/modules/module_engine.dart';

class ModuleRegistration {
  final ModuleDefinition definition;
  final ModuleEngine? preventionEngine;
  final ModuleEngine? incidentEngine;

  const ModuleRegistration({
    required this.definition,
    this.preventionEngine,
    this.incidentEngine,
  });
}
