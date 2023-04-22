import 'package:iw_app/utils/numbers.dart';

class Payment {
  dynamic org;
  double? amount;
  String? cpPaymentUrl;

  Payment({this.org, this.amount, this.cpPaymentUrl});

  Payment.fromJson(Map<String, dynamic> json) {
    org = json['org'];
    amount = intToDouble(json['amount']);
    cpPaymentUrl = json['cpPaymentUrl'];
  }
}
