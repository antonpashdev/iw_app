import 'package:iw_app/models/organization_model.dart';

class SaleOffer {
  String? id;
  String? status;
  double? tokensAmount;
  double? price;
  String? seller;
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
    tokensAmount = json['tokensAmount'];
    price = json['price'];
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
