class UserToUpdate {
  String? name;
  String? avatar;

  UserToUpdate({
    this.name,
    this.avatar,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'avatar': avatar == '' ? null : avatar,
    };
  }
}
