import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/models/user_model.dart';
import 'package:iw_app/utils/common.dart';
import 'package:iw_app/utils/numbers.dart';

enum MemberRole {
  Member,
  Admin,
  CoOwner,
  Investor,
}

class OrganizationMember {
  String? id;
  String? occupation;
  MemberRole? role;
  double? impactRatio;
  bool? isMonthlyCompensated;
  double? monthlyCompensation;
  bool? isAutoContributing;
  double? hoursPerWeek;
  dynamic user;
  dynamic org;
  double? contributed;
  InvestorSettings? investorSettings;
  int? lamportsEarned;

  OrganizationMember({
    this.occupation,
    this.role,
    this.impactRatio = 1,
    this.isMonthlyCompensated = true,
    this.monthlyCompensation,
    this.isAutoContributing = false,
    this.hoursPerWeek = 40,
    this.user,
    this.org,
    this.contributed = 0,
    this.investorSettings,
    this.lamportsEarned,
  });

  OrganizationMember.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    occupation = json['occupation'];
    role = CommonUtils.stringToEnum(json['role'], MemberRole.values);
    impactRatio = intToDouble(json['impactRatio']);
    isMonthlyCompensated = json['isMonthlyCompensated'];
    monthlyCompensation = intToDouble(json['monthlyCompensation']);
    isAutoContributing = json['isAutoContributing'];
    hoursPerWeek = intToDouble(json['hoursPerWeek']);
    user = json['user'] is Map ? User.fromJson(json['user']) : json['user'];
    org = json['org'] is Map ? Organization.fromJson(json['org']) : json['org'];
    contributed = intToDouble(json['contributed']);
    lamportsEarned = json['lamportsEarned'];
    investorSettings = json['investorSettings'] is Map
        ? InvestorSettings.fromJson(json['investorSettings'])
        : json['investorSettings'];
  }

  @override
  String toString() {
    return '''
${super.toString()}
occupation: $occupation
impactRatio: $impactRatio
isMonthlyCompensated: $isMonthlyCompensated
monthlyCompensation: $monthlyCompensation
isAutoContributing: $isAutoContributing
hoursPerWeek: $hoursPerWeek
''';
  }

  Map<String, dynamic> toMap() {
    return {
      'occupation': occupation,
      'role': role?.name,
      'impactRatio': impactRatio,
      'isMonthlyCompensated': isMonthlyCompensated,
      'monthlyCompensation': monthlyCompensation,
      'isAutoContributing': isAutoContributing,
      'hoursPerWeek': hoursPerWeek,
      'user': user,
      'org': org,
      'investorSettings': investorSettings?.toJson(),
    };
  }
}

class MemberEquity {
  int? lamportsEarned;
  double? equity;

  MemberEquity({
    this.lamportsEarned,
    this.equity,
  });

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

class InvestorSettings {
  double? investmentAmount;
  double? equityAllocation;

  InvestorSettings({
    this.investmentAmount,
    this.equityAllocation,
  });

  InvestorSettings.fromJson(Map<String, dynamic> json) {
    investmentAmount = intToDouble(json['investmentAmount']);
    equityAllocation = intToDouble(json['equityAllocation']);
  }

  Map<String, dynamic> toJson() {
    return {
      'investmentAmount': investmentAmount,
      'equityAllocation': equityAllocation,
    };
  }
}
