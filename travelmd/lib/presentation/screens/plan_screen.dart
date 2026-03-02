import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:travelmd/domain/models/guidance_card.dart';
import 'package:travelmd/domain/enums/checklist_category.dart';
import 'package:travelmd/domain/enums/urgency.dart';
import 'package:travelmd/presentation/providers/app_providers.dart';

/// Plan screen: displays guidance cards and checklist.
/// Core of the app - shows prevention-first cards and allows checking off items.
class PlanScreen extends ConsumerWidget {
  const PlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planAsync = ref.watch(preventionPlanProvider);
    final trip = ref.watch(tripProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Travel Health Plan'),
        centerTitle: true,
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
          if (plan.cards.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.info_outline, size: 48, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text(
                      'No guidance cards available.',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () => context.go('/'),
                      child: const Text('Back to Home'),
                    ),
                  ],
                ),
              ),
            );
          }

          // Sort cards: urgent first, then important, then routine
          // Within each urgency, sort by whenToDoIt
          final sortedCards = List<GuidanceCard>.from(plan.cards);
          sortedCards.sort((a, b) {
            final urgencyOrder = {Urgency.urgent: 0, Urgency.important: 1, Urgency.routine: 2};
            final urgencyA = urgencyOrder[a.urgency] ?? 999;
            final urgencyB = urgencyOrder[b.urgency] ?? 999;
            if (urgencyA != urgencyB) return urgencyA.compareTo(urgencyB);
            // Then sort by whenToDoIt (compare enum indices)
            return a.whenToDoIt.index.compareTo(b.whenToDoIt.index);
          });

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Destination summary
                if (trip != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.blue),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Travel to ${trip.destinationCountry}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 24),

                // Guidance cards
                const Text(
                  'Prevention & Preparedness',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ...sortedCards.map(
                  (card) => _CardWidget(card: card),
                ),
                const SizedBox(height: 32),

                // Checklist
                if (plan.checklist.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Preparation Checklist',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      ...plan.checklist.map(
                        (item) => _ChecklistItemWidget(item: item),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),

                // Exposure wizard CTA
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => context.go('/trip/traveler/plan/exposure'),
                    icon: const Icon(Icons.warning),
                    label: const Text('Report Animal Bite or Exposure'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
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

/// Guidance card display widget.
class _CardWidget extends StatefulWidget {
  final GuidanceCard card;

  const _CardWidget({required this.card});

  @override
  State<_CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<_CardWidget> {
  bool _expandedSources = false;

  @override
  Widget build(BuildContext context) {
    final urgencyColor = _getUrgencyColor(widget.card.urgency);
    final urgencyLabel = widget.card.urgency.name.toUpperCase();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: urgencyColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  urgencyLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.card.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.card.summary,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'Why: ${widget.card.whyThisMatters}',
              style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
            ),
          ),
          const SizedBox(height: 12),
          if (widget.card.steps.isNotEmpty) ...[
            const Text(
              'What to do:',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            ...widget.card.steps.map(
              (step) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(fontSize: 16)),
                    Expanded(
                      child: Text(
                        step.label,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (widget.card.sourceRefs.isNotEmpty) ...[
            const SizedBox(height: 12),
            InkWell(
              onTap: () => setState(() => _expandedSources = !_expandedSources),
              child: Row(
                children: [
                  Icon(
                    _expandedSources ? Icons.expand_less : Icons.expand_more,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Sources',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            if (_expandedSources)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.card.sourceRefs
                      .map(
                        (sourceId) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            '• $sourceId',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
          ],
        ],
      ),
    );
  }

  Color _getUrgencyColor(Urgency urgency) {
    switch (urgency) {
      case Urgency.urgent:
        return Colors.red;
      case Urgency.important:
        return Colors.orange;
      case Urgency.routine:
        return Colors.green;
    }
  }
}

/// Checklist item widget.
class _ChecklistItemWidget extends StatefulWidget {
  final dynamic item; // ChecklistItem

  const _ChecklistItemWidget({required this.item});

  @override
  State<_ChecklistItemWidget> createState() => _ChecklistItemWidgetState();
}

class _ChecklistItemWidgetState extends State<_ChecklistItemWidget> {
  late bool _isDone;

  @override
  void initState() {
    super.initState();
    _isDone = false;
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(widget.item.label as String),
      value: _isDone,
      onChanged: (val) => setState(() => _isDone = val ?? false),
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
