import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iw_app/api/models/send_money_data_model.dart';
import 'package:iw_app/api/orgs_api.dart';
import 'package:iw_app/api/users_api.dart';
import 'package:iw_app/models/contribution_model.dart';
import 'package:iw_app/models/org_events_history_item_model.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/screens/contribution/contribution_screen.dart';
import 'package:iw_app/screens/offer/offer_new_member_screen.dart';
import 'package:iw_app/screens/organization/members_details_screen.dart';
import 'package:iw_app/screens/organization/org_settings_screen.dart';
import 'package:iw_app/screens/organization/receive_money_payment_type_screen.dart';
import 'package:iw_app/screens/send_money/send_money_recipient_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/utils/datetime.dart';
import 'package:iw_app/utils/numbers.dart';
import 'package:iw_app/widgets/list/generic_list_tile.dart';
import 'package:iw_app/widgets/media/network_image_auth.dart';
import 'package:iw_app/widgets/utils/app_padding.dart';
import 'package:url_launcher/url_launcher.dart';

RegExp trimZeroesRegExp = RegExp(r'([.]*0+)(?!.*\d)');

class OrgDetailsScreen extends StatefulWidget {
  final String orgId;
  final OrganizationMember member;
  final bool isPreviewMode;

  const OrgDetailsScreen({
    Key? key,
    required this.orgId,
    required this.member,
    this.isPreviewMode = false,
  }) : super(key: key);

  @override
  State<OrgDetailsScreen> createState() => _OrgDetailsScreenState();
}

