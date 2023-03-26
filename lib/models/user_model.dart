import 'dart:typed_data';

class User {
  String nickname = '';
  String name = '';
  String? avatar;
  Uint8List? avatarToSet;

  User({
    this.nickname = '',
    this.name = '',
    this.avatar,
    this.avatarToSet,
  });

  User.fromJson(Map<String, dynamic> json) {
    nickname = json['nickname'];
    name = json['name'];
    avatar = json['avatar'];
  }
}
