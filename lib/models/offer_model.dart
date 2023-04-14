import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/utils/common.dart';

enum OfferStatus {
  Pending,
  Approved,
  Declined,
}

class Offer {
  String? id;
  OfferStatus? status;
  OrganizationMember? memberProspect;
  dynamic org;

  Offer({
    this.id,
    this.status,
    this.memberProspect,
    this.org,
  });

  Offer.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    status = CommonUtils.stringToEnum(json['status'], OfferStatus.values);
    memberProspect = OrganizationMember.fromJson(json['memberProspect']);
    org = json['org'] is Map ? Organization.fromJson(json['org']) : json['org'];
  }
}
