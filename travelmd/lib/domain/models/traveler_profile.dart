class TravelerProfile {
  final String? nickname;
  final int ageYears;
  final bool isPregnant;
  final bool isImmunocompromised;
  final bool isVFR;
  final String purpose;

  TravelerProfile({
    this.nickname,
    required this.ageYears,
    this.isPregnant = false,
    this.isImmunocompromised = false,
    this.isVFR = false,
    this.purpose = 'tourism',
  });

  /// For backward compatibility
  bool get pregnant => isPregnant;
  bool get immunocompromised => isImmunocompromised;
  bool get vfr => isVFR;
}