class _OrgDetailsScreenState extends State<OrgDetailsScreen> {
  late Future<Organization> futureOrg;
  late Future<List<OrganizationMemberWithEquity>> futureMembers;
  late Future<double> futureBalance;
  late Future<List<OrgEventsHistoryItem>> futureHistory;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    futureOrg = fetchOrg();
    futureMembers = fetchMembers();
    futureHistory = fetchHistory();
  }

  Future<Organization> fetchOrg() async {
    final response = await orgsApi.getOrgById(widget.orgId);
    final org = Organization.fromJson(response.data);
    futureBalance = fetchBalance(org.id!);
    return org;
  }

  Future<List<OrganizationMemberWithEquity>> fetchMembers() async {
    final response = await orgsApi.getOrgMembers(widget.orgId);
    return (response.data as List).map((memberJson) {
      final member = OrganizationMember.fromJson(memberJson);
      return OrganizationMemberWithEquity(
        member: member,
        futureEquity: fetchMemberEquity(member),
      );
    }).toList();
  }

  Future<List<OrgEventsHistoryItem>> fetchHistory() async {
    try {
      final response = await orgsApi.getOrgEventsHistory(widget.orgId);
      return (response.data as List)
          .map((itemJson) => OrgEventsHistoryItem.fromJson(itemJson))
          .toList();
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<MemberEquity> fetchMemberEquity(OrganizationMember member) async {
    final response = await orgsApi.getMemberEquity(member.org, member.id!);
    return MemberEquity.fromJson(response.data);
  }

  Future<double> fetchBalance(String orgId) async {
    final response = await orgsApi.getBalance(orgId);
    return intToDouble(response.data['balance'])!;
  }

  Future onRefresh() {
    setState(() {
      futureOrg = fetchOrg();
      futureMembers = fetchMembers();
      futureBalance = fetchBalance(widget.orgId);
      futureHistory = fetchHistory();
    });
    return Future.wait([
      futureOrg,
      futureMembers,
      futureBalance,
      futureHistory,
    ]);
  }

  buildHeader(BuildContext context, Organization org) {
    return Row(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: COLOR_GRAY,
            borderRadius: BorderRadius.circular(30),
          ),
          clipBehavior: Clip.antiAlias,
          child: FittedBox(
            fit: BoxFit.cover,
            child: NetworkImageAuth(
              imageUrl: '${orgsApi.baseUrl}${org.logo!}',
            ),
          ),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
                future: futureBalance,
                builder: (_, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator.adaptive();
                  }
                  return Text(
                    '\$${snapshot.data!.toStringAsFixed(2)}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  );
                }),
            const SizedBox(height: 5),
            Text(
              'Treasury ${org.settings.treasury}%',
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w400, color: COLOR_GRAY),
            ),
            const SizedBox(height: 7),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: widget.isPreviewMode
                      ? null
                      : () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => SendMoneyRecipientScreen(
                                senderWallet: org.wallet!,
                                onSendMoney: (SendMoneyData data) =>
                                    orgsApi.sendMoney(widget.orgId, data),
                                originScreenFactory: () => OrgDetailsScreen(
                                  orgId: widget.orgId,
                                  member: widget.member,
                                ),
                              ),
                            ),
                          );
                        },
                  icon: SvgPicture.asset('assets/icons/arrow_up_box.svg'),
                  label: const Text('Send'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    visualDensity: const VisualDensity(vertical: -1),
                    textStyle:
                        Theme.of(context).textTheme.bodySmall?.copyWith(),
                  ),
                ),
                const SizedBox(width: 5),
                ElevatedButton.icon(
                  onPressed: widget.isPreviewMode
                      ? null
                      : () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ReceiveMoneyPaymentTypeScreen(
                                          organization: org)));
                        },
                  icon: SvgPicture.asset('assets/icons/arrow_down_box.svg'),
                  label: const Text('Receive'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    visualDensity: const VisualDensity(vertical: -1),
                    backgroundColor: BTN_BLUE_BG,
                    textStyle:
                        Theme.of(context).textTheme.bodySmall?.copyWith(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  buildDetails(BuildContext context, Organization org) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          org.name!,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 5),
        if (org.link != null)
          Row(
            children: [
              TextButton.icon(
                onPressed: () async {
                  final url = Uri.parse(org.link!);
                  if (!(await launchUrl(url))) {
                    throw Exception('Could not launch $url');
                  }
                },
                icon: const Icon(Icons.link),
                label: Text(org.link!),
                style: TextButton.styleFrom(
                  iconColor: COLOR_BLUE,
                  foregroundColor: COLOR_BLUE,
                ),
              )
            ],
          ),
        const SizedBox(height: 20),
        if (org.description != null)
          Text(
            org.description!,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
      ],
    );
  }

  buildMember(OrganizationMemberWithEquity data) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: const Color(0xffe2e2e8),
                borderRadius: BorderRadius.circular(30),
              ),
              clipBehavior: Clip.antiAlias,
              child: FittedBox(
                fit: BoxFit.cover,
                child: data.member!.user.avatar != null
                    ? FutureBuilder(
                        future: usersApi.getAvatar(data.member!.user.avatar),
                        builder: (_, snapshot) {
                          if (!snapshot.hasData) return Container();
                          return Image.memory(snapshot.data!);
                        },
                      )
                    : Container(),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              data.member!.user.nickname,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        FutureBuilder(
          future: data.futureEquity,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            return Positioned(
              top: -5,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: COLOR_ALMOST_BLACK,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Text(
                  '${(snapshot.data!.equity! * 100).toStringAsFixed(1)}%',
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: COLOR_WHITE),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  buildMembers(
    BuildContext context,
    Organization org,
    List<OrganizationMemberWithEquity> members,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppPadding(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${members.length} Members',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              InkWell(
                child: const Text('View Details',
                    style: TextStyle(
                        fontSize: 14,
                        color: COLOR_BLUE,
                        fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => OrgMemebersDetails(
                                memebersWithEquity: members,
                              )));
                },
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
                        onTap: widget.isPreviewMode
                            ? null
                            : () => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => OfferNewMemberScreen(
                                                organization: org,
                                              )))
                                },
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
                            buildMember(member),
                            if (i != members.length - 1)
                              const SizedBox(width: 10),
                            if (i == members.length - 1)
                              const SizedBox(width: 20),
                          ],
                        ));
                  })
                  .values
                  .toList(),
            ],
          ),
        ),
      ],
    );
  }

  getContributionDuration(OrgEventsHistoryItem item) {
    final startDate = DateTime.parse(item.createdAt!);
    final stopDate = DateTime.parse(item.stoppedAt!);
    final diff = stopDate.difference(startDate);
    return (diff.inMilliseconds / 1000 / 60 / 60)
        .toStringAsFixed(2)
        .replaceAll(trimZeroesRegExp, '');
  }

  buildPulseItem(
    BuildContext context,
    OrgEventsHistoryItem item,
    OrgEventsHistoryItem? prevItem,
  ) {
    Text? trailingText;
    final trailingTextStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: COLOR_WHITE,
        );
    if (item.action == OrgHistoryItemAction.Contributed) {
      final duration = getContributionDuration(item);
      trailingText = Text(
        '+ ${duration}h',
        style: trailingTextStyle,
      );
    }
    final primaryColor = item.action == OrgHistoryItemAction.Contributed
        ? COLOR_ALMOST_BLACK
        : COLOR_BLUE;
    final icon = Icon(
      item.action == OrgHistoryItemAction.Contributed
          ? CupertinoIcons.clock
          : Icons.add,
      color: COLOR_WHITE,
      size: 12,
    );
    final title = item.user?.nickname;
    final date =
        item.date != null ? DateTime.parse(item.date!) : DateTime.now();
    final processedAtStr = getFormattedDate(date);
    bool shouldDisplayDate = true;
    if (prevItem != null) {
      final prevDate = prevItem.date != null
          ? DateTime.parse(prevItem.date!)
          : DateTime.now();
      final prevProcessedAtStr = getFormattedDate(prevDate);
      shouldDisplayDate = prevProcessedAtStr != processedAtStr;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (shouldDisplayDate)
          Column(
            children: [
              Text(
                processedAtStr,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: COLOR_GRAY,
                    ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        GenericListTile(
          title: title,
          subtitle: item.action!.name,
          image: item.user?.avatar != null
              ? NetworkImageAuth(
                  imageUrl: '${usersApi.baseUrl}${item.user?.avatar}')
              : Image.asset('assets/images/avatar_placeholder.png'),
          trailingText: trailingText,
          primaryColor: primaryColor,
          icon: icon,
        ),
      ],
    );
  }

  handleStartContributingPressed() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response =
          await orgsApi.startContribution(widget.orgId, widget.member.id!);
      final contribution = Contribution.fromJson(response.data);
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => ContributionScreen(
              contribution: contribution,
              showSnackBar: true,
            ),
          ),
          (route) => false,
        );
      }
    } catch (error) {
      print(error);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: Future.wait([
        futureOrg,
        futureMembers,
      ]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            backgroundColor: APP_BODY_BG,
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return Scaffold(
          backgroundColor: APP_BODY_BG,
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            title: Text('@${snapshot.data?[0].username}'),
            actions: [
              IconButton(
                onPressed: widget.isPreviewMode
                    ? null
                    : () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => OrgSettingsScreen(
                              organization: snapshot.data![0],
                            ),
                          ),
                        );
                      },
                icon: const Icon(Icons.settings_outlined),
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CustomScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          slivers: [
                            CupertinoSliverRefreshControl(
                              onRefresh: onRefresh,
                            ),
                            SliverPersistentHeader(
                              pinned: true,
                              delegate: _HeaderDelegate(
                                child: Container(
                                  color: APP_BODY_BG,
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 20),
                                      AppPadding(
                                        child: buildHeader(
                                            context, snapshot.data?[0]),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 15),
                                  AppPadding(
                                    child: buildDetails(
                                        context, snapshot.data?[0]),
                                  ),
                                ],
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: Column(
                                children: [
                                  const SizedBox(height: 60),
                                  buildMembers(context, snapshot.data?[0],
                                      snapshot.data?[1]),
                                ],
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: AppPadding(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 40),
                                    Text(
                                      'Pulse',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 25),
                                  ],
                                ),
                              ),
                            ),
                            FutureBuilder(
                              future: futureHistory,
                              builder: (_, snapshot) {
                                if (!snapshot.hasData) {
                                  return const SliverToBoxAdapter(
                                    child: Center(
                                      child:
                                          CircularProgressIndicator.adaptive(),
                                    ),
                                  );
                                }
                                return SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      return AppPadding(
                                        child: Column(
                                          children: [
                                            buildPulseItem(
                                              context,
                                              snapshot.data![index],
                                              index > 0
                                                  ? snapshot.data![index - 1]
                                                  : null,
                                            ),
                                            const SizedBox(height: 20),
                                          ],
                                        ),
                                      );
                                    },
                                    childCount: snapshot.data!.length,
                                  ),
                                );
                              },
                            ),
                            const SliverToBoxAdapter(
                              child: SizedBox(height: 80),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 30,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: SizedBox(
                            width: 290,
                            child: ElevatedButton(
                              onPressed: isLoading ||
                                      widget.member.role ==
                                          MemberRole.Investor ||
                                      widget.isPreviewMode
                                  ? null
                                  : handleStartContributingPressed,
                              child: isLoading
                                  ? const Center(
                                      child:
                                          CircularProgressIndicator.adaptive())
                                  : const Text('Start Contributing'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _HeaderDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 140;

  @override
  double get minExtent => 140;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
