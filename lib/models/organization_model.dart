import 'dart:typed_data';

class Organization {
  String? username;
  String? name;
  String? link;
  String? description;
  Uint8List? logo;
  OrganizationSettings settings = OrganizationSettings();

  Organization({
    this.username,
    this.name,
    this.link,
    this.description,
    this.logo,
  });

  @override
  String toString() {
    return '''
${super.toString()}
username: $username
name: $name
link: $link
description: $description
settings:
$settings
''';
  }
}

class OrganizationSettings {
  int treasury = 0;

  OrganizationSettings({this.treasury = 0});

  @override
  String toString() {
    return '''
  ${super.toString()}
  treasury: $treasury
''';
  }
}
