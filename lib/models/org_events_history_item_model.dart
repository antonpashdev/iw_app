import 'package:iw_app/models/user_model.dart';
import 'package:iw_app/utils/common.dart';

enum OrgHistoryItemAction { Joined, Contributed }

class OrgEventsHistoryItem {
  User? user;
  String? createdAt;
  String? stoppedAt;
  OrgHistoryItemAction? action;
  String? date;

  OrgEventsHistoryItem({
    this.createdAt,
    this.stoppedAt,
    this.action,
    this.date,
  });

  OrgEventsHistoryItem.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    createdAt = json['createdAt'];
    stoppedAt = json['stoppedAt'];
    action =
        CommonUtils.stringToEnum(json['action'], OrgHistoryItemAction.values);
    date = json['date'];
  }
}
