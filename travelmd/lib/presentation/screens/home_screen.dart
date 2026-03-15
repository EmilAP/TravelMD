import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:travelmd/presentation/providers/app_providers.dart';
import 'package:travelmd/presentation/screens/content_load_error_screen.dart';
import 'package:travelmd/presentation/theme/app_theme.dart';
import 'package:travelmd/presentation/widgets/app_ui.dart';

/// Home screen: entry point with two primary CTAs.
/// 1. Plan a trip (prevention-first flow)
/// 2. Animal bite / rabies exposure (exposure-response flow)
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedTripsAsync = ref.watch(savedTripsProvider);
    final contentRepo = ref.read(contentRepositoryProvider);

    return FutureBuilder<void>(
      future: contentRepo.loadAll(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ContentLoadErrorScreen(error: snapshot.error!);
        }
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('TravelMD'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0D5E63), Color(0xFF2C8C7A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.brand.withOpacity(0.22),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.health_and_safety, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'TRAVEL HEALTH INTELLIGENCE',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Plan ahead, travel safer, and know what to do if exposure happens.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'TravelMD combines pre-travel preparedness with emergency rabies exposure guidance for decisions under uncertainty.',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.92),
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                SurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionHeader(
                        title: 'Start Here',
                        subtitle: 'Choose a planning or triage workflow',
                      ),
                      const SizedBox(height: AppSpacing.md),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => context.go('/trip'),
                          icon: const Icon(Icons.flight_takeoff),
                          label: const Text('Plan a Trip'),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => context.go('/trip/traveler/plan/exposure'),
                          icon: const Icon(Icons.warning_amber_rounded),
                          label: const Text('Animal Exposure'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                SectionHeader(
                  title: 'Recent Trips',
                  subtitle: 'Continue saved plan contexts',
                  trailing: Icon(
                    Icons.history,
                    color: Colors.teal.shade700,
                    size: 20,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                savedTripsAsync.when(
                  loading: () => const Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (err, stack) => SurfaceCard(
                    child: Text('Error loading trips: $err'),
                  ),
                  data: (trips) {
                    if (trips.isEmpty) {
                      return EmptyStateCard(
                        icon: Icons.luggage_outlined,
                        title: 'No saved trip contexts yet',
                        message:
                            'Start your first travel health plan and your recent trips will appear here for quick continuation.',
                        action: ElevatedButton.icon(
                          onPressed: () => context.go('/trip'),
                          icon: const Icon(Icons.add),
                          label: const Text('Create First Plan'),
                        ),
                      );
                    }

                    return Column(
                      children: trips.map((trip) {
                        final dateLabel =
                            '${trip.departDate.month}/${trip.departDate.day} - ${trip.returnDate.month}/${trip.returnDate.day}';
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: SurfaceCard(
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: AppColors.brandSoft,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.public, color: AppColors.brand),
                              ),
                              title: Text(
                                trip.destinationCountry,
                                style: const TextStyle(fontWeight: FontWeight.w700),
                              ),
                              subtitle: Text(
                                dateLabel,
                                style: const TextStyle(height: 1.4),
                              ),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {
                                ref.read(tripProvider.notifier).setTrip(trip);
                                context.go('/trip/traveler/plan');
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                Center(
                  child: Text(
                    'Evidence-informed guidance. Use with clinical judgment and local protocols.',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
