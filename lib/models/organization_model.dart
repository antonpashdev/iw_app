class Organization {
  String? username;
  String? name;
  String? link;
  String? description;
  OrganizationSettings? settings;

  Organization({
    this.username,
    this.name,
    this.link,
    this.description,
    this.settings,
  });

  @override
  String toString() {
    return '''
${super.toString()}
username: $username
name: $name
link: $link
description: $description
''';
  }
}

class OrganizationSettings {}
