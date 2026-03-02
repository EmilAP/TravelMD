class TravelerProfile {
  final int ageYears;
  final bool pregnant;
  final bool immunocompromised;
  final bool vfr;
  final String purpose;

  TravelerProfile({
    required this.ageYears,
    this.pregnant = false,
    this.immunocompromised = false,
    this.vfr = false,
    this.purpose = '',
  });
}
