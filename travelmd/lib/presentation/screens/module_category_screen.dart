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

class ModuleCategoryScreen extends ConsumerWidget {
  final String categoryId;

  const ModuleCategoryScreen({
    super.key,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = ref.watch(moduleCategoryRegistryProvider).byId(categoryId);
    final modules = ref.watch(modulesByCategoryProvider(categoryId));

    if (category == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Category')),
        body: const Center(child: Text('Category not found.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(category.title)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          SurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.title,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(category.shortDescription),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (modules.isEmpty)
            const EmptyStateCard(
              icon: Icons.upcoming_outlined,
              title: 'More topics coming soon',
              message: 'This public category is ready for future modules, but no topic is available here yet.',
            )
          else
            ...modules.map(
              (module) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: _CategoryModuleTile(
                  categoryId: categoryId,
                  module: module,
                  stream: category.primaryStream,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CategoryModuleTile extends ConsumerWidget {
  final String categoryId;
  final ModuleDefinition module;
  final ModuleStream stream;

  const _CategoryModuleTile({
    required this.categoryId,
    required this.module,
    required this.stream,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SurfaceCard(
      child: ListTile(
        key: Key('category-module-tile-$categoryId-${module.id}'),
        contentPadding: EdgeInsets.zero,
        leading: Icon(
          stream == ModuleStream.prevention ? Icons.shield_outlined : Icons.warning_amber_rounded,
          color: AppColors.brand,
        ),
        title: Text(module.title),
        subtitle: Text(module.description),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          if (stream == ModuleStream.prevention) {
            ref.read(selectedPreventionModuleIdProvider.notifier).state = module.id;
            context.go('/modules/${module.id}?stream=prevention');
            return;
          }

          final route = ref.read(incidentEntryRouteProvider(module.id));
          context.go(route);
        },
      ),
    );
  }
}
