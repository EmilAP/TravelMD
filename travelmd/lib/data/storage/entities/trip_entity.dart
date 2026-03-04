import 'package:isar/isar.dart';

part 'trip_entity.g.dart';

@collection
class TripEntity {
  Id id = Isar.autoIncrement;

  late String originCountry;
  late String destinationCountry;
  late DateTime departDate;
  late DateTime returnDate;
  late List<String> transitCountries;
  late DateTime createdAt;

  /// Convert back to domain Trip model.
  void updateTimestamp() {
    throw UnimplementedError('Use the travel module');
  }
}
