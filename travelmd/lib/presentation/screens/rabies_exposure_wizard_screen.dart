import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:travelmd/domain/models/exposure_intake.dart';
import 'package:travelmd/domain/enums/animal_type.dart';
import 'package:travelmd/domain/enums/exposure_contact_type.dart';
import 'package:travelmd/domain/enums/yes_no_unknown.dart';
import 'package:travelmd/domain/enums/body_location.dart';
import 'package:travelmd/domain/rules/rabies_plan_builder.dart';
import 'package:travelmd/presentation/providers/app_providers.dart';

/// Rabies exposure wizard: collect exposure details and generate response plan.
/// Guides users through a simple questionnaire and generates exposure-response cards.
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

  void _submitExposure() async {
    if (_selectedAnimal == null || _selectedContact == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all required fields')),
      );
      return;
    }

    final trip = ref.read(tripProvider);
    final traveler = ref.read(travelerProvider);
    final contentRepo = ref.read(contentRepositoryProvider);

    if (trip == null || traveler == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Trip and traveler info required')),
      );
      return;
    }

    // Show loading
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
        timeSinceExposureHours: _timeSinceExposure == null
            ? null
            : int.tryParse(_timeSinceExposure!),
        bodyLocation: _bodyLocation,
      );

      // Build exposure patch
      const builder = RabiesPlanBuilder();
      final patch = await builder.build(
        trip: trip,
        traveler: traveler,
        exposure: exposure,
        contentRepo: contentRepo,
      );

      // Get current plan and merge
      final currentPlan = ref.read(planProvider);
      final cardMap = {...{for (final c in currentPlan.cards) c.id: c}, ...{for (final c in patch.cardsToAdd) c.id: c}};
      final checklistMap = {...{for (final i in currentPlan.checklist) i.id: i}, ...{for (final i in patch.checklistToAdd) i.id: i}};

      final updatedPlan = currentPlan.copyWith(
        cards: cardMap.values.toList(),
        checklist: checklistMap.values.toList(),
        timeline: [...currentPlan.timeline, ...patch.timelineToAdd],
      );

      ref.read(planProvider.notifier).updatePlan(updatedPlan);

      // Persist plan selection for this trip+traveler
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
      Navigator.of(context).pop(); // Close loading dialog
      context.go('/trip/traveler/plan');
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop(); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exposure Assessment'),
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 4) {
            setState(() => _currentStep++);
          } else {
            _submitExposure();
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep--);
          }
        },
        steps: [
          // Step 1: Animal Type
          Step(
            title: const Text('What animal were you exposed to?'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: AnimalType.values.map((animal) {
                return RadioListTile<AnimalType>(
                  title: Text(_animalLabel(animal)),
                  value: animal,
                  groupValue: _selectedAnimal,
                  onChanged: (val) => setState(() => _selectedAnimal = val),
                );
              }).toList(),
            ),
          ),
          // Step 2: Contact Type
          Step(
            title: const Text('How did the animal contact you?'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: ExposureContactType.values.map((contact) {
                return RadioListTile<ExposureContactType>(
                  title: Text(_contactLabel(contact)),
                  value: contact,
                  groupValue: _selectedContact,
                  onChanged: (val) => setState(() => _selectedContact = val),
                );
              }).toList(),
            ),
          ),
          // Step 3: Wound Details
          Step(
            title: const Text('Wound details'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CheckboxListTile(
                  title: const Text('Skin was broken'),
                  value: _isSkinBroken,
                  onChanged: (val) =>
                      setState(() => _isSkinBroken = val ?? false),
                ),
                CheckboxListTile(
                  title: const Text('Contact with mucous membrane'),
                  value: _isMucousMembrane,
                  onChanged: (val) =>
                      setState(() => _isMucousMembrane = val ?? false),
                ),
                CheckboxListTile(
                  title: const Text('Currently bleeding'),
                  value: _isBleeding,
                  onChanged: (val) => setState(() => _isBleeding = val ?? false),
                ),
              ],
            ),
          ),
          // Step 4: Additional Info
          Step(
            title: const Text('Additional information'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                const Text('Do you have access to the animal?'),
                ...YesNoUnknown.values.map((opt) {
                  return RadioListTile<YesNoUnknown>(
                    title: Text(opt.name[0].toUpperCase() + opt.name.substring(1)),
                    value: opt,
                    groupValue: _animalAvailable,
                    onChanged: (val) =>
                        setState(() => _animalAvailable = val ?? YesNoUnknown.unknown),
                  );
                }).toList(),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Hours since exposure (optional)',
                    hintText: 'e.g., 2',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (val) => _timeSinceExposure = val,
                ),
                const SizedBox(height: 16),
                const Text('Body location'),
                DropdownButton<BodyLocation>(
                  value: _bodyLocation,
                  isExpanded: true,
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
          ),
          // Step 5: Summary
          Step(
            title: const Text('Review & Submit'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'You reported:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text('Animal: ${_animalLabel(_selectedAnimal!)}'),
                Text('Contact: ${_contactLabel(_selectedContact!)}'),
                Text('Skin broken: $_isSkinBroken'),
                Text('Mucous membrane: $_isMucousMembrane'),
                const SizedBox(height: 16),
                const Text(
                  'This information will help generate personalized care recommendations.',
                  style: TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
        return 'Saliva on mouths/eyes/nose';
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
