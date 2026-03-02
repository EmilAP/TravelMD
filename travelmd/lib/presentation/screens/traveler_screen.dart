import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:travelmd/domain/models/traveler_profile.dart';
import 'package:travelmd/presentation/providers/app_providers.dart';

/// Traveler screen: collect demographics and health info.
class TravelerScreen extends ConsumerStatefulWidget {
  const TravelerScreen({super.key});

  @override
  ConsumerState<TravelerScreen> createState() => _TravelerScreenState();
}

class _TravelerScreenState extends ConsumerState<TravelerScreen> {
  late TextEditingController _nickController;
  late TextEditingController _ageController;
  bool _isPregnant = false;
  bool _isImmunocompromised = false;
  bool _isVFR = false;
  String _purpose = 'tourism';

  @override
  void initState() {
    super.initState();
    _nickController = TextEditingController();
    _ageController = TextEditingController();
  }

  @override
  void dispose() {
    _nickController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _saveTraveler() {
    final nick = _nickController.text.trim().isEmpty ? 'Traveler' : _nickController.text.trim();
    final ageStr = _ageController.text.trim();

    if (ageStr.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your age')),
      );
      return;
    }

    final age = int.tryParse(ageStr);
    if (age == null || age < 0 || age > 120) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid age')),
      );
      return;
    }

    final traveler = TravelerProfile(
      nickname: nick,
      ageYears: age,
      isPregnant: _isPregnant,
      isImmunocompromised: _isImmunocompromised,
      isVFR: _isVFR,
      purpose: _purpose,
    );

    ref.read(travelerProvider.notifier).setTraveler(traveler);
    context.go('/trip/traveler/plan');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About You'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nickController,
              decoration: InputDecoration(
                labelText: 'Nickname (optional)',
                hintText: 'How should we call you?',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Age',
                hintText: 'Your age in years',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Health Status',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            CheckboxListTile(
              title: const Text('Pregnant'),
              value: _isPregnant,
              onChanged: (val) => setState(() => _isPregnant = val ?? false),
            ),
            CheckboxListTile(
              title: const Text('Immunocompromised'),
              value: _isImmunocompromised,
              onChanged: (val) => setState(() => _isImmunocompromised = val ?? false),
            ),
            CheckboxListTile(
              title: const Text('VFR (Visiting Friends/Relatives)'),
              value: _isVFR,
              onChanged: (val) => setState(() => _isVFR = val ?? false),
            ),
            const SizedBox(height: 24),
            const Text(
              'Travel Purpose',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: _purpose,
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: 'tourism', child: Text('Tourism')),
                DropdownMenuItem(value: 'business', child: Text('Business')),
                DropdownMenuItem(value: 'volunteer', child: Text('Volunteer/NGO')),
                DropdownMenuItem(value: 'medical', child: Text('Medical Work')),
                DropdownMenuItem(value: 'research', child: Text('Research')),
                DropdownMenuItem(value: 'other', child: Text('Other')),
              ],
              onChanged: (val) => setState(() => _purpose = val ?? 'tourism'),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveTraveler,
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Generate My Plan'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
