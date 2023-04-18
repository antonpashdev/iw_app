import 'package:iw_app/utils/numbers.dart';

class TxnHistoryItem {
  int? processedAt;
  String? addressOrUsername;
  String? img;
  double? amount;
  String? description;

  TxnHistoryItem({
    this.processedAt,
    this.addressOrUsername,
    this.img,
    this.amount,
    this.description,
  });

  TxnHistoryItem.fromJson(Map<String, dynamic> json) {
    processedAt = json['processedAt'];
    addressOrUsername = json['addressOrUsername'];
    img = json['img'];
    amount = intToDouble(json['amount']);
    description = json['description'];
  }
}
