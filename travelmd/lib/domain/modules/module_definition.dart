import 'package:travelmd/domain/modules/module_stream.dart';

class ModuleDefinition {
  final String id;
  final String title;
  final String description;
  final String preventionFocus;
  final String iconKey;
  final bool requiresTripContext;
  final bool isInformationalGuide;
  final List<ModuleStream> supportedStreams;
  final bool enabled;

  const ModuleDefinition({
    required this.id,
    required this.title,
    required this.description,
    required this.preventionFocus,
    required this.iconKey,
    this.requiresTripContext = true,
    this.isInformationalGuide = false,
    required this.supportedStreams,
    this.enabled = true,
  });

  bool supportsStream(ModuleStream stream) => supportedStreams.contains(stream);
}
