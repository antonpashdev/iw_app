class OrganizationMember {
  String? occupation;
  double impactRatio;
  bool isMonthlyCompensated;
  double? monthlyCompensation;
  bool autoContribution;

  OrganizationMember({
    this.occupation,
    this.impactRatio = 1,
    this.isMonthlyCompensated = false,
    this.monthlyCompensation,
    this.autoContribution = true,
  });

  @override
  String toString() {
    return '''
${super.toString()}
occupation: $occupation
impactRatio: $impactRatio
isMonthlyCompensated: $isMonthlyCompensated
monthlyCompensation: $monthlyCompensation
autoContribution: $autoContribution
''';
  }
}
