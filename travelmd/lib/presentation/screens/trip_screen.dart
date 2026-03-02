import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:travelmd/domain/models/trip.dart';
import 'package:travelmd/presentation/providers/app_providers.dart';

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

  void _saveTrip() {
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

    ref.read(tripProvider.notifier).setTrip(trip);
    context.go('/trip/traveler');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plan Your Trip'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Where are you traveling?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _destController,
              decoration: InputDecoration(
                labelText: 'Destination iso3 (e.g., IND, ZAF)',
                hintText: 'Enter 3-letter ISO country code',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.characters,
            ),
            const SizedBox(height: 24),
            const Text(
              'Transit countries (optional)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _transitController,
              decoration: InputDecoration(
                labelText: 'Transit countries (comma-separated)',
                hintText: 'e.g., AUT, CHE',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.characters,
            ),
            const SizedBox(height: 24),
            const Text(
              'When are you traveling? (optional)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _selectDate(context, true),
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      _departDate == null
                          ? 'Depart Date'
                          : '${_departDate!.month}/${_departDate!.day}/${_departDate!.year}',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _selectDate(context, false),
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      _returnDate == null
                          ? 'Return Date'
                          : '${_returnDate!.month}/${_returnDate!.day}/${_returnDate!.year}',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveTrip,
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Continue to Traveler Info'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
