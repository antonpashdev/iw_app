import 'package:iw_app/models/offer_model.dart';

class OrgOffersFilter {
  OfferStatus? status;
  OfferType? type;

  OrgOffersFilter({
    this.status,
    this.type,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (status != null) {
      map['status'] = status!.toString().split('.').last;
    }
    if (type != null) {
      map['type'] = type!.toString().split('.').last;
    }
    return map;
  }
}
