import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/models/user_model.dart';

class Account {
  String? id;
  String? name;
  String? username;
  String? wallet;
  bool? isUser;
  String? image;
  User? user;
  Organization? organization;

  Account({
    this.id,
    this.name,
    this.username,
    this.wallet,
    this.isUser,
    this.image,
    this.user,
    this.organization,
  });

  Account.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    wallet = json['wallet'];
    isUser = json['isUser'];
    image = json['image'];
    user = json['user'] is Map ? User.fromJson(json['user']) : null;
    organization = json['organization'] is Map
        ? Organization.fromJson(json['organization'])
        : null;
  }
}
