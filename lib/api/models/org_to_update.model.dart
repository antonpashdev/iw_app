class OrgSettingsToUpdate {
  num? treasury;

  OrgSettingsToUpdate({
    this.treasury,
  });

  Map<String, dynamic> toMap() {
    return {
      'treasury': treasury,
    };
  }
}

class OrgToUpdate {
  String? name;
  String? username;
  String? description;
  String? link;
  OrgSettingsToUpdate? settings;
  String? logo;

  OrgToUpdate({
    this.name,
    this.username,
    this.description,
    this.link,
    this.settings,
    this.logo,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'username': username,
      'description': description,
      'link': link,
      'settings': settings?.toMap(),
      'logo': logo,
    };
  }
}
