class Trip {
  final String originCountry;
  final String destinationCountry;
  final DateTime departDate;
  final DateTime returnDate;
  final List<String> transitCountries;

  Trip({
    required this.originCountry,
    required this.destinationCountry,
    required this.departDate,
    required this.returnDate,
    this.transitCountries = const [],
  });
}
