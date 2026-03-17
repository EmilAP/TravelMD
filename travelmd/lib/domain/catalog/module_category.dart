import 'package:travelmd/domain/modules/module_stream.dart';

class ModuleCategory {
  final String id;
  final String title;
  final String shortDescription;
  final String iconKey;
  final List<String> moduleIds;
  final ModuleStream primaryStream;

  const ModuleCategory({
    required this.id,
    required this.title,
    required this.shortDescription,
    required this.iconKey,
    required this.moduleIds,
    required this.primaryStream,
  });
}
