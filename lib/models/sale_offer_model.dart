import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/utils/numbers.dart';

class SaleOffer {
  String? id;
  String? status;
  double? tokensAmount;
  double? price;
  dynamic seller;
  dynamic org;
  String? buyer;

  SaleOffer({
    this.status,
    this.tokensAmount,
    this.price,
    this.seller,
    this.org,
    this.buyer,
  });

  SaleOffer.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    status = json['status'];
    tokensAmount = intToDouble(json['tokensAmount']);
    price = intToDouble(json['price']);
    seller = json['seller'];
    org = json['org'] is Map ? Organization.fromJson(json['org']) : json['org'];
    buyer = json['buyer'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['tokensAmount'] = tokensAmount;
    data['price'] = price;
    data['seller'] = seller;
    data['org'] = org;
    data['buyer'] = buyer;
    return data;
  }
}
