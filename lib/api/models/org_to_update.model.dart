import 'package:iw_app/models/organization_model.dart';

class OrgSettingsToUpdate {
  num? treasury;
  bool? isApp;
  double? pricePerMonth;

  OrgSettingsToUpdate({
    this.treasury,
    this.isApp,
    this.pricePerMonth,
  });

  OrgSettingsToUpdate.fromOrgSettings(OrganizationSettings? settings)
      : treasury = settings?.treasury,
        isApp = settings?.isApp,
        pricePerMonth = settings?.pricePerMonth;

  Map<String, dynamic> toMap() {
    return {
      'treasury': treasury,
      'isApp': isApp,
      'pricePerMonth': pricePerMonth,
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

  OrgToUpdate.fromOrg(Organization organization)
      : name = organization.name,
        username = organization.username,
        description = organization.description,
        link = organization.link,
        settings = OrgSettingsToUpdate.fromOrgSettings(organization.settings),
        logo = organization.logo;

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
