import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/models/user_model.dart';
import 'package:iw_app/utils/common.dart';

enum OrgHistoryItemAction { Joined, Contributed, Received }

class OrgEventsHistoryItem {
  User? user;
  Organization? orgUser;
  String? createdAt;
  String? stoppedAt;
  OrgHistoryItemAction? action;
  String? date;
  String? memo;
  double? amount;

  OrgEventsHistoryItem({
    this.createdAt,
    this.stoppedAt,
    this.action,
    this.date,
  });

  OrgEventsHistoryItem.fromJson(Map<String, dynamic> json) {
    user = json['user'] is Map ? User.fromJson(json['user']) : null;
    orgUser =
        json['orgUser'] is Map ? Organization.fromJson(json['orgUser']) : null;
    createdAt = json['createdAt'];
    stoppedAt = json['stoppedAt'];
    action =
        CommonUtils.stringToEnum(json['action'], OrgHistoryItemAction.values);
    date = json['date'];
    memo = json['memo'];
    amount = json['amount'];
  }
}
