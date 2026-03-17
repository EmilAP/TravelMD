import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:travelmd/domain/catalog/module_category.dart';
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
    final preventionCategories = ref.watch(preventionCategoriesProvider);
    final incidentCategories = ref.watch(incidentCategoriesProvider);

    final orderedSections = _buildOrderedSections(
      preventionCategories: preventionCategories,
      incidentCategories: incidentCategories,
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
                  'Browse public travel health categories and continue into the most relevant topic flow.',
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
                    if (section.categories.isEmpty)
                      EmptyStateCard(
                        icon: section.stream == ModuleStream.prevention
                            ? Icons.shield_outlined
                            : Icons.warning_amber_rounded,
                        title: section.emptyTitle,
                        message: section.emptyMessage,
                      )
                    else
                      ...section.categories.map(
                        (category) => Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: _CategoryTile(
                            category: category,
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
    required List<ModuleCategory> preventionCategories,
    required List<ModuleCategory> incidentCategories,
  }) {
    final sections = <_ModuleSection>[
      _ModuleSection(
        stream: ModuleStream.prevention,
        title: 'Prevention Categories',
        subtitle: 'Start with broad, practical ways to stay safer while traveling.',
        emptyTitle: 'No prevention categories available',
        emptyMessage: 'Public prevention categories will appear here.',
        categories: preventionCategories,
      ),
      _ModuleSection(
        stream: ModuleStream.incidentResponse,
        title: 'If Something Happens',
        subtitle: 'Get action-oriented help after an exposure or incident.',
        emptyTitle: 'No incident categories available',
        emptyMessage: 'Public incident-help categories will appear here.',
        categories: incidentCategories,
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
  final List<ModuleCategory> categories;

  const _ModuleSection({
    required this.stream,
    required this.title,
    required this.subtitle,
    required this.emptyTitle,
    required this.emptyMessage,
    required this.categories,
  });
}

class _CategoryTile extends ConsumerWidget {
  final ModuleCategory category;

  const _CategoryTile({
    required this.category,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modules = ref.watch(modulesByCategoryProvider(category.id));

    return SurfaceCard(
      key: Key('category-tile-${category.id}'),
      child: InkWell(
        onTap: () => _openCategory(context, ref, modules),
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
                child: Icon(_iconForKey(category.iconKey), color: AppColors.brand),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.title,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      category.shortDescription,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        InfoChip(
                          label: _streamLabel(category.primaryStream),
                          icon: category.primaryStream == ModuleStream.prevention
                              ? Icons.shield_outlined
                              : Icons.warning_amber_rounded,
                          color: category.primaryStream == ModuleStream.prevention
                              ? AppColors.brand
                              : Colors.orange.shade700,
                        ),
                        InfoChip(
                          label: modules.isEmpty
                              ? 'Coming soon'
                              : modules.length == 1
                                  ? '1 topic'
                                  : '${modules.length} topics',
                          icon: Icons.topic_outlined,
                          color: AppColors.textSecondary,
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

  void _openCategory(
    BuildContext context,
    WidgetRef ref,
    List<ModuleDefinition> modules,
  ) {
    if (modules.isEmpty) {
      context.go('/modules/category/${category.id}');
      return;
    }

    if (modules.length > 1) {
      context.go('/modules/category/${category.id}');
      return;
    }

    final module = modules.first;
    if (category.primaryStream == ModuleStream.prevention) {
      ref.read(selectedPreventionModuleIdProvider.notifier).state = module.id;
      context.go('/modules/${module.id}?stream=prevention');
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
    case 'luggage':
      return Icons.luggage;
    case 'restaurant':
      return Icons.restaurant;
    case 'emergency':
      return Icons.emergency;
    default:
      return Icons.health_and_safety;
  }
}
