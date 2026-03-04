import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:travelmd/data/storage/entities/trip_entity.dart';
import 'package:travelmd/data/storage/entities/traveler_entity.dart';
import 'package:travelmd/data/storage/entities/plan_selection_entity.dart';
import 'package:travelmd/data/storage/entities/checklist_state_entity.dart';

/// Service to manage Isar database instance.
class IsarService {
  static Isar? _instance;

  static Future<Isar> getInstance() async {
    if (_instance != null) return _instance!;

    final dir = await getApplicationDocumentsDirectory();
    _instance = await Isar.open(
      [
        TripEntitySchema,
        TravelerEntitySchema,
        PlanSelectionEntitySchema,
        ChecklistStateEntitySchema,
      ],
      directory: dir.path,
    );
    return _instance!;
  }

  static Future<void> close() async {
    await _instance?.close();
    _instance = null;
  }
}
