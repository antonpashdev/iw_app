class Payment {
  dynamic org;
  double? amount;
  String? cpPaymentUrl;

  Payment({this.org, this.amount, this.cpPaymentUrl});

  Payment.fromJson(Map<String, dynamic> json) {
    org = json['org'];
    amount = json['amount'];
    cpPaymentUrl = json['cpPaymentUrl'];
  }
}
