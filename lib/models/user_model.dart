class User {
  String nickname = '';
  String name = '';
  String? image;

  User(this.nickname, this.name);

  set setNickname(String nickname) {
    this.nickname = nickname;
  }

  set setName(String name) {
    this.name = name;
  }

  set setImage(String? image) {
    this.image = image;
  }
}
