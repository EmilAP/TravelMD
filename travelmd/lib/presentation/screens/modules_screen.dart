import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:travelmd/domain/modules/module_definition.dart';
import 'package:travelmd/domain/modules/module_stream.dart';
import 'package:travelmd/presentation/providers/app_providers.dart';
import 'package:travelmd/presentation/providers/module_catalog_providers.dart';
import 'package:travelmd/presentation/providers/module_navigation_providers.dart';
import 'package:travelmd/presentation/theme/app_theme.dart';
import 'package:travelmd/presentation/widgets/app_ui.dart';

class ModulesScreen extends ConsumerWidget {
  final ModuleStream? focusStream;

  const ModulesScreen({
    super.key,
    this.focusStream,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preventionModules = ref.watch(preventionModulesProvider);
    final incidentModules = ref.watch(incidentModulesProvider);

    final orderedSections = _buildOrderedSections(
      preventionModules: preventionModules,
      incidentModules: incidentModules,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Module Catalog'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          SurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Prevention topics come first. Incident help stays available when something happens.',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Browse travel health modules by stream and continue into the matching workflow.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          for (final section in orderedSections) ...[
              Container(
                key: Key('module-section-${section.stream.name}'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(
                      title: section.title,
                      subtitle: section.subtitle,
                      trailing: focusStream == section.stream
                          ? const StatusBadge(label: 'Current focus', color: AppColors.brand)
                          : null,
                  ),
                    const SizedBox(height: AppSpacing.sm),
                    if (section.modules.isEmpty)
                      EmptyStateCard(
                        icon: section.stream == ModuleStream.prevention
                            ? Icons.shield_outlined
                            : Icons.warning_amber_rounded,
                        title: section.emptyTitle,
                        message: section.emptyMessage,
                      )
                    else
                      ...section.modules.map(
                        (module) => Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: _ModuleTile(
                            module: module,
                            stream: section.stream,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ],
      ),
    );
  }

  List<_ModuleSection> _buildOrderedSections({
    required List<ModuleDefinition> preventionModules,
    required List<ModuleDefinition> incidentModules,
  }) {
    final sections = <_ModuleSection>[
      _ModuleSection(
        stream: ModuleStream.prevention,
        title: 'Prevention Modules',
        subtitle: 'Prepare ahead with prevention and preparedness guidance.',
        emptyTitle: 'No prevention modules available',
        emptyMessage: 'Enabled prevention topics will appear here.',
        modules: preventionModules,
      ),
      _ModuleSection(
        stream: ModuleStream.incidentResponse,
        title: 'Incident Help Modules',
        subtitle: 'Get fast guidance after an exposure or incident.',
        emptyTitle: 'No incident help modules available',
        emptyMessage: 'Enabled incident-response topics will appear here.',
        modules: incidentModules,
      ),
    ];

    if (focusStream == null) {
      return sections;
    }

    sections.sort((left, right) {
      if (left.stream == focusStream) {
        return -1;
      }
      if (right.stream == focusStream) {
        return 1;
      }
      return 0;
    });
    return sections;
  }
}

class _ModuleSection {
  final ModuleStream stream;
  final String title;
  final String subtitle;
  final String emptyTitle;
  final String emptyMessage;
  final List<ModuleDefinition> modules;

  const _ModuleSection({
    required this.stream,
    required this.title,
    required this.subtitle,
    required this.emptyTitle,
    required this.emptyMessage,
    required this.modules,
  });
}

class _ModuleTile extends ConsumerWidget {
  final ModuleDefinition module;
  final ModuleStream stream;

  const _ModuleTile({
    required this.module,
    required this.stream,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SurfaceCard(
      key: Key('module-tile-${stream.name}-${module.id}'),
      child: InkWell(
        onTap: () => _openModule(context, ref),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.zero,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.brandSoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_iconForKey(module.iconKey), color: AppColors.brand),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      module.title,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      module.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final supportedStream in module.supportedStreams)
                          InfoChip(
                            label: _streamLabel(supportedStream),
                            icon: supportedStream == ModuleStream.prevention
                                ? Icons.shield_outlined
                                : Icons.warning_amber_rounded,
                            color: supportedStream == ModuleStream.prevention
                                ? AppColors.brand
                                : Colors.orange.shade700,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  void _openModule(BuildContext context, WidgetRef ref) {
    if (stream == ModuleStream.prevention) {
      ref.read(selectedPreventionModuleIdProvider.notifier).state = module.id;
      context.go('/modules/${module.id}?stream=${stream.name}');
      return;
    }

    final route = ref.read(incidentEntryRouteProvider(module.id));
    context.go(route);
  }
}

String _streamLabel(ModuleStream stream) {
  switch (stream) {
    case ModuleStream.prevention:
      return 'Prevention';
    case ModuleStream.incidentResponse:
      return 'Incident help';
  }
}

IconData _iconForKey(String iconKey) {
  switch (iconKey) {
    case 'pets':
      return Icons.pets;
    case 'bug_report':
      return Icons.bug_report;
    default:
      return Icons.health_and_safety;
  }
}
