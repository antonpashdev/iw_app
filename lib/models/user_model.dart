class User {
  String nickname = '';
  String name = '';

  User(this.nickname, this.name);

  set setNickname(String nickname) {
    this.nickname = nickname;
  }

  set setName(String name) {
    this.name = name;
  }
}
