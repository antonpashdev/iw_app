import 'dart:convert';
import 'dart:typed_data';

class User {
  String nickname = '';
  String name = '';
  Uint8List? image;

  User({this.nickname = '', this.name = '', this.image});

  User.fromJson(Map<String, dynamic> json) {
    nickname = json['nickname'];
    name = json['name'];
    image = base64Decode(json['avatar']);
  }
}
