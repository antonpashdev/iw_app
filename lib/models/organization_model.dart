import 'dart:convert';
import 'dart:typed_data';

class Organization {
  String? id;
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

  Organization.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    username = json['username'];
    name = json['name'];
    link = json['link'];
    description = json['description'];
    logo = base64Decode(json['logo']);
  }

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

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'name': name,
      'link': link,
      'description': description,
      'settings[treasury]': settings.treasury,
    };
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
