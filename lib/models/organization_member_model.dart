import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/models/user_model.dart';
import 'package:iw_app/utils/common.dart';

enum MemberRole {
  Member,
  Admin,
  CoOwner,
}

class OrganizationMember {
  String? id;
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
    this.isMonthlyCompensated = true,
    this.monthlyCompensation,
    this.autoContribution = false,
    this.user,
    this.org,
    this.contributed = 0,
  });

  OrganizationMember.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
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

  Map<String, dynamic> toMap() {
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

class MemberEquity {
  int? lamportsEarned;
  double? equity;

  MemberEquity.fromJson(Map<String, dynamic> json) {
    lamportsEarned = json['lamportsEarned'];
    equity = json['equity'];
  }
}

class OrganizationMemberWithEquity {
  OrganizationMember? member;
  MemberEquity? equity;
  Future<MemberEquity>? futureEquity;

  OrganizationMemberWithEquity({
    this.member,
    this.equity,
    this.futureEquity,
  });
}

class OrganizationMemberWithOtherMembers extends OrganizationMemberWithEquity {
  List<OrganizationMember>? otherMembers;
  Future<List<OrganizationMember>>? futureOtherMembers;

  OrganizationMemberWithOtherMembers({
    OrganizationMember? member,
    this.futureOtherMembers,
    this.otherMembers,
    MemberEquity? equity,
    Future<MemberEquity>? futureEquity,
  }) : super(
          member: member,
          equity: equity,
          futureEquity: futureEquity,
        );
}
