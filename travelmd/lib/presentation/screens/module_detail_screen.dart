import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:travelmd/domain/enums/card_priority.dart';
import 'package:travelmd/domain/enums/content_timing.dart';
import 'package:travelmd/domain/models/guidance_card.dart';
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
    final cardsFuture = _loadModuleCards(ref, moduleId);

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
                    if (module.isInformationalGuide)
                      const InfoChip(
                        label: 'Informational guide',
                        icon: Icons.info_outline,
                        color: AppColors.textSecondary,
                      ),
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
          _GuidancePreviewSection(cardsFuture: cardsFuture),
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

  Future<List<GuidanceCard>> _loadModuleCards(WidgetRef ref, String id) async {
    final repository = ref.read(contentRepositoryProvider);
    await repository.loadAll();

    switch (id) {
      case 'rabies':
        return repository.getRabiesCards();
      case 'malaria':
        return repository.getMalariaCards();
      case 'pretravel_readiness':
        return repository.getPretravelReadinessCards();
      case 'food_water_safety':
        return repository.getFoodWaterSafetyCards();
      case 'travel_injury_prevention':
        return repository.getTravelInjuryPreventionCards();
      default:
        return const [];
    }
  }
}

class _GuidancePreviewSection extends StatelessWidget {
  final Future<List<GuidanceCard>> cardsFuture;

  const _GuidancePreviewSection({required this.cardsFuture});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<GuidanceCard>>(
      future: cardsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SurfaceCard(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return const SurfaceCard(
            child: Text('Unable to load guidance preview right now.'),
          );
        }

        final cards = _sortByPriorityStable(snapshot.data ?? const []);
        if (cards.isEmpty) {
          return const SizedBox.shrink();
        }

        final keyThings = cards.where((card) => card.priority == CardPriority.high).take(3).toList();
        final beforeTravel = cards.where((card) => card.timing == ContentTiming.beforeTravel).toList();
        final duringTravel = cards.where((card) => card.timing == ContentTiming.duringTravel).toList();
        final both = cards.where((card) => card.timing == ContentTiming.both).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (keyThings.isNotEmpty) ...[
              const SectionHeader(
                title: 'Key things to do',
                subtitle: 'Top high-priority actions to focus on first.',
              ),
              const SizedBox(height: AppSpacing.sm),
              SurfaceCard(
                child: Column(
                  children: [
                    for (int i = 0; i < keyThings.length; i++)
                      _GuidanceCardRow(
                        card: keyThings[i],
                        showBottomSpacing: i != keyThings.length - 1,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
            _TimingSection(
              title: 'Before you go',
              cards: beforeTravel,
            ),
            const SizedBox(height: AppSpacing.md),
            _TimingSection(
              title: 'During your trip',
              cards: duringTravel,
            ),
            if (both.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              _TimingSection(
                title: 'Any time',
                cards: both,
              ),
            ],
          ],
        );
      },
    );
  }

  static List<GuidanceCard> _sortByPriorityStable(List<GuidanceCard> cards) {
    final indexed = cards.asMap().entries.toList(growable: false);
    indexed.sort((a, b) {
      final priorityCompare = _priorityRank(a.value.priority).compareTo(_priorityRank(b.value.priority));
      if (priorityCompare != 0) {
        return priorityCompare;
      }
      return a.key.compareTo(b.key);
    });
    return indexed.map((entry) => entry.value).toList(growable: false);
  }

  static int _priorityRank(CardPriority priority) {
    switch (priority) {
      case CardPriority.high:
        return 0;
      case CardPriority.medium:
        return 1;
      case CardPriority.low:
        return 2;
    }
  }
}

class _TimingSection extends StatelessWidget {
  final String title;
  final List<GuidanceCard> cards;

  const _TimingSection({
    required this.title,
    required this.cards,
  });

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SurfaceCard(
          child: Column(
            children: [
              for (int i = 0; i < cards.length; i++)
                _GuidanceCardRow(
                  card: cards[i],
                  showBottomSpacing: i != cards.length - 1,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GuidanceCardRow extends StatelessWidget {
  final GuidanceCard card;
  final bool showBottomSpacing;

  const _GuidanceCardRow({
    required this.card,
    this.showBottomSpacing = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: showBottomSpacing ? AppSpacing.sm : 0),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(card.title),
        subtitle: Text(card.summary),
      ),
    );
  }
}
