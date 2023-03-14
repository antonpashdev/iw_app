import 'dart:typed_data';

class Organization {
  String? username;
  String? name;
  String? link;
  String? description;
  Uint8List? logo;
  OrganizationSettings? settings;

  Organization({
    this.username,
    this.name,
    this.link,
    this.description,
    this.logo,
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
