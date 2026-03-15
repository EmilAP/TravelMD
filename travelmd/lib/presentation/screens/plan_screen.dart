import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:travelmd/data/repositories/content_repository.dart';
import 'package:travelmd/domain/enums/checklist_category.dart';
import 'package:travelmd/domain/enums/urgency.dart';
import 'package:travelmd/domain/enums/when_to_do.dart';
import 'package:travelmd/domain/models/checklist_item.dart';
import 'package:travelmd/domain/models/guidance_card.dart';
import 'package:travelmd/domain/models/public_plan.dart';
import 'package:travelmd/domain/models/traveler_profile.dart';
import 'package:travelmd/domain/models/trip.dart';
import 'package:travelmd/domain/modules/module_registry.dart';
import 'package:travelmd/presentation/providers/app_providers.dart';
import 'package:travelmd/presentation/theme/app_theme.dart';
import 'package:travelmd/presentation/widgets/app_ui.dart';

/// Dashboard-style summary of generated travel health recommendations.
class PlanScreen extends ConsumerWidget {
  const PlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planAsync = ref.watch(preventionPlanProvider);
    final selectedModuleId = ref.watch(selectedPreventionModuleIdProvider);
    final selectedModule = ModuleRegistry.defaultRegistry.byId(selectedModuleId);
    final trip = ref.watch(tripProvider);
    final traveler = ref.watch(travelerProvider);
    final tripId = ref.watch(tripIsarIdProvider);
    final travelerId = ref.watch(travelerIsarIdProvider);
    final persistedChecklistAsync = ref.watch(persistedChecklistStateProvider);

    persistedChecklistAsync.whenData((checklistState) {
      if (checklistState.isNotEmpty) {
        ref.read(checklistStateProvider.notifier).loadState(checklistState);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedModule == null
            ? 'Travel Health Dashboard'
            : '${selectedModule.title} Prevention Plan'),
      ),
      body: planAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Error loading plan: $err'),
          ),
        ),
        data: (plan) {
          if (tripId != null && travelerId != null && plan.checklist.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              try {
                final storage = await ref.read(storageRepositoryProvider.future);
                final selectedCardIds = plan.cards.map((card) => card.id).toList();
                await storage.savePlanSelection(
                  tripId: tripId,
                  travelerId: travelerId,
                  selectedCardIds: selectedCardIds,
                );
              } catch (e) {
                debugPrint('Error saving plan selection: $e');
              }
            });
          }

          if (plan.cards.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: EmptyStateCard(
                  icon: Icons.insights_outlined,
                  title: 'No recommendations available yet',
                  message:
                      'Complete trip and traveler details to generate an actionable travel health summary.',
                  action: ElevatedButton(
                    onPressed: () => context.go('/'),
                    child: const Text('Back to Home'),
                  ),
                ),
              ),
            );
          }

          final groups = _buildGroups(plan.cards);
          final checklistState = ref.watch(checklistStateProvider);
          final doneCount = plan.checklist
              .where((item) => checklistState[item.id] ?? false)
              .length;
          final totalCount = plan.checklist.length;
          final completion = totalCount == 0 ? 0.0 : doneCount / totalCount;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TripSummaryCard(trip: trip),
                const SizedBox(height: AppSpacing.md),
                _TravelerSummaryCard(traveler: traveler),
                const SizedBox(height: AppSpacing.md),
                _TravelHealthSummaryCard(
                  plan: plan,
                  completion: completion,
                  doneCount: doneCount,
                  totalCount: totalCount,
                ),
                const SizedBox(height: AppSpacing.lg),
                const SectionHeader(
                  title: 'Recommendations',
                  subtitle: 'Organized for preparation, response, and confidence-building.',
                ),
                const SizedBox(height: AppSpacing.sm),
                _RecommendationSection(
                  title: 'Prevention & Preparedness',
                  icon: Icons.shield_outlined,
                  cards: groups.preventionPreparedness,
                  emptyText: 'No prevention-specific cards for this context.',
                ),
                const SizedBox(height: AppSpacing.md),
                _RecommendationSection(
                  title: 'Actions Before Travel',
                  icon: Icons.event_note,
                  cards: groups.beforeTravel,
                  emptyText: 'No dedicated before-travel actions identified.',
                ),
                const SizedBox(height: AppSpacing.md),
                _RecommendationSection(
                  title: 'Actions If Exposed',
                  icon: Icons.local_hospital_outlined,
                  cards: groups.ifExposed,
                  emptyText: 'No exposure-response actions currently present in this plan.',
                ),
                const SizedBox(height: AppSpacing.md),
                _RecommendationSection(
                  title: 'Reassurance / Lower-Risk Guidance',
                  icon: Icons.verified_user_outlined,
                  cards: groups.reassurance,
                  emptyText: 'No lower-risk reassurance guidance identified.',
                ),
                if (groups.additional.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.md),
                  _RecommendationSection(
                    title: 'Additional Guidance',
                    icon: Icons.list_alt,
                    cards: groups.additional,
                    emptyText: '',
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
                _ChecklistSection(items: plan.checklist),
                const SizedBox(height: AppSpacing.lg),
                _SourcesSection(
                  sourceIds: _collectSourceIds(plan.cards, plan.checklist),
                ),
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => context.go('/trip/traveler/plan/exposure'),
                    icon: const Icon(Icons.warning_amber_rounded),
                    label: const Text('Run Exposure Triage'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.important,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TripSummaryCard extends StatelessWidget {
  final Trip? trip;

  const _TripSummaryCard({required this.trip});

  @override
  Widget build(BuildContext context) {
    if (trip == null) {
      return const EmptyStateCard(
        icon: Icons.map_outlined,
        title: 'Trip Summary Unavailable',
        message: 'Add trip details to get destination-specific guidance context.',
      );
    }

    final transit = trip!.transitCountries.isEmpty
        ? 'None'
        : trip!.transitCountries.join(', ');

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Trip Summary',
            subtitle: 'Geographic context for risk and preparedness.',
          ),
          const SizedBox(height: AppSpacing.sm),
          LabelValueRow(label: 'Destination', value: trip!.destinationCountry),
          LabelValueRow(label: 'Departure', value: _dateLabel(trip!.departDate)),
          LabelValueRow(label: 'Return', value: _dateLabel(trip!.returnDate)),
          LabelValueRow(label: 'Transit', value: transit),
        ],
      ),
    );
  }
}

