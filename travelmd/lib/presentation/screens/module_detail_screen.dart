import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:travelmd/domain/modules/module_stream.dart';
import 'package:travelmd/presentation/providers/app_providers.dart';
import 'package:travelmd/presentation/providers/module_catalog_providers.dart';
import 'package:travelmd/presentation/providers/module_navigation_providers.dart';
import 'package:travelmd/presentation/theme/app_theme.dart';
import 'package:travelmd/presentation/widgets/app_ui.dart';

class ModuleDetailScreen extends ConsumerWidget {
  final String moduleId;
  final ModuleStream stream;

  const ModuleDetailScreen({
    super.key,
    required this.moduleId,
    required this.stream,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registry = ref.watch(moduleRegistryProvider);
    final module = registry.byId(moduleId);

    if (module == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Module')),
        body: const Center(child: Text('Module not found.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(module.title)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          SectionHeader(
            title: '${module.title} Prevention Preview',
            subtitle: 'Public-facing guidance before incident workflows.',
          ),
          const SizedBox(height: AppSpacing.sm),
          SurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  module.title,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  module.description,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.md),
                const Text(
                  'What this module helps prevent',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  module.preventionFocus,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.md),
                const Text(
                  'Trip context dependency',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  module.requiresTripContext
                      ? 'This module uses destination and traveler context to build prevention guidance.'
                      : 'This module can generate prevention guidance without destination context.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final supportedStream in module.supportedStreams)
                      InfoChip(
                        label: supportedStream == ModuleStream.prevention
                            ? 'Prevention'
                            : 'Incident help',
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
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                ref.read(selectedPreventionModuleIdProvider.notifier).state = module.id;
                final route = ref.read(preventionEntryRouteProvider(module.id));
                context.go(route);
              },
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Start prevention planning'),
            ),
          ),
          if (module.supportsStream(ModuleStream.incidentResponse)) ...[
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  final route = ref.read(incidentEntryRouteProvider(module.id));
                  context.go(route);
                },
                icon: const Icon(Icons.warning_amber_rounded),
                label: const Text('Learn what to do if something happens'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
