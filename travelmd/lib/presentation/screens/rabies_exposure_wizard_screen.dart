import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:travelmd/domain/enums/animal_type.dart';
import 'package:travelmd/domain/enums/body_location.dart';
import 'package:travelmd/domain/enums/exposure_contact_type.dart';
import 'package:travelmd/domain/enums/yes_no_unknown.dart';
import 'package:travelmd/domain/models/exposure_intake.dart';
import 'package:travelmd/domain/rules/rabies_plan_builder.dart';
import 'package:travelmd/presentation/providers/app_providers.dart';
import 'package:travelmd/presentation/theme/app_theme.dart';
import 'package:travelmd/presentation/widgets/app_ui.dart';

/// Guided rabies exposure triage flow with patch merge into current plan.
class RabiesExposureWizardScreen extends ConsumerStatefulWidget {
  const RabiesExposureWizardScreen({super.key});

  @override
  ConsumerState<RabiesExposureWizardScreen> createState() =>
      _RabiesExposureWizardScreenState();
}

class _RabiesExposureWizardScreenState
    extends ConsumerState<RabiesExposureWizardScreen> {
  int _currentStep = 0;
  AnimalType? _selectedAnimal;
  ExposureContactType? _selectedContact;
  bool _isSkinBroken = false;
  bool _isMucousMembrane = false;
  bool _isBleeding = false;
  YesNoUnknown _animalAvailable = YesNoUnknown.unknown;
  String? _timeSinceExposure;
  BodyLocation _bodyLocation = BodyLocation.arm;

  static const int _stepCount = 5;

  Future<void> _submitExposure() async {
    if (_selectedAnimal == null || _selectedContact == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete required fields.')),
      );
      return;
    }

    final trip = ref.read(tripProvider);
    final traveler = ref.read(travelerProvider);
    final contentRepo = ref.read(contentRepositoryProvider);

    if (trip == null || traveler == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Trip and traveler info required first.')),
      );
      return;
    }

    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Generating exposure response...'),
          ],
        ),
      ),
    );

    try {
      final exposure = ExposureIntake(
        animalType: _selectedAnimal!,
        contactType: _selectedContact!,
        countryIso3: trip.destinationCountry,
        skinBroken: _isSkinBroken,
        mucousMembrane: _isMucousMembrane,
        bleeding: _isBleeding,
        animalAvailableForObservationOrTesting: _animalAvailable,
        timeSinceExposureHours:
            _timeSinceExposure == null ? null : int.tryParse(_timeSinceExposure!),
        bodyLocation: _bodyLocation,
      );

      const builder = RabiesPlanBuilder();
      final patch = await builder.build(
        trip: trip,
        traveler: traveler,
        exposure: exposure,
        contentRepo: contentRepo,
      );

      final currentPlan = ref.read(planProvider);
      final cardMap = {
        ...{for (final c in currentPlan.cards) c.id: c},
        ...{for (final c in patch.cardsToAdd) c.id: c},
      };
      final checklistMap = {
        ...{for (final i in currentPlan.checklist) i.id: i},
        ...{for (final i in patch.checklistToAdd) i.id: i},
      };

      final updatedPlan = currentPlan.copyWith(
        cards: cardMap.values.toList(),
        checklist: checklistMap.values.toList(),
        timeline: [...currentPlan.timeline, ...patch.timelineToAdd],
      );

      ref.read(planProvider.notifier).updatePlan(updatedPlan);

      final tripId = ref.read(tripIsarIdProvider);
      final travelerId = ref.read(travelerIsarIdProvider);
      if (tripId != null && travelerId != null) {
        try {
          final storage = await ref.read(storageRepositoryProvider.future);
          final selectedCardIds = updatedPlan.cards.map((c) => c.id).toList();
          await storage.savePlanSelection(
            tripId: tripId,
            travelerId: travelerId,
            selectedCardIds: selectedCardIds,
          );
        } catch (e) {
          debugPrint('Error persisting exposure plan selection: $e');
        }
      }

      if (!mounted) return;
      Navigator.of(context).pop();
      context.go('/trip/traveler/plan');
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  bool _canContinueForStep() {
    if (_currentStep == 0) return _selectedAnimal != null;
    if (_currentStep == 1) return _selectedContact != null;
    return true;
  }

  void _onContinue() {
    if (!_canContinueForStep()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete the required selection to continue.')),
      );
      return;
    }

    if (_currentStep == _stepCount - 1) {
      _submitExposure();
      return;
    }

    setState(() => _currentStep++);
  }

  void _onBack() {
    if (_currentStep == 0) {
      Navigator.of(context).maybePop();
      return;
    }
    setState(() => _currentStep--);
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_currentStep + 1) / _stepCount;

    return Scaffold(
      appBar: AppBar(title: const Text('Exposure Triage')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Step ${_currentStep + 1} of $_stepCount',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _stepTitle(_currentStep),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _stepSubtitle(_currentStep),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: const Color(0xFFE2E8E9),
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.brand),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 240),
                child: SurfaceCard(
                  key: ValueKey(_currentStep),
                  child: _buildStepContent(context),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _onBack,
                    icon: const Icon(Icons.arrow_back),
                    label: Text(_currentStep == 0 ? 'Cancel' : 'Back'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _onContinue,
                    icon: Icon(_currentStep == _stepCount - 1
                        ? Icons.check_circle_outline
                        : Icons.arrow_forward),
                    label: Text(_currentStep == _stepCount - 1
                        ? 'Generate Guidance'
                        : 'Continue'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent(BuildContext context) {
    switch (_currentStep) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: AnimalType.values.map((animal) {
            return RadioListTile<AnimalType>(
              contentPadding: EdgeInsets.zero,
              title: Text(_animalLabel(animal)),
              value: animal,
              groupValue: _selectedAnimal,
              onChanged: (val) => setState(() => _selectedAnimal = val),
            );
          }).toList(),
        );
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: ExposureContactType.values.map((contact) {
            return RadioListTile<ExposureContactType>(
              contentPadding: EdgeInsets.zero,
              title: Text(_contactLabel(contact)),
              value: contact,
              groupValue: _selectedContact,
              onChanged: (val) => setState(() => _selectedContact = val),
            );
          }).toList(),
        );
      case 2:
        return Column(
          children: [
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Skin was broken'),
              value: _isSkinBroken,
              onChanged: (val) => setState(() => _isSkinBroken = val ?? false),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Contact with mucous membrane'),
              value: _isMucousMembrane,
              onChanged: (val) => setState(() => _isMucousMembrane = val ?? false),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Currently bleeding'),
              value: _isBleeding,
              onChanged: (val) => setState(() => _isBleeding = val ?? false),
            ),
          ],
        );
      case 3:
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Do you have access to the animal?'),
              const SizedBox(height: 8),
              ...YesNoUnknown.values.map((opt) {
                return RadioListTile<YesNoUnknown>(
                  contentPadding: EdgeInsets.zero,
                  title: Text(opt.name[0].toUpperCase() + opt.name.substring(1)),
                  value: opt,
                  groupValue: _animalAvailable,
                  onChanged: (val) =>
                      setState(() => _animalAvailable = val ?? YesNoUnknown.unknown),
                );
              }),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Hours since exposure (optional)',
                  hintText: 'e.g., 2',
                ),
                keyboardType: TextInputType.number,
                onChanged: (val) => _timeSinceExposure = val,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<BodyLocation>(
                initialValue: _bodyLocation,
                decoration: const InputDecoration(labelText: 'Body location'),
                items: BodyLocation.values.map((loc) {
                  return DropdownMenuItem<BodyLocation>(
                    value: loc,
                    child: Text(_bodyLocationLabel(loc)),
                  );
                }).toList(),
                onChanged: (val) =>
                    setState(() => _bodyLocation = val ?? BodyLocation.arm),
              ),
            ],
          ),
        );
      case 4:
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Review before generating recommendations',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            LabelValueRow(
              label: 'Animal',
              value: _selectedAnimal == null ? 'Not selected' : _animalLabel(_selectedAnimal!),
            ),
            LabelValueRow(
              label: 'Contact',
              value: _selectedContact == null
                  ? 'Not selected'
                  : _contactLabel(_selectedContact!),
            ),
            LabelValueRow(label: 'Skin broken', value: _boolLabel(_isSkinBroken)),
            LabelValueRow(
                label: 'Mucous membrane', value: _boolLabel(_isMucousMembrane)),
            LabelValueRow(label: 'Bleeding', value: _boolLabel(_isBleeding)),
            LabelValueRow(
              label: 'Animal available',
              value: _animalAvailable.name,
            ),
            LabelValueRow(
              label: 'Hours since exposure',
              value: (_timeSinceExposure == null || _timeSinceExposure!.trim().isEmpty)
                  ? 'Not provided'
                  : _timeSinceExposure!,
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.brandSoft,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'TravelMD will merge triage recommendations into your existing travel plan dashboard.',
              ),
            ),
          ],
        );
    }
  }

  String _stepTitle(int step) {
    switch (step) {
      case 0:
        return 'Animal Type';
      case 1:
        return 'Contact Type';
      case 2:
        return 'Wound Characteristics';
      case 3:
        return 'Additional Context';
      case 4:
        return 'Review & Generate';
      default:
        return '';
    }
  }

  String _stepSubtitle(int step) {
    switch (step) {
      case 0:
        return 'Select the animal involved in this exposure event.';
      case 1:
        return 'Describe how contact occurred to estimate exposure risk level.';
      case 2:
        return 'Capture immediate tissue/mucosal risk indicators.';
      case 3:
        return 'Add practical details that may affect urgency and follow-up.';
      case 4:
        return 'Confirm details and generate response recommendations.';
      default:
        return '';
    }
  }

  String _boolLabel(bool value) => value ? 'Yes' : 'No';

  String _animalLabel(AnimalType animal) {
    switch (animal) {
      case AnimalType.dog:
        return 'Dog';
      case AnimalType.cat:
        return 'Cat';
      case AnimalType.bat:
        return 'Bat';
      case AnimalType.monkey:
        return 'Monkey/Primate';
      case AnimalType.other:
        return 'Other animal';
    }
  }

  String _contactLabel(ExposureContactType contact) {
    switch (contact) {
      case ExposureContactType.bite:
        return 'Bite';
      case ExposureContactType.scratch:
        return 'Scratch';
      case ExposureContactType.salivaOnMucosa:
        return 'Saliva on mouth/eyes/nose';
      case ExposureContactType.salivaOnBrokenSkin:
        return 'Saliva on broken skin';
      case ExposureContactType.lickOnIntactSkin:
        return 'Lick on intact skin';
      case ExposureContactType.other:
        return 'Other contact';
    }
  }

  String _bodyLocationLabel(BodyLocation location) {
    switch (location) {
      case BodyLocation.face:
        return 'Face/Head';
      case BodyLocation.hand:
        return 'Hand/Finger';
      case BodyLocation.arm:
        return 'Arm';
      case BodyLocation.leg:
        return 'Leg';
      case BodyLocation.trunk:
        return 'Trunk/Torso';
      case BodyLocation.other:
        return 'Other/Multiple';
    }
  }
}
