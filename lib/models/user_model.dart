import 'dart:typed_data';

class User {
  String nickname = '';
  String name = '';
  String? avatar;
  String? id;
  String? wallet;
  Uint8List? avatarToSet;

  User({
    this.nickname = '',
    this.name = '',
    this.avatar,
    this.avatarToSet,
    this.id,
    this.wallet,
  });

  User.fromJson(Map<String, dynamic> json) {
    nickname = json['nickname'];
    name = json['name'];
    avatar = json['avatar'];
    wallet = json['wallet'];
    id = json['_id'];
  }
}