class _TravelerSummaryCard extends StatelessWidget {
  final TravelerProfile? traveler;

  const _TravelerSummaryCard({required this.traveler});

  @override
  Widget build(BuildContext context) {
    if (traveler == null) {
      return const EmptyStateCard(
        icon: Icons.person_outline,
        title: 'Traveler Profile Unavailable',
        message: 'Add traveler details to tailor recommendation framing.',
      );
    }

    final tags = <Widget>[
      InfoChip(label: 'Age ${traveler!.ageYears}', icon: Icons.cake_outlined),
      InfoChip(label: traveler!.purpose, icon: Icons.badge_outlined),
      if (traveler!.isVFR)
        const InfoChip(label: 'VFR', icon: Icons.groups_2_outlined, color: AppColors.important),
      if (traveler!.isPregnant)
        const InfoChip(label: 'Pregnant', icon: Icons.pregnant_woman, color: AppColors.important),
      if (traveler!.isImmunocompromised)
        const InfoChip(label: 'Immunocompromised', icon: Icons.monitor_heart, color: AppColors.urgent),
    ];

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Traveler Profile',
            subtitle: 'Risk modifiers used to personalize guidance.',
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(spacing: 8, runSpacing: 8, children: tags),
        ],
      ),
    );
  }
}

class _TravelHealthSummaryCard extends StatelessWidget {
  final PublicPlan plan;
  final double completion;
  final int doneCount;
  final int totalCount;

