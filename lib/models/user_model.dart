import 'dart:typed_data';

class User {
  String nickname = '';
  String name = '';
  Uint8List? image;

  User(this.nickname, this.name);
}
