import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iw_app/api/orgs_api.dart';
import 'package:iw_app/l10n/generated/app_localizations.dart';
import 'package:iw_app/models/config_model.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/media/network_image_auth.dart';
import 'package:iw_app/widgets/state/config.dart';

class OrgMemberCard extends StatelessWidget {
  final Function()? onTap;
  final OrganizationMember? member;
  final Future<List<OrganizationMember>>? futureOtherMembers;

  const OrgMemberCard({
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
    Config config = ConfigState.of(context).config;
    if (member == null) {
      return Text(
        config.mode == Mode.Lite
            ? 'Create Organization or Project'
            : AppLocalizations.of(context)!.homeScreen_createNewOrgTitle,
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

  buildMainSection(BuildContext context) {
    if (member == null) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.homeScreen_createNewOrgDesc,
          style: const TextStyle(color: COLOR_GRAY),
        ),
      );
    }

    final contributed = member!.role == MemberRole.Investor
        ? '\$${NumberFormat.compact().format(member!.investorSettings!.investmentAmount)}'
        : '${member!.contributed!.toStringAsFixed(3)}h';
    final ratioOrAllocation = member!.role == MemberRole.Investor
        ? '${member!.investorSettings!.equityAllocation}%'
        : '${member!.impactRatio}x';
    final textStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w500,
        );
    return Column(
      children: [
        const Spacer(),
        ListTile(
          dense: true,
          title: Text('You Contributed', style: textStyle),
          contentPadding: const EdgeInsets.all(0),
          trailing: Text(contributed, style: textStyle),
          visualDensity:
              const VisualDensity(vertical: VisualDensity.minimumDensity),
        ),
        const Divider(height: 1),
        ListTile(
          dense: true,
          title: Text(
            member!.role == MemberRole.Investor
                ? 'Your Equity Allocation'
                : 'Your Impact Ratio',
            style: textStyle,
          ),
          contentPadding: const EdgeInsets.all(0),
          trailing: Text(ratioOrAllocation, style: textStyle),
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
                  ...snapshot.data!
                      .asMap()
                      .map((i, member) {
                        return MapEntry(
                          i,
                          Positioned(
                            left: 10.0 * i,
                            top: 0,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: COLOR_GRAY,
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
                                  child: member.user.avatar != null
                                      ? NetworkImageAuth(
                                          imageUrl:
                                              '${orgsApi.baseUrl}${member.user.avatar}',
                                        )
                                      : const Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: Icon(
                                            CupertinoIcons.person_fill,
                                            color: COLOR_ALMOST_BLACK,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        );
                      })
                      .values
                      .toList(),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 30 + ((snapshot.data!.length - 1) * 10) + 5,
                    child: Center(
                      child: Text(
                        '${snapshot.data!.length} members',
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
                    color: COLOR_LIGHT_GRAY2,
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
