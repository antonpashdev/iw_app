import 'dart:typed_data';

import 'package:iw_app/models/organization_member_model.dart';

class Organization {
  String? id;
  String? username;
  String? name;
  String? link;
  String? description;
  String? logo;
  Uint8List? logoToSet;
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
    logo = json['logo'];
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

  Map<String, dynamic> toMap(OrganizationMember? member) {
    final orgMap = {
      'username': username,
      'name': name,
      'link': link,
      'description': description,
      'settings[treasury]': settings.treasury,
    };
    if (member != null) {
      orgMap['member[occupation]'] = member.occupation;
      orgMap['member[role]'] = member.role?.name;
      orgMap['member[impactRatio]'] = member.impactRatio;
      orgMap['member[isMonthlyCompensated]'] = member.isMonthlyCompensated;
      orgMap['member[monthlyCompensation]'] = member.monthlyCompensation;
      orgMap['member[autoContribution]'] = member.autoContribution;
      orgMap['member[user]'] = member.user;
    }
    return orgMap;
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
