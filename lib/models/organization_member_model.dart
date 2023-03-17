enum MemberRole {
  Member,
  Admin,
  CoOwner,
}

class OrganizationMember {
  String? occupation;
  MemberRole? role;
  double impactRatio;
  bool isMonthlyCompensated;
  double? monthlyCompensation;
  bool autoContribution;
  String? userId;
  String? orgId;

  OrganizationMember({
    this.occupation,
    this.role,
    this.impactRatio = 1,
    this.isMonthlyCompensated = false,
    this.monthlyCompensation,
    this.autoContribution = true,
    this.userId,
    this.orgId,
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

  Map<String, dynamic> toJson() {
    return {
      'occupation': occupation,
      'role': role?.name,
      'impactRatio': impactRatio,
      'isMonthlyCompensated': isMonthlyCompensated,
      'monthlyCompensation': monthlyCompensation,
      'autoContribution': autoContribution,
      'userId': userId,
      'orgId': orgId,
    };
  }
}
