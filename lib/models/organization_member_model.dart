import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/models/user_model.dart';
import 'package:iw_app/utils/common.dart';

enum MemberRole {
  Member,
  Admin,
  CoOwner,
}

class OrganizationMember {
  String? occupation;
  MemberRole? role;
  double? impactRatio;
  bool? isMonthlyCompensated;
  double? monthlyCompensation;
  bool? autoContribution;
  dynamic user;
  dynamic org;
  double? contributed;

  OrganizationMember({
    this.occupation,
    this.role,
    this.impactRatio = 1,
    this.isMonthlyCompensated = false,
    this.monthlyCompensation,
    this.autoContribution = true,
    this.user,
    this.org,
    this.contributed = 0,
  });

  OrganizationMember.fromJson(Map<String, dynamic> json) {
    occupation = json['occupation'];
    role = CommonUtils.stringToEnum(json['role'], MemberRole.values);
    impactRatio = json['impactRatio'];
    isMonthlyCompensated = json['isMonthlyCompensated'];
    monthlyCompensation = json['monthlyCompensation'];
    autoContribution = json['autoContribution'];
    user = json['user'] is Map ? User.fromJson(json['user']) : json['user'];
    org = json['org'] is Map ? Organization.fromJson(json['org']) : json['org'];
    contributed = json['contributed'];
  }

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
      'user': user,
      'org': org,
    };
  }
}

class OrganizationMemberWithOtherMembers {
  OrganizationMember? member;
  List<OrganizationMember>? otherMembers;
  Future<List<OrganizationMember>>? futureOtherMembers;

  OrganizationMemberWithOtherMembers({
    this.member,
    this.futureOtherMembers,
    this.otherMembers,
  });
}
