import 'package:flutter/material.dart';
import 'package:iw_app/api/users_api.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/models/user_model.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/utils/datetime.dart';
import 'package:iw_app/widgets/media/network_image_auth.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

const LAMPORTS_IN_SOL = 1000000000;

class OrgMemebersDetailsLite extends StatelessWidget {
  final List<OrganizationMemberWithEquity> memebersWithEquity;

  const OrgMemebersDetailsLite({super.key, required this.memebersWithEquity});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
        title: 'Members Details',
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: ListView.builder(
            itemCount: memebersWithEquity.length,
            itemBuilder: (context, index) {
              final item = memebersWithEquity[index];
              final bool isLast = memebersWithEquity.length == index;
              return MemberDeitailsLite(
                memeberWithEquity: item,
                isLast: isLast,
              );
            },
          ),
        ),);
  }
}

class MemberDeitailsLite extends StatelessWidget {
  final OrganizationMemberWithEquity memeberWithEquity;
  final bool isLast;

  const MemberDeitailsLite(
      {super.key, required this.memeberWithEquity, required this.isLast,});

  @override
  Widget build(BuildContext context) {
    final User user = memeberWithEquity.member!.user;
    String? memberAvatar = user.avatar;
    bool isMemberRoleInvestor =
        memeberWithEquity.member!.role == MemberRole.Investor;
    Widget avatar = memberAvatar == null
        ? const Icon(Icons.man_2_rounded)
        : Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: COLOR_LIGHT_GRAY2,
              borderRadius: BorderRadius.circular(10),
            ),
            clipBehavior: Clip.antiAlias,
            child: FittedBox(
              fit: BoxFit.cover,
              child: NetworkImageAuth(
                imageUrl: '${usersApi.baseUrl}$memberAvatar',
              ),
            ),
          );
    const TextStyle defaultDetailDataItemTextStyle = TextStyle(
        color: COLOR_ALMOST_BLACK, fontSize: 16, fontWeight: FontWeight.w500,);
    final createdAt = DateTime.parse(memeberWithEquity.member!.createdAt!);
    final daysInCompany = (calculateDiffWithNow(createdAt) * -1).toInt();
    final compensationStr = memeberWithEquity.member!.compensation != null
        ? '\$${memeberWithEquity.member!.compensation!.amount} ${memeberWithEquity.member!.compensation!.type == CompensationType.PerMonth ? 'per month' : 'for ${memeberWithEquity.member!.compensation!.period!.value} ${memeberWithEquity.member!.compensation!.period!.timeframe!.name.toLowerCase()}'}'
        : '-';
    final equityStr = memeberWithEquity.member!.equity != null
        ? '${memeberWithEquity.member!.equity!.amount}%'
        : '-';

    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        avatar,
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 30,
                    child: Flex(
                        direction: Axis.horizontal,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text('@${user.nickname}',
                              style: const TextStyle(
                                  color: COLOR_ALMOST_BLACK,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,),),
                          Text(
                            ' / ${isMemberRoleInvestor ? "Investor" : memeberWithEquity.member!.occupation}',
                            style: const TextStyle(
                                color: COLOR_GRAY,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,),
                          )
                        ],),
                  ),
                  const SizedBox(height: 20),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DetailDataItem(
                            title: 'Contr.',
                            data: Text(
                                isMemberRoleInvestor
                                    ? '\$${memeberWithEquity.member!.investorSettings!.investmentAmount!.toStringAsFixed(2)}'
                                    : '${daysInCompany}d',
                                style: defaultDetailDataItemTextStyle,),),
                        DetailDataItem(
                            title: 'Compensation',
                            data: Text(compensationStr,
                                style: defaultDetailDataItemTextStyle,),),
                        DetailDataItem(
                          title: 'Equity',
                          data: Text(
                            equityStr,
                            style: const TextStyle(
                              color: COLOR_GREEN,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],),
                  const SizedBox(height: 20),
                  if (!isLast) const Divider()
                ],),
          ),
        )
      ],),
    );
  }
}

class DetailDataItem extends StatelessWidget {
  final String title;
  final Widget data;

  const DetailDataItem({super.key, required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      data,
      Text(
        title,
        style: const TextStyle(
            color: COLOR_GRAY, fontSize: 12, fontWeight: FontWeight.w300,),
      ),
    ],);
  }
}
