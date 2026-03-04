import 'package:isar/isar.dart';

part 'traveler_entity.g.dart';

@collection
class TravelerEntity {
  Id id = Isar.autoIncrement;

  String? nickname;
  late int ageYears;
  late bool isPregnant;
  late bool isImmunocompromised;
  late bool isVFR;
  late String purpose; // 'tourism', 'business', 'volunteer', etc.
  late DateTime createdAt;
}
