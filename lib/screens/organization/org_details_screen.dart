import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iw_app/api/models/send_money_data_model.dart';
import 'package:iw_app/api/orgs_api.dart';
import 'package:iw_app/api/users_api.dart';
import 'package:iw_app/models/contribution_model.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/screens/contribution/contribution_screen.dart';
import 'package:iw_app/screens/offer/offer_new_member_screen.dart';
import 'package:iw_app/screens/organization/org_settings_screen.dart';
import 'package:iw_app/screens/organization/receive_money_payment_type_screen.dart';
import 'package:iw_app/screens/send_money/send_money_recipient_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/media/network_image_auth.dart';
import 'package:iw_app/widgets/utils/app_padding.dart';
import 'package:url_launcher/url_launcher.dart';

class OrgDetailsScreen extends StatefulWidget {
  final String orgId;
  final OrganizationMember member;

  const OrgDetailsScreen({
    Key? key,
    required this.orgId,
    required this.member,
  }) : super(key: key);

  @override
  State<OrgDetailsScreen> createState() => _OrgDetailsScreenState();
}

class _OrgDetailsScreenState extends State<OrgDetailsScreen> {
  late Future<Organization> futureOrg;
  late Future<List<OrganizationMemberWithEquity>> futureMembers;
  late Future<double> futureBalance;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    futureOrg = fetchOrg();
    futureMembers = fetchMembers();
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

  Future<MemberEquity> fetchMemberEquity(OrganizationMember member) async {
    final response = await orgsApi.getMemberEquity(member.org, member.id!);
    return MemberEquity.fromJson(response.data);
  }

  Future<double> fetchBalance(String orgId) async {
    final response = await orgsApi.getBalance(orgId);
    return response.data['balance'];
  }

  Future onRefresh() {
    setState(() {
      futureOrg = fetchOrg();
      futureMembers = fetchMembers();
    });
    return Future.wait([futureOrg, futureMembers, futureBalance]);
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
            const SizedBox(height: 15),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
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
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReceiveMoneyPaymentTypeScreen(
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
          child: Text(
            '${members.length} Members',
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold),
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
                        onTap: () => {
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

  buildPulse(BuildContext context, Organization org) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pulse',
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 25),
        ListTile(
          contentPadding: const EdgeInsets.all(0),
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: COLOR_GRAY,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          title: const Text(
            '@account',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            'Joined',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: COLOR_GRAY),
          ),
          trailing: Text(
            '2 min ago',
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(color: COLOR_GRAY),
          ),
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
    return SafeArea(
      child: FutureBuilder<List<dynamic>>(
          future: Future.wait([
            futureOrg,
            futureMembers,
          ]),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Scaffold(
                backgroundColor: COLOR_WHITE,
                body: Center(child: CircularProgressIndicator()),
              );
            }
            return Scaffold(
              backgroundColor: COLOR_WHITE,
              appBar: AppBar(
                title: Text('@${snapshot.data?[0].username}'),
                actions: [
                  IconButton(
                    onPressed: () {
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
              body: Column(
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
                              SliverList(
                                delegate: SliverChildListDelegate.fixed(
                                  [
                                    const SizedBox(height: 20),
                                    AppPadding(
                                      child: buildHeader(
                                          context, snapshot.data?[0]),
                                    ),
                                    const SizedBox(height: 25),
                                    AppPadding(
                                      child: buildDetails(
                                          context, snapshot.data?[0]),
                                    ),
                                    const SizedBox(height: 60),
                                    buildMembers(context, snapshot.data?[0],
                                        snapshot.data?[1]),
                                    const SizedBox(height: 50),
                                    AppPadding(
                                      child: buildPulse(
                                          context, snapshot.data?[0]),
                                    ),
                                    const SizedBox(height: 90),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
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
                                            MemberRole.Investor
                                    ? null
                                    : handleStartContributingPressed,
                                child: isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator
                                            .adaptive())
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
            );
          }),
    );
  }
}
