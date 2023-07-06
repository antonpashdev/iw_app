import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iw_app/theme/app_theme.dart';

class PermissionDescription {
  final String description;
  final Icon icon;

  const PermissionDescription({
    required this.description,
    required this.icon,
  });
}

List<PermissionDescription> _memberRoles = [
  const PermissionDescription(
    description: 'Only can view all the information about Organization',
    icon: Icon(CupertinoIcons.doc_text),
  ),
];

List<PermissionDescription> _adminRoles = [
  const PermissionDescription(
    description: 'Send any sum of money from Organization’s account',
    icon: Icon(Icons.account_balance_wallet_outlined),
  ),
  const PermissionDescription(
    description: 'Rise money',
    icon: Icon(Icons.attach_money_rounded),
  ),
  const PermissionDescription(
    description: 'Remove members from Organization',
    icon: Icon(Icons.person_remove),
  ),
  const PermissionDescription(
    description: 'Invite new members',
    icon: Icon(Icons.person_add_alt_1),
  ),
  const PermissionDescription(
    description: 'Edit Organization’s info',
    icon: Icon(Icons.edit_note_sharp),
  ),
];

_buildDesription(
  BuildContext context,
  List<PermissionDescription> permissionDescriptions,
  bool isSelected,
) {
  return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: COLOR_LIGHT_GRAY3,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      children: permissionDescriptions
          .map(
            (pd) => ListTile(
              textColor: isSelected ? COLOR_ALMOST_BLACK : COLOR_DISABLED_GRAY3,
              iconColor: isSelected ? COLOR_ALMOST_BLACK : COLOR_DISABLED_GRAY3,
              contentPadding: EdgeInsets.zero,
              leading: pd.icon,
              minLeadingWidth: 0,
              title: Text(pd.description, softWrap: true),
            ),
          )
          .toList(),
    ),
  );
}

buildMemberDescription(BuildContext context, bool isSelected) {
  return _buildDesription(context, _memberRoles, isSelected);
}

buildAdminDescription(BuildContext context, bool isSelected) {
  return _buildDesription(context, _adminRoles, isSelected);
}
