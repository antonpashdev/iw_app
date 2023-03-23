import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/models/organization_model.dart';

class Offer {
  String? id;
  String? status;
  OrganizationMember? memberProspect;
  dynamic org;

  Offer.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    status = json['status'];
    memberProspect = OrganizationMember.fromJson(json['memberProspect']);
    org = json['org'] is Map ? Organization.fromJson(json['org']) : json['org'];
  }
}
