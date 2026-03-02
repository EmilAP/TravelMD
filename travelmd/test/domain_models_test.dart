import 'package:flutter_test/flutter_test.dart';
import 'package:travelmd/domain/enums/urgency.dart';
import 'package:travelmd/domain/enums/when_to_do.dart';
import 'package:travelmd/domain/enums/checklist_category.dart';
import 'package:travelmd/domain/enums/animal_type.dart';
import 'package:travelmd/domain/enums/exposure_contact_type.dart';
import 'package:travelmd/domain/enums/body_location.dart';
import 'package:travelmd/domain/enums/yes_no_unknown.dart';
import 'package:travelmd/domain/models/guidance_card.dart';
import 'package:travelmd/domain/models/checklist_item.dart';
import 'package:travelmd/domain/models/exposure_intake.dart';
import 'package:travelmd/domain/models/public_plan.dart';
import 'package:travelmd/domain/models/timeline_item.dart';

void main() {
  test('GuidanceCard construction with enums works', () {
    final card = GuidanceCard(
      id: 'c1',
      title: 'Test guidance',
      lastReviewed: '2026-03-02',
      urgency: Urgency.urgent,
      summary: 'Summary',
      whyThisMatters: 'Because',
      whenToDoIt: WhenToDo.duringTravel,
      steps: [ActionStep(label: 'Step1', details: 'Do it')],
      sourceRefs: ['SRC1'],
    );
    expect(card.urgency, Urgency.urgent);
    expect(card.steps.first.label, 'Step1');
    expect(card.lastReviewed.length, 10); // YYYY-MM-DD
  });

  test('ChecklistItem defaults and category', () {
    final item = ChecklistItem(id: 'i1', label: 'Bring passport');
    expect(item.category, ChecklistCategory.other);
    expect(item.isDone, false);
  });

  test('ExposureIntake enum defaults', () {
    final exp = ExposureIntake();
    expect(exp.animalType, AnimalType.other);
    expect(exp.contactType, ExposureContactType.other);
    expect(exp.animalAvailableForObservationOrTesting, YesNoUnknown.unknown);
  });

  test('PublicPlan holds lists correctly', () {
    final plan = PublicPlan(
      id: 'p1',
      tripId: 't1',
      travelerId: 'u1',
      title: 'Trip plan',
      summary: 'summary',
      cards: [GuidanceCard(id: 'c', title: 'T', lastReviewed: '2026-03-02')],
      checklist: [ChecklistItem(id: 'i', label: 'L')],
      timeline: [TimelineItem(date: DateTime.now(), description: 'desc')],
    );
    expect(plan.cards.length, 1);
    expect(plan.checklist.first.label, 'L');
  });
}
