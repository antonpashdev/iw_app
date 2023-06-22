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
  OrganizationMember? memberProspect;
  List<OrganizationMember>? memberProspects;
  OfferInvestorSettings? investorSettings;
  OfferInvestorSettings? availableInvestment;

  Offer({
    this.id,
    this.status,
    this.memberProspects,
    this.org,
    this.type,
    this.memberProspect,
    this.investorSettings,
  });

  _getAvailableInvestment(
    List<OrganizationMember>? memberProspects,
    OfferType type,
    OfferInvestorSettings investorSettings,
  ) {
    if (type == OfferType.Investor) {
      double amount = 0.00;
      double equity = 0.00;
      memberProspects?.forEach((element) {
        amount = amount + element.investorSettings!.investmentAmount!;
        equity = equity + element.investorSettings!.equityAllocation!;
      });

      return OfferInvestorSettings(
          amount: investorSettings.amount! - amount,
          equity: investorSettings.equity! - equity);
    }
    return null;
  }

  Offer.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    status = CommonUtils.stringToEnum(json['status'], OfferStatus.values);
    type = CommonUtils.stringToEnum(json['type'], OfferType.values);
    memberProspect = json['memberProspect'] is Map
        ? OrganizationMember.fromJson(json['memberProspect'])
        : json['memberProspect'];
    memberProspects = (json['memberProspects'] as List)
        .map((member) => OrganizationMember.fromJson(member))
        .toList();
    org = json['org'] is Map ? Organization.fromJson(json['org']) : json['org'];
    investorSettings = OfferInvestorSettings.fromJson(json['investorSettings']);
    availableInvestment =
        _getAvailableInvestment(memberProspects, type!, investorSettings!);
    print('availableInvestment: $availableInvestment');
  }

  Map<String, dynamic> toMap() {
    return {'org': org, 'type': type, 'investorSettings': investorSettings};
  }
}
