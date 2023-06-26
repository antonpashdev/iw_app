import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/utils/common.dart';

import '../utils/numbers.dart';

enum OfferStatus {
  Pending,
  Approved,
  Declined,
}

enum OfferType {
  Regular,
  Investor,
}

class OfferInvestorSettings {
  double? amount;
  double? equity;

  OfferInvestorSettings({
    this.amount,
    this.equity,
  });

  OfferInvestorSettings.fromJson(Map<String, dynamic> json) {
    amount = intToDouble(json['amount']);
    equity = intToDouble(json['equity']);
  }

  Map<String, dynamic> toJson() {
    return {'amount': amount, 'equity': equity};
  }
}

class AvailableInvestorSettings extends OfferInvestorSettings {}

class Offer {
  String? id;
  dynamic org;
  OfferType? type;
  OfferStatus? status;
  List<OrganizationMember>? memberProspects;
  OfferInvestorSettings? investorSettings;
  OfferInvestorSettings? availableInvestment;

  Offer({
    this.id,
    this.status,
    this.memberProspects,
    this.org,
    this.type,
    this.investorSettings,
    this.availableInvestment,
  });

  _getInvestmentData() {
    if (type == OfferType.Investor) {
      double amount = 0.00;
      double equity = 0.00;
      memberProspects?.forEach((element) {
        amount = amount + element.investorSettings!.investmentAmount!;
        equity = equity + element.investorSettings!.equityAllocation!;
      });
      return OfferInvestorSettings(
        amount: amount,
        equity: equity,
      );
    }
    return null;
  }

  Offer.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    status = CommonUtils.stringToEnum(json['status'], OfferStatus.values);
    type = CommonUtils.stringToEnum(json['type'], OfferType.values);
    memberProspects = (json['memberProspects'] as List)
        .map((member) => OrganizationMember.fromJson(member))
        .toList();
    org = json['org'] is Map ? Organization.fromJson(json['org']) : json['org'];
    investorSettings = json['investorSettings'] is Map
        ? OfferInvestorSettings.fromJson(json['investorSettings'])
        : json['investorSettings'];
    availableInvestment = _getInvestmentData();
  }

  Map<String, dynamic> toJson(OrganizationMember? member) {
    final json = {
      'type': type?.name,
      'investorSettings': investorSettings?.toJson(),
    };
    if (member != null) {
      json['memberProspect'] = member.toMap();
    }
    return json;
  }
}