  const _TravelHealthSummaryCard({
    required this.plan,
    required this.completion,
    required this.doneCount,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    final urgent = plan.cards.where((c) => c.urgency == Urgency.urgent).length;
    final important = plan.cards.where((c) => c.urgency == Urgency.important).length;
    final routine = plan.cards.where((c) => c.urgency == Urgency.routine).length;

    final header = urgent > 0
        ? 'Immediate action guidance is present in this plan.'
        : important > 0
            ? 'Important preparedness actions are highlighted.'
            : 'This plan is focused on routine prevention and awareness.';

    final color = urgent > 0
        ? AppColors.urgent
        : important > 0
            ? AppColors.important
            : AppColors.routine;

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Travel Health Summary',
            subtitle: 'At-a-glance recommendation profile for this trip context.',
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              border: Border.all(color: color.withOpacity(0.35)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: color),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    header,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              InfoChip(label: '$urgent urgent', color: AppColors.urgent),
              InfoChip(label: '$important important', color: AppColors.important),
              InfoChip(label: '$routine routine', color: AppColors.routine),
              if (totalCount > 0)
                InfoChip(label: '$doneCount/$totalCount checklist complete', icon: Icons.check_circle_outline),
            ],
          ),
          if (totalCount > 0) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: completion,
                minHeight: 9,
                backgroundColor: const Color(0xFFE2E8E9),
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
              ),
            ),
          ],
          if (plan.summary.trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(plan.summary, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}

class _RecommendationSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<GuidanceCard> cards;
  final String emptyText;

  const _RecommendationSection({
    required this.title,
    required this.icon,
    required this.cards,
    required this.emptyText,
  });

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.brand),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (cards.isEmpty)
            Text(
              emptyText,
              style: Theme.of(context).textTheme.bodySmall,
            )
          else
            ...cards.map((card) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _RecommendationCard(card: card),
                )),
        ],
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  final GuidanceCard card;

  const _RecommendationCard({required this.card});

  @override
  Widget build(BuildContext context) {
    final color = _urgencyColor(card.urgency);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8E9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StatusBadge(label: card.urgency.name.toUpperCase(), color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  card.title,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                ),
              ),
              const SizedBox(width: 8),
              InfoChip(label: _whenLabel(card.whenToDoIt)),
            ],
          ),
          if (card.summary.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(card.summary),
          ],
          if (card.whyThisMatters.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF7FAFA),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Why this matters: ${card.whyThisMatters}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
          if (card.steps.isNotEmpty) ...[
            const SizedBox(height: 8),
            const Text(
              'Actions',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            ),
            const SizedBox(height: 6),
            ...card.steps.map(
              (step) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.chevron_right, size: 18, color: color),
                    Expanded(
                      child: Text(step.label, style: const TextStyle(fontSize: 13)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ChecklistSection extends ConsumerWidget {
  final List<ChecklistItem> items;

  const _ChecklistSection({required this.items});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (items.isEmpty) {
      return const EmptyStateCard(
        icon: Icons.checklist,
        title: 'No Checklist Items',
        message: 'Checklist actions appear here when preparedness tasks are generated.',
      );
    }

    final checklistState = ref.watch(checklistStateProvider);
    final done = items.where((item) => checklistState[item.id] ?? false).length;
    final progress = done / items.length;

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Action Checklist',
            subtitle: 'Track completion of high-value preparation tasks.',
          ),
          const SizedBox(height: 10),
          Text('$done of ${items.length} complete', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: const Color(0xFFE2E8E9),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.brand),
            ),
          ),
          const SizedBox(height: 12),
          ...items.map((item) => _ChecklistItemWidget(item: item)),
        ],
      ),
    );
  }
}

class _ChecklistItemWidget extends ConsumerWidget {
  final ChecklistItem item;

  const _ChecklistItemWidget({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checklistState = ref.watch(checklistStateProvider);
    final isDone = checklistState[item.id] ?? false;
    final tripId = ref.watch(tripIsarIdProvider);
    final travelerId = ref.watch(travelerIsarIdProvider);

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE3EAEB)),
      ),
      child: CheckboxListTile(
        title: Text(item.label),
        subtitle: Text(
          _checklistCategoryLabel(item.category),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        value: isDone,
        onChanged: (val) async {
          final itemId = item.id;
          ref.read(checklistStateProvider.notifier).toggleItem(itemId);

          if (tripId != null && travelerId != null) {
            try {
              final storage = await ref.read(storageRepositoryProvider.future);
              final planSelection =
                  await storage.loadPlanSelection(tripId: tripId, travelerId: travelerId);
              if (planSelection != null) {
                final newIsDone = !isDone;
                await storage.saveChecklistItemState(
                  planSelectionId: planSelection.id,
                  itemId: itemId,
                  isDone: newIsDone,
                );
              }
            } catch (e) {
              debugPrint('Error persisting checklist state: $e');
            }
          }
        },
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }
}

class _SourcesSection extends ConsumerWidget {
  final List<String> sourceIds;

  const _SourcesSection({required this.sourceIds});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Sources',
            subtitle: 'Reference links and organizations behind displayed guidance.',
          ),
          const SizedBox(height: 10),
          if (sourceIds.isEmpty)
            Text(
              'No source references were attached to the current recommendations.',
              style: Theme.of(context).textTheme.bodySmall,
            )
          else
            FutureBuilder<List<_SourceItem>>(
              future: _loadSources(ref.read(contentRepositoryProvider), sourceIds),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: CircularProgressIndicator(),
                  );
                }
                final rows = snapshot.data ?? const <_SourceItem>[];
                if (rows.isEmpty) {
                  return Text(
                    'Source metadata is unavailable for these references.',
                    style: Theme.of(context).textTheme.bodySmall,
                  );
                }

                return Column(
                  children: rows.map((row) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFE2E8E9)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.menu_book_outlined, size: 18, color: AppColors.brand),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(row.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                                Text(row.organization, style: Theme.of(context).textTheme.bodySmall),
                                if (row.url.isNotEmpty)
                                  Text(
                                    row.url,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: AppColors.brand,
                                          decoration: TextDecoration.underline,
                                        ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
        ],
      ),
    );
  }
}

