import 'package:iw_app/utils/numbers.dart';

import 'organization_model.dart';

class PaymentItem {
  String? name;
  double? amount;
  String? image;

  PaymentItem({this.name, this.amount, this.image});

  PaymentItem.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    amount = intToDouble(json['amount']);
    image = json['image'];
  }
}

class Payment {
  String? id;
  dynamic org;
  double? amount;
  String? cpPaymentUrl;
  List<PaymentItem>? items;

  Payment({this.org, this.amount, this.cpPaymentUrl});

  Payment.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    org = json['org'] is Map ? Organization.fromJson(json['org']) : json['org'];
    amount = intToDouble(json['amount']);
    cpPaymentUrl = json['cpPaymentUrl'];
    if (json['items'] != null) {
      items = <PaymentItem>[];
      json['items'].forEach((v) {
        items!.add(PaymentItem.fromJson(v));
      });
    }
  }
}
