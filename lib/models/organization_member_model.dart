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

enum PeriodType {
  Days,
  Weeks,
  Months,
  Years,
}

enum EquityType { Immediately, DuringPeriod }

enum CompensationType { PerMonth, OneTime }

class Period {
  double? value;
  PeriodType? timeframe;

  Period({
    this.value,
    this.timeframe,
  });

  Period.fromJson(Map<String, dynamic> json) {
    value = intToDouble(json['value']);
    timeframe = CommonUtils.stringToEnum(json['timeframe'], PeriodType.values);
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'timeframe': timeframe?.name,
    };
  }
}

class Equity {
  double? amount;
  EquityType? type;
  Period? period;

  Equity({
    this.amount,
    this.type,
    this.period,
  });

  Equity.fromJson(Map<String, dynamic> json) {
    amount = intToDouble(json['amount']);
    type = CommonUtils.stringToEnum(json['type'], EquityType.values);
    period = json['period'] is Map
        ? Period.fromJson(json['period'])
        : json['period'];
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'type': type?.name,
      'period': period?.toJson(),
    };
  }
}

class Compensation {
  double? amount;
  CompensationType? type;
  Period? period;

  Compensation({
    this.amount,
    this.type,
    this.period,
  });

  Compensation.fromJson(Map<String, dynamic> json) {
    amount = intToDouble(json['amount']);
    type = CommonUtils.stringToEnum(json['type'], CompensationType.values);
    period = json['period'] is Map
        ? Period.fromJson(json['period'])
        : json['period'];
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'type': type?.name,
      'period': period?.toJson(),
    };
  }
}

class OrganizationMember {
  String? id;
  String? occupation;
  MemberRole? role;
  double? impactRatio;
  bool? isAutoContributing;
  double? hoursPerWeek;
  dynamic user;
  dynamic org;
  double? contributed;
  InvestorSettings? investorSettings;
  int? lamportsEarned;
  Equity? equity;
  Compensation? compensation;

  OrganizationMember({
    this.occupation,
    this.role,
    this.impactRatio = 1,
    this.isAutoContributing = false,
    this.hoursPerWeek = 40,
    this.user,
    this.org,
    this.contributed = 0,
    this.investorSettings,
    this.lamportsEarned,
    this.equity,
    this.compensation,
  });

  OrganizationMember.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    occupation = json['occupation'];
    role = CommonUtils.stringToEnum(json['role'], MemberRole.values);
    impactRatio = intToDouble(json['impactRatio']);
    isAutoContributing = json['isAutoContributing'];
    hoursPerWeek = intToDouble(json['hoursPerWeek']);
    user = json['user'] is Map ? User.fromJson(json['user']) : json['user'];
    org = json['org'] is Map ? Organization.fromJson(json['org']) : json['org'];
    contributed = intToDouble(json['contributed']);
    lamportsEarned = json['lamportsEarned'];
    investorSettings = json['investorSettings'] is Map
        ? InvestorSettings.fromJson(json['investorSettings'])
        : json['investorSettings'];
    equity = json['equity'] is Map
        ? Equity.fromJson(json['equity'])
        : json['equity'];
    compensation = json['compensation'] is Map
        ? Compensation.fromJson(json['compensation'])
        : json['compensation'];
  }

  @override
  String toString() {
    return '''
${super.toString()}
occupation: $occupation
impactRatio: $impactRatio
isAutoContributing: $isAutoContributing
hoursPerWeek: $hoursPerWeek
''';
  }

  Map<String, dynamic> toMap() {
    return {
      'occupation': occupation,
      'role': role?.name,
      'impactRatio': impactRatio,
      'isAutoContributing': isAutoContributing,
      'hoursPerWeek': hoursPerWeek,
      'user': user,
      'org': org,
      'investorSettings': investorSettings?.toJson(),
      'equity': equity?.toJson(),
      'compensation': compensation?.toJson(),
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
