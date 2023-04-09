import 'dart:typed_data';

class User {
  String nickname = '';
  String name = '';
  String wallet = '';
  String? avatar;
  String? id;
  Uint8List? avatarToSet;

  User({
    this.nickname = '',
    this.name = '',
    this.avatar,
    this.wallet = '',
    this.avatarToSet,
    this.id,
  });

  User.fromJson(Map<String, dynamic> json) {
    nickname = json['nickname'];
    name = json['name'];
    avatar = json['avatar'];
    wallet = json['wallet'];
    id = json['_id'];
  }
}
