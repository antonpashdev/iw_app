import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iw_app/api/orgs_api.dart';
import 'package:iw_app/l10n/generated/app_localizations.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/utils/datetime.dart';
import 'package:iw_app/widgets/media/network_image_auth.dart';

class OrgMemberCardLite extends StatelessWidget {
  final Function()? onTap;
  final OrganizationMember? member;
  final Future<Map<String, dynamic>>? futureOtherMembers;

  const OrgMemberCardLite({
    Key? key,
    this.onTap,
    this.member,
    this.futureOtherMembers,
  }) : super(key: key);

  buildLogo() {
    return member != null
        ? FittedBox(
            clipBehavior: Clip.hardEdge,
            fit: BoxFit.cover,
            child: NetworkImageAuth(
              imageUrl: '${orgsApi.baseUrl}${member?.org?.logo}',
            ),
          )
        : const Center(
            child: Icon(
              CupertinoIcons.add,
              size: 30,
              color: COLOR_ALMOST_BLACK,
            ),
          );
  }

  buildOrgName(BuildContext context) {
    if (member == null) {
      return Text(
        AppLocalizations.of(context)!.homeScreen_createNewOrgTitle,
        style: Theme.of(context).textTheme.headlineSmall,
      );
    }
    return Text(
      member?.org?.name,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }

  buildOrgUsername(BuildContext context) {
    if (member == null) {
      return Container();
    }
    return Column(
      children: [
        const SizedBox(height: 5),
        Text(
          '@${member?.org?.username}',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: COLOR_GRAY),
        ),
      ],
    );
  }

  buildMembersShimmer() {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: COLOR_LIGHT_GRAY,
          ),
        ),
        const SizedBox(width: 5),
        Container(
          width: 60,
          height: 10,
          decoration: const BoxDecoration(
            color: COLOR_LIGHT_GRAY,
          ),
        ),
      ],
    );
  }

  buildMember(OrganizationMember member, int i) {
    return Positioned(
      left: 10.0 * i,
      top: 0,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.transparent,
          border: Border.all(
            color: COLOR_WHITE.withAlpha(200),
            width: 1.5,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: FittedBox(
            fit: BoxFit.cover,
            child: member.image != null
                ? NetworkImageAuth(
                    imageUrl: '${orgsApi.baseUrl}${member.image}',
                  )
                : const Icon(
                    CupertinoIcons.person_fill,
                    color: COLOR_LIGHT_GRAY,
                  ),
          ),
        ),
      ),
    );
  }

  buildMainSection(BuildContext context) {
    if (member == null) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.homeScreen_createNewOrgDesc,
          style: const TextStyle(color: COLOR_GRAY),
        ),
      );
    }
    final createdAt = DateTime.parse(member!.createdAt!).toLocal();
    final createdAtStr = getFormattedDate(createdAt);
    final textStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w500,
        );
    return Column(
      children: [
        const Spacer(),
        ListTile(
          dense: true,
          title: Text('Joined', style: textStyle),
          contentPadding: const EdgeInsets.all(0),
          trailing: Text(createdAtStr, style: textStyle),
          visualDensity:
              const VisualDensity(vertical: VisualDensity.minimumDensity),
        ),
        const Divider(height: 1),
        ListTile(
          dense: true,
          title: Text(
            'Your total earnings',
            style: textStyle,
          ),
          contentPadding: const EdgeInsets.all(0),
          trailing: Text(
            '${(NumberFormat('#,###.##').format(member?.profit ?? 0))}\$',
            style: textStyle,
          ),
          visualDensity:
              const VisualDensity(vertical: VisualDensity.minimumDensity),
        ),
        const Divider(height: 1),
        const SizedBox(height: 15),
        FutureBuilder(
          future: futureOtherMembers,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return buildMembersShimmer();
            }
            return SizedBox(
              height: 30,
              child: Stack(
                children: [
                  ...snapshot.data?['members']
                      .asMap()
                      .map((i, member) {
                        return MapEntry(
                          i,
                          buildMember(member, i),
                        );
                      })
                      .values
                      .toList(),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left:
                        30 + ((snapshot.data?['members'].length - 1) * 10) + 5,
                    child: Center(
                      child: Text(
                        '${snapshot.data?['total']} members',
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width * 0.6,
      child: Card(
        margin: const EdgeInsets.all(0),
        color: COLOR_LIGHT_GRAY,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: buildLogo(),
                ),
                const SizedBox(height: 10),
                buildOrgName(context),
                buildOrgUsername(context),
                Expanded(
                  child: buildMainSection(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
