import 'package:iw_app/models/user_model.dart';

class Account {
  String? id;
  String? name;
  String? username;
  String? wallet;
  bool? isUser;
  String? image;
  User? user;

  Account({
    this.id,
    this.name,
    this.username,
    this.wallet,
    this.isUser,
    this.image,
    this.user,
  });

  Account.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    wallet = json['wallet'];
    isUser = json['isUser'];
    image = json['image'];
    user = json['user'] is Map ? User.fromJson(json['user']) : null;
  }
}
