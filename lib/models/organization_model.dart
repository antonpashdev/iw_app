import 'dart:typed_data';

import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/utils/numbers.dart';

class Organization {
  String? id;
  String? username;
  String? name;
  String? link;
  String? description;
  String? logo;
  String? wallet;
  Uint8List? logoToSet;
  OrganizationSettings settings = OrganizationSettings();
  double? lamportsMinted;

  Organization({
    this.username,
    this.name,
    this.link,
    this.description,
    this.logo,
    this.wallet,
    this.lamportsMinted,
  });

  Organization.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    username = json['username'];
    name = json['name'];
    link = json['link'];
    description = json['description'];
    logo = json['logo'];
    wallet = json['wallet'];
    lamportsMinted = intToDouble(json['lamportsMinted']);
    settings = OrganizationSettings.fromJson(json['settings']);
  }

  @override
  String toString() {
    return '''
${super.toString()}
username: $username
name: $name
link: $link
wallet: $wallet
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
      'lamportsMinted': lamportsMinted,
    };
    if (member != null) {
      orgMap['member[occupation]'] = member.occupation;
      orgMap['member[role]'] = member.role?.name;
      orgMap['member[impactRatio]'] = member.impactRatio;
      orgMap['member[isMonthlyCompensated]'] = member.isMonthlyCompensated;
      orgMap['member[monthlyCompensation]'] = member.monthlyCompensation;
      orgMap['member[isAutoContributing]'] = member.isAutoContributing;
      orgMap['member[hoursPerWeek]'] = member.hoursPerWeek;
      orgMap['member[user]'] = member.user;
    }
    return orgMap;
  }
}

class OrganizationSettings {
  int treasury = 0;

  OrganizationSettings({this.treasury = 0});

  OrganizationSettings.fromJson(Map<String, dynamic> json) {
    treasury = json['treasury'];
  }

  @override
  String toString() {
    return '''
  ${super.toString()}
  treasury: $treasury
''';
  }
}
