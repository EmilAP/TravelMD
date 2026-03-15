import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:travelmd/domain/models/traveler_profile.dart';
import 'package:travelmd/presentation/providers/app_providers.dart';
import 'package:travelmd/presentation/theme/app_theme.dart';
import 'package:travelmd/presentation/widgets/app_ui.dart';

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

  void _saveTraveler() async {
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

    // Save traveler to database
    try {
      final storage = await ref.read(storageRepositoryProvider.future);
      final travelerId = await storage.saveTraveler(traveler);

      // Store Isar ID for plan selection persistence
      ref.read(travelerIsarIdProvider.notifier).setId(travelerId);

      // Invalidate saved travelers cache
      ref.invalidate(savedTravelersProvider);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving traveler: $e')),
      );
      return;
    }

    ref.read(travelerProvider.notifier).setTraveler(traveler);
    context.go('/trip/traveler/plan');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Traveler Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              title: 'Step 2 of 2: Risk Profile',
              subtitle: 'Build traveler context to tailor preparedness recommendations.',
            ),
            const SizedBox(height: AppSpacing.md),
            SurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Demographics',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Basic profile information used for age-related guidance.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _nickController,
                    decoration: const InputDecoration(
                      labelText: 'Nickname (optional)',
                      hintText: 'How should we address this traveler?',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Age',
                      hintText: 'Age in years',
                    ),
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
                    'Trip Purpose & Context',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Purpose helps shape how recommendations are interpreted in context.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _purpose,
                    decoration: const InputDecoration(labelText: 'Primary purpose'),
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
                  const SizedBox(height: 10),
                  SwitchListTile(
                    value: _isVFR,
                    onChanged: (val) => setState(() => _isVFR = val),
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Visiting Friends/Relatives (VFR)'),
                    subtitle: const Text('Helps contextualize exposure and access-to-care assumptions.'),
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
                    'Clinical & Risk Modifiers',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'These factors influence how urgently to seek professional travel-medicine advice.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  CheckboxListTile(
                    title: const Text('Pregnant'),
                    subtitle: const Text('May influence vaccine and medication considerations.'),
                    value: _isPregnant,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) => setState(() => _isPregnant = val ?? false),
                  ),
                  CheckboxListTile(
                    title: const Text('Immunocompromised'),
                    subtitle: const Text('Important when planning preventive strategy and follow-up.'),
                    value: _isImmunocompromised,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) => setState(() => _isImmunocompromised = val ?? false),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveTraveler,
                icon: const Icon(Icons.insights),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 2),
                  child: Text('Generate Travel Health Plan'),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Center(
              child: Text(
                'Profile details stay on-device and are used only for plan generation.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
