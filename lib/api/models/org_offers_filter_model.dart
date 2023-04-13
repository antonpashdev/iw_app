import 'package:iw_app/models/offer_model.dart';
import 'package:iw_app/models/organization_member_model.dart';

class OrgOffersFilter {
  OfferStatus? status;
  MemberRole? role;

  OrgOffersFilter({
    this.status,
    this.role,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (status != null) {
      map['status'] = status!.toString().split('.').last;
    }
    if (role != null) {
      map['role'] = role!.toString().split('.').last;
    }
    return map;
  }
}
