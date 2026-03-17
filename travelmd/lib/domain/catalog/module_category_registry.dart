import 'package:travelmd/domain/catalog/module_category.dart';
import 'package:travelmd/domain/modules/module_stream.dart';

const ModuleCategory prepareBeforeYouGoCategory = ModuleCategory(
  id: 'prepare_before_you_go',
  title: 'Prepare before you go',
  shortDescription: 'Start with practical travel health planning before departure.',
  iconKey: 'luggage',
  moduleIds: ['pretravel_readiness'],
  primaryStream: ModuleStream.prevention,
);

const ModuleCategory avoidAnimalBitesCategory = ModuleCategory(
  id: 'avoid_animal_bites',
  title: 'Avoid animal bites',
  shortDescription: 'Lower your risk from dogs, bats, monkeys, and other animal exposures.',
  iconKey: 'pets',
  moduleIds: ['rabies'],
  primaryStream: ModuleStream.prevention,
);

const ModuleCategory avoidBugBitesCategory = ModuleCategory(
  id: 'avoid_bug_bites',
  title: 'Avoid mosquito and bug bites',
  shortDescription: 'Reduce bites that can spread malaria and other travel-related infections.',
  iconKey: 'bug_report',
  moduleIds: ['malaria'],
  primaryStream: ModuleStream.prevention,
);

const ModuleCategory eatAndDrinkSaferCategory = ModuleCategory(
  id: 'eat_and_drink_safer',
  title: 'Eat and drink safer',
  shortDescription: 'Choose lower-risk food and water habits while traveling.',
  iconKey: 'restaurant',
  moduleIds: ['food_water_safety'],
  primaryStream: ModuleStream.prevention,
);

const ModuleCategory avoidInjuriesCategory = ModuleCategory(
  id: 'avoid_injuries',
  title: 'Avoid injuries',
  shortDescription: 'Build safer habits for transport, activities, and daily movement.',
  iconKey: 'health_and_safety',
  moduleIds: ['travel_injury_prevention'],
  primaryStream: ModuleStream.prevention,
);

const ModuleCategory ifSomethingHappensCategory = ModuleCategory(
  id: 'if_something_happens',
  title: 'If something happens',
  shortDescription: 'Get urgent next-step help after an exposure or incident.',
  iconKey: 'emergency',
  moduleIds: ['rabies'],
  primaryStream: ModuleStream.incidentResponse,
);

class ModuleCategoryRegistry {
  final List<ModuleCategory> categories;

  const ModuleCategoryRegistry({required this.categories});

  static const ModuleCategoryRegistry defaultRegistry = ModuleCategoryRegistry(
    categories: [
      prepareBeforeYouGoCategory,
      avoidAnimalBitesCategory,
      avoidBugBitesCategory,
      eatAndDrinkSaferCategory,
      avoidInjuriesCategory,
      ifSomethingHappensCategory,
    ],
  );

  ModuleCategory? byId(String id) {
    for (final category in categories) {
      if (category.id == id) {
        return category;
      }
    }
    return null;
  }
}
