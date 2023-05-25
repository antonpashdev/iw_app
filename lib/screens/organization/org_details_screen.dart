import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iw_app/api/models/send_money_data_model.dart';
import 'package:iw_app/api/orgs_api.dart';
import 'package:iw_app/api/users_api.dart';
import 'package:iw_app/models/config_model.dart';
import 'package:iw_app/models/contribution_model.dart';
import 'package:iw_app/models/org_events_history_item_model.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/screens/contribution/contribution_memo_screen.dart';
import 'package:iw_app/screens/contribution/contribution_screen.dart';
import 'package:iw_app/screens/offer/offer_new_member_screen.dart';
import 'package:iw_app/screens/organization/members_details_lite_screen.dart';
import 'package:iw_app/screens/organization/members_details_screen.dart';
import 'package:iw_app/screens/organization/org_settings_screen.dart';
import 'package:iw_app/screens/organization/receive_money_payment_type_screen.dart';
import 'package:iw_app/screens/send_money/send_money_recipient_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/utils/datetime.dart';
import 'package:iw_app/utils/numbers.dart';
import 'package:iw_app/widgets/list/generic_list_tile.dart';
import 'package:iw_app/widgets/media/network_image_auth.dart';
import 'package:iw_app/widgets/state/config.dart';
import 'package:iw_app/widgets/utils/app_padding.dart';
import 'package:url_launcher/url_launcher.dart';

RegExp trimZeroesRegExp = RegExp(r'(\d*[.]0+)(?!.*\d)');

class OrgDetailsScreen extends StatefulWidget {
  final String orgId;
  final OrganizationMember? member;
  final bool isPreviewMode;

  const OrgDetailsScreen({
    Key? key,
    required this.orgId,
    this.member,
    this.isPreviewMode = false,
  }) : super(key: key);

  @override
  State<OrgDetailsScreen> createState() => _OrgDetailsScreenState();
}

class _OrgDetailsScreenState extends State<OrgDetailsScreen> {
  late Future<Organization> futureOrg;
  late Future<List<OrganizationMemberWithEquity>> futureMembers;
  Future<double>? futureBalance;
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
    if (!widget.isPreviewMode) {
      futureBalance = fetchBalance(org.id!);
    }
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
      if (!widget.isPreviewMode) {
        futureBalance = fetchBalance(widget.orgId);
      }
      futureHistory = fetchHistory();
    });
    final futures = [
      futureOrg,
      futureMembers,
      futureHistory,
    ];
    if (!widget.isPreviewMode) {
      futures.add(futureBalance!);
    }
    return Future.wait(futures);
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
            if (!widget.isPreviewMode)
              FutureBuilder(
                  future: futureBalance,
                  builder: (_, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator.adaptive();
                    }
                    return Text(
                      '\$${snapshot.data!.toString().replaceAll(trimZeroesRegExp, '')}',
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
        if (org.link != null && org.link!.isNotEmpty)
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
    Config config = ConfigState.of(context).config;
    return SizedBox(
      width: 100,
      child: Stack(
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
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          if (config.mode == Mode.Pro || data.member!.equity != null)
            FutureBuilder(
              future: config.mode == Mode.Pro
                  ? data.futureEquity
                  : Future.value(MemberEquity()),
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
                      config.mode == Mode.Pro
                          ? '${(snapshot.data!.equity! * 100).toStringAsFixed(1)}%'
                          : '${data.member!.equity!.amount!.toStringAsFixed(1)}%',
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
      ),
    );
  }

  onViewDetailsPressed(List<OrganizationMemberWithEquity> members) {
    Config config = ConfigState.of(context).config;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => config.mode == Mode.Pro
            ? OrgMemebersDetails(
                memebersWithEquity: members,
              )
            : OrgMemebersDetailsLite(
                memebersWithEquity: members,
              ),
      ),
    );
  }

  onAddMemberPressed(Organization org) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OfferNewMemberScreen(
          organization: org,
        ),
      ),
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
                      fontWeight: FontWeight.w600),
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
                        onTap: widget.isPreviewMode
                            ? null
                            : () => onAddMemberPressed(org),
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
                              child: buildMember(member),
                            ),
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
        .toStringAsFixed(3)
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
    final date = item.date != null
        ? DateTime.parse(item.date!).toLocal()
        : DateTime.now();
    final processedAtStr = getFormattedDate(date);
    bool shouldDisplayDate = true;
    if (prevItem != null) {
      final prevDate = prevItem.date != null
          ? DateTime.parse(prevItem.date!).toLocal()
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

  callSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 70,
          left: 20,
          right: 20,
        ),
        content: const Text('Copied to clipboard',
            textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
        duration: const Duration(milliseconds: 300),
        backgroundColor: Colors.black.withOpacity(0.7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  handleCopyPressed(String text) async {
    Clipboard.setData(ClipboardData(text: text));
    callSnackBar(context);
  }

  buildWalletSection(Organization org) {
    return Column(
      children: [
        Center(
          child: TextButton.icon(
            onPressed: () => handleCopyPressed(org.wallet!),
            style: const ButtonStyle(
              visualDensity: VisualDensity(vertical: 1),
            ),
            icon: SvgPicture.asset(
              'assets/icons/wallet.svg',
              width: 30,
            ),
            label: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Solana Address',
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: COLOR_GRAY, fontWeight: FontWeight.w500),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      org.wallet!.replaceRange(8, 36, '...'),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.copy,
                      size: 12,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  handleStartContributingPressed(Organization org) async {
    Config config = ConfigState.of(context).config;
    if (config.mode == Mode.Lite) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ContributionMemoScreen(
            contribution: Contribution(
              org: org,
            ),
          ),
        ),
      );
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      final response =
          await orgsApi.startContribution(widget.orgId, widget.member!.id!);
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
    Config config = ConfigState.of(context).config;
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
                                      buildWalletSection(snapshot.data?[0]),
                                      const SizedBox(height: 10),
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
                                      widget.isPreviewMode ||
                                      widget.member!.role == MemberRole.Investor
                                  ? null
                                  : () => handleStartContributingPressed(
                                        snapshot.data![0],
                                      ),
                              child: isLoading
                                  ? const Center(
                                      child:
                                          CircularProgressIndicator.adaptive())
                                  : Text(config.mode == Mode.Pro
                                      ? 'Start Contributing'
                                      : 'Tell what you\'ve done'),
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
  double get maxExtent => 180;

  @override
  double get minExtent => 180;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
