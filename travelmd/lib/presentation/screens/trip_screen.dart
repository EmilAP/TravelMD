import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:travelmd/domain/models/trip.dart';
import 'package:travelmd/presentation/providers/app_providers.dart';
import 'package:travelmd/presentation/theme/app_theme.dart';
import 'package:travelmd/presentation/widgets/app_ui.dart';

/// Trip screen: collect destination(s) and travel dates.
class TripScreen extends ConsumerStatefulWidget {
  const TripScreen({super.key});

  @override
  ConsumerState<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends ConsumerState<TripScreen> {
  late TextEditingController _destController;
  late TextEditingController _transitController;
  DateTime? _departDate;
  DateTime? _returnDate;

  @override
  void initState() {
    super.initState();
    _destController = TextEditingController();
    _transitController = TextEditingController();
  }

  @override
  void dispose() {
    _destController.dispose();
    _transitController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isDeparture) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isDeparture) {
          _departDate = picked;
        } else {
          _returnDate = picked;
        }
      });
    }
  }

  void _saveTrip() async {
    final dest = _destController.text.trim().toUpperCase();
    if (dest.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a destination ISO3')),
      );
      return;
    }

    final transit = _transitController.text.trim().isEmpty
        ? <String>[]
        : _transitController.text.split(',').map((s) => s.trim().toUpperCase()).toList();

    final trip = Trip(
      originCountry: 'USA', // Hard-coded for MVP
      destinationCountry: dest,
      departDate: _departDate ?? DateTime.now(),
      returnDate: _returnDate ?? DateTime.now().add(const Duration(days: 7)),
      transitCountries: transit,
    );

    // Save trip to database
    try {
      final storage = await ref.read(storageRepositoryProvider.future);
      final tripId = await storage.saveTrip(trip);

      // Store Isar ID for plan selection persistence
      ref.read(tripIsarIdProvider.notifier).setId(tripId);

      // Invalidate saved trips cache
      ref.invalidate(savedTripsProvider);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving trip: $e')),
      );
      return;
    }

    ref.read(tripProvider.notifier).setTrip(trip);
    context.go('/trip/traveler');
  }

  @override
  Widget build(BuildContext context) {
    String dateText(DateTime? date, String fallback) {
      if (date == null) return fallback;
      return '${date.month}/${date.day}/${date.year}';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Context'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              title: 'Step 1 of 2: Trip Setup',
              subtitle: 'Define destination context used for risk and preparedness guidance.',
            ),
            const SizedBox(height: AppSpacing.md),
            const InfoChip(
              icon: Icons.info_outline,
              label: 'Use ISO3 country codes, for example IND, ZAF, USA.',
              color: AppColors.brand,
            ),
            const SizedBox(height: AppSpacing.md),
            SurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Primary Destination',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'This is used as the main destination for rabies endemicity and preparation logic.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _destController,
                    decoration: const InputDecoration(
                      labelText: 'Destination ISO3',
                      hintText: 'e.g., IND',
                    ),
                    textCapitalization: TextCapitalization.characters,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Transit Countries (Optional)',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Comma-separated ISO3 values if relevant to your route.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _transitController,
                    decoration: const InputDecoration(
                      labelText: 'Transit countries',
                      hintText: 'e.g., AUT, CHE',
                    ),
                    textCapitalization: TextCapitalization.characters,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Travel Dates (Optional)',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Dates help sequence preparation actions and timeline context.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _selectDate(context, true),
                          icon: const Icon(Icons.calendar_today),
                          label: Text(dateText(_departDate, 'Depart Date')),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _selectDate(context, false),
                          icon: const Icon(Icons.event_available),
                          label: Text(dateText(_returnDate, 'Return Date')),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveTrip,
                icon: const Icon(Icons.arrow_forward),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 2),
                  child: Text('Continue to Traveler Profile'),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Center(
              child: Text(
                'Trip context is saved securely on-device.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
