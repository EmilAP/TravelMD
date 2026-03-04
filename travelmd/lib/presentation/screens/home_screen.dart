import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:travelmd/presentation/providers/app_providers.dart';
import 'package:travelmd/presentation/screens/content_load_error_screen.dart';

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
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main CTAs
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Stay Safe While Traveling',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () => context.go('/trip'),
                    icon: const Icon(Icons.map),
                    label: const Text('Plan a New Trip'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () => context.go('/trip/traveler/plan/exposure'),
                    icon: const Icon(Icons.warning),
                    label: const Text('Animal Bite or Exposure?'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),

            // Saved Trips Section
            savedTripsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Text('Error loading trips: $err'),
              data: (trips) {
                if (trips.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Continue Your Plans',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...trips.map((trip) {
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.location_on),
                          title: Text(trip.destinationCountry),
                          subtitle: Text(
                            '${trip.departDate.month}/${trip.departDate.day} - ${trip.returnDate.month}/${trip.returnDate.day}',
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            // Load trip and go to plan
                            ref.read(tripProvider.notifier).setTrip(trip);
                            context.go('/trip/traveler/plan');
                          },
                        ),
                      );
                    }).toList(),
                  ],
                );
              },
            ),

            const SizedBox(height: 48),
            Center(
              child: const Text(
                'Prevention first. Millions of deaths prevented with timely action.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
