import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/screens/organization/org_details/builders/member.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/utils/app_padding.dart';

buildMembers(
  BuildContext context,
  Organization org,
  List<OrganizationMemberWithEquity> members,
  bool isPreviewMode,
  Function onViewDetailsPressed,
  Function onAddMemberPressed,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AppPadding(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '${members.length} Members',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            CupertinoButton(
              onPressed: () => onViewDetailsPressed(members),
              child: const Text(
                'View Details',
                style: TextStyle(
                  fontFamily: 'SF Pro Display',
                  fontSize: 14,
                  color: COLOR_BLUE,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        ),
      ),
      const SizedBox(height: 15),
      SizedBox(
        height: 120,
        child: ListView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: const Color(0xffe2e2e8),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: InkWell(
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      onTap:
                          isPreviewMode ? null : () => onAddMemberPressed(org),
                      child: const Icon(
                        CupertinoIcons.add,
                        size: 35,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Invite member',
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            ...members
                .asMap()
                .map((i, member) {
                  return MapEntry(
                    i,
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => onViewDetailsPressed(members),
                          child: buildMember(context, member),
                        ),
                        if (i != members.length - 1) const SizedBox(width: 10),
                        if (i == members.length - 1) const SizedBox(width: 20),
                      ],
                    ),
                  );
                })
                .values
                .toList(),
          ],
        ),
      ),
    ],
  );
}