Future<List<_SourceItem>> _loadSources(ContentRepository repo, List<String> ids) async {
  final result = <_SourceItem>[];
  for (final id in ids) {
    final source = await repo.getSource(id);
    if (source == null) {
      continue;
    }
    result.add(
      _SourceItem(
        id: id,
        title: (source['title'] ?? id).toString(),
        organization: (source['organization'] ?? '').toString(),
        url: (source['url'] ?? '').toString(),
      ),
    );
  }
  return result;
}

class _SourceItem {
  final String id;
  final String title;
  final String organization;
  final String url;

  const _SourceItem({
    required this.id,
    required this.title,
    required this.organization,
    required this.url,
  });
}

class _CardGroups {
  final List<GuidanceCard> preventionPreparedness;
  final List<GuidanceCard> beforeTravel;
  final List<GuidanceCard> ifExposed;
  final List<GuidanceCard> reassurance;
  final List<GuidanceCard> additional;

  const _CardGroups({
    required this.preventionPreparedness,
    required this.beforeTravel,
    required this.ifExposed,
    required this.reassurance,
    required this.additional,
  });
}

_CardGroups _buildGroups(List<GuidanceCard> cards) {
  final sorted = List<GuidanceCard>.from(cards)
    ..sort((a, b) {
      final urgencyOrder = {Urgency.urgent: 0, Urgency.important: 1, Urgency.routine: 2};
      final urgencyA = urgencyOrder[a.urgency] ?? 999;
      final urgencyB = urgencyOrder[b.urgency] ?? 999;
      if (urgencyA != urgencyB) return urgencyA.compareTo(urgencyB);
      return a.whenToDoIt.index.compareTo(b.whenToDoIt.index);
    });

  final assigned = <String>{};
  final prevention = <GuidanceCard>[];
  final beforeTravel = <GuidanceCard>[];
  final exposure = <GuidanceCard>[];
  final reassurance = <GuidanceCard>[];
  final additional = <GuidanceCard>[];

  for (final card in sorted) {
    if (card.id.startsWith('rabies_prevent_') || card.id.startsWith('rabies_prepare_')) {
      prevention.add(card);
      assigned.add(card.id);
    }
  }

  for (final card in sorted) {
    if (assigned.contains(card.id)) continue;
    if (card.whenToDoIt == WhenToDo.beforeTravel) {
      beforeTravel.add(card);
      assigned.add(card.id);
    }
  }

  for (final card in sorted) {
    if (assigned.contains(card.id)) continue;
    if (card.id.startsWith('rabies_exposure_') && !card.id.contains('reassure')) {
      exposure.add(card);
      assigned.add(card.id);
    }
  }

  for (final card in sorted) {
    if (assigned.contains(card.id)) continue;
    if (card.id.contains('reassure') ||
        card.summary.toLowerCase().contains('low risk') ||
        card.title.toLowerCase().contains('low risk')) {
      reassurance.add(card);
      assigned.add(card.id);
    }
  }

  for (final card in sorted) {
    if (assigned.contains(card.id)) continue;
    additional.add(card);
  }

  return _CardGroups(
    preventionPreparedness: prevention,
    beforeTravel: beforeTravel,
    ifExposed: exposure,
    reassurance: reassurance,
    additional: additional,
  );
}

List<String> _collectSourceIds(List<GuidanceCard> cards, List<ChecklistItem> checklist) {
  final ids = <String>{};
  for (final card in cards) {
    ids.addAll(card.sourceRefs);
  }
  for (final item in checklist) {
    ids.addAll(item.sourceRefs);
  }
  return ids.toList()..sort();
}

Color _urgencyColor(Urgency urgency) {
  switch (urgency) {
    case Urgency.urgent:
      return AppColors.urgent;
    case Urgency.important:
      return AppColors.important;
    case Urgency.routine:
      return AppColors.routine;
  }
}

String _whenLabel(WhenToDo when) {
  switch (when) {
    case WhenToDo.now:
      return 'Now';
    case WhenToDo.beforeTravel:
      return 'Before travel';
    case WhenToDo.duringTravel:
      return 'During travel';
    case WhenToDo.afterTravel:
      return 'After travel';
  }
}

String _checklistCategoryLabel(ChecklistCategory category) {
  switch (category) {
    case ChecklistCategory.documents:
      return 'Documents';
    case ChecklistCategory.vaccines:
      return 'Vaccines';
    case ChecklistCategory.meds:
      return 'Medications';
    case ChecklistCategory.safety:
      return 'Safety';
    case ChecklistCategory.emergency:
      return 'Emergency';
    case ChecklistCategory.other:
      return 'General';
  }
}

String _dateLabel(DateTime date) {
  return '${date.month}/${date.day}/${date.year}';
}
