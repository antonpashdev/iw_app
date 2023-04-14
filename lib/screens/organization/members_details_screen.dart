import 'package:flutter/material.dart';
import 'package:iw_app/api/users_api.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/models/user_model.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

const LAMPORTS_IN_SOL = 1000000000;

class OrgMemebersDetails extends StatelessWidget {
  final List<OrganizationMemberWithEquity> memebersWithEquity;

  const OrgMemebersDetails({super.key, required this.memebersWithEquity});

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
              return MemberDeitails(
                memeberWithEquity: item,
                isLast: isLast,
              );
            },
          ),
        ));
  }
}

class MemberDeitails extends StatelessWidget {
  final OrganizationMemberWithEquity memeberWithEquity;
  final bool isLast;

  const MemberDeitails(
      {super.key, required this.memeberWithEquity, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final User user = memeberWithEquity.member!.user;
    String? memberAvatar = user.avatar;
    bool isMemeberRoleInvestor =
        memeberWithEquity.member!.role == MemberRole.Investor;
    Widget avatar = memberAvatar == null
        ? const Icon(Icons.man_2_rounded)
        : ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.network(
              '${usersApi.baseUrl}$memberAvatar',
              width: 30.0,
              height: 30.0,
              fit: BoxFit.cover,
            ),
          );

    const TextStyle defaultDetailDataItemTextStyle = TextStyle(
        color: COLOR_ALMOST_BLACK, fontSize: 16, fontWeight: FontWeight.w500);

    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Column(children: [avatar]),
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
                                  fontSize: 16)),
                          Text(
                            ' / ${memeberWithEquity.member!.occupation}',
                            style: const TextStyle(
                                color: COLOR_GRAY,
                                fontWeight: FontWeight.w400,
                                fontSize: 16),
                          )
                        ]),
                  ),
                  const SizedBox(height: 20),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DetailDataItem(
                            title: 'Contr.',
                            data: Text(
                                isMemeberRoleInvestor
                                    ? '\$${memeberWithEquity.member!.contributed!.toStringAsFixed(2)}'
                                    : '${memeberWithEquity.member!.contributed!.toStringAsFixed(2)}h',
                                style: defaultDetailDataItemTextStyle)),
                        DetailDataItem(
                            title:
                                isMemeberRoleInvestor ? 'Allocation' : 'Ratio',
                            data: Text(
                                isMemeberRoleInvestor
                                    ? '${memeberWithEquity.member!.investorSettings!.equityAllocation}'
                                    : '${memeberWithEquity.member!.impactRatio}x',
                                style: defaultDetailDataItemTextStyle)),
                        DetailDataItem(
                            title: 'iShares',
                            data: Text(
                                (memeberWithEquity.member!.lamportsEarned! /
                                        LAMPORTS_IN_SOL)
                                    .toStringAsFixed(4),
                                style: defaultDetailDataItemTextStyle)),
                        DetailDataItem(
                            title: 'Equity',
                            data: FutureBuilder(
                              future: memeberWithEquity.futureEquity,
                              builder: (context, snapshot) {
                                if (snapshot.data == null) {
                                  return Container();
                                }

                                return Text(
                                    '${(snapshot.data!.equity! * 100).toStringAsFixed(1)}%',
                                    style: const TextStyle(
                                        color: COLOR_GREEN,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500));
                              },
                            ))
                      ]),
                  const SizedBox(height: 20),
                  isLast ? Container() : const Divider()
                ]),
          ),
        )
      ]),
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
      Text(title,
          style: const TextStyle(
              color: COLOR_GRAY, fontSize: 12, fontWeight: FontWeight.w300))
    ]);
  }
}
