import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iw_app/api/auth_api.dart';
import 'package:iw_app/api/orgs_api.dart';
import 'package:iw_app/api/users_api.dart';
import 'package:iw_app/l10n/generated/app_localizations.dart';
import 'package:iw_app/models/config_model.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/models/user_model.dart';
import 'package:iw_app/screens/account/account_details_screen.dart';
import 'package:iw_app/screens/assets/asset_screen.dart';
import 'package:iw_app/screens/organization/create_org_screen.dart';
import 'package:iw_app/screens/organization/org_details_screen.dart';
import 'package:iw_app/screens/settings_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/utils/numbers.dart';
import 'package:iw_app/widgets/components/accounts_list.dart';
import 'package:iw_app/widgets/components/bottom_sheet_custom.dart';
import 'package:iw_app/widgets/components/org_member_card.dart';
import 'package:iw_app/widgets/components/org_member_card_lite.dart';
import 'package:iw_app/widgets/list/assets_list_tile.dart';
import 'package:iw_app/widgets/media/network_image_auth.dart';
import 'package:iw_app/widgets/state/config.dart';
import 'package:iw_app/widgets/utils/app_padding.dart';

const LAMPORTS_IN_SOL = 1000000000;

class HomeScreen extends StatefulWidget {
  final bool? isOnboarding;
  const HomeScreen({Key? key, this.isOnboarding}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<int> assets = [];
  late Future<User> futureUser;
  late Future<List<OrganizationMemberWithOtherMembers>> futureMembers;
  List<OrganizationMemberWithOtherMembers> members = [];
  late Future<double> futureBalance;

  @override
  void initState() {
    super.initState();
    futureUser = fetchUser();
    futureMembers = fetchMembers();
    futureBalance = fetchBalance();
  }

  Config get config => ConfigState.of(context).config;

  Future<User> fetchUser() =>
      authApi.getMe().then((response) => User.fromJson(response.data));

  Future<List<OrganizationMemberWithOtherMembers>> fetchMembers() async {
    final userId = await authApi.userId;
    final response = await usersApi.getUserMemberships(userId!);
    final members = (response.data as List).map((member) {
      final m = OrganizationMember.fromJson(member);
      final memberWithOther = OrganizationMemberWithOtherMembers(
        member: m,
      );
      final futureOtherMembers = fetchOtherMembers(m.org.id);
      final futureEquity = fetchMemberEquity(m.org.id, m.id!, memberWithOther);
      memberWithOther.futureOtherMembers = futureOtherMembers;
      memberWithOther.futureEquity = futureEquity;
      return memberWithOther;
    }).toList();
    this.members = members;
    return members;
  }

  Future<List<OrganizationMember>> fetchOtherMembers(String orgId) async {
    final response = await orgsApi.getOrgMembers(orgId);
    return (response.data as List)
        .map((member) => OrganizationMember.fromJson(member))
        .toList();
  }

  Future<MemberEquity> fetchMemberEquity(
    String orgId,
    String memberId,
    OrganizationMemberWithOtherMembers member,
  ) async {
    MemberEquity equity;
    if (config.mode == Mode.Lite) {
      equity = MemberEquity(
        lamportsEarned: 0,
        equity: member.member!.equity?.amount ?? 0,
      );
    } else {
      final response = await orgsApi.getMemberEquity(orgId, memberId);
      equity = MemberEquity.fromJson(response.data);
    }
    member.equity = equity;
    return equity;
  }

  Future<double> fetchBalance() async {
    final response = await usersApi.getBalance();
    return response.data['balance'];
  }

  Widget buildCallToCreateCard(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 20),
        OrgMemberCard(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const CreateOrgScreen()),
            );
          },
        ),
      ],
    );
  }

  buildOrganizationCard(
    BuildContext context,
    OrganizationMember member,
    Future<List<OrganizationMember>> futureOtherMembers,
    bool isFirst,
    bool isLast,
  ) {
    Config config = ConfigState.of(context).config;
    final card = config.mode == Mode.Pro
        ? OrgMemberCard(
            member: member,
            futureOtherMembers: futureOtherMembers,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => OrgDetailsScreen(
                    orgId: member.org.id,
                    member: member,
                  ),
                ),
              );
            },
          )
        : OrgMemberCardLite(
            member: member,
            futureOtherMembers: futureOtherMembers,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => OrgDetailsScreen(
                    orgId: member.org.id,
                    member: member,
                  ),
                ),
              );
            },
          );
    return Row(
      children: [
        const SizedBox(width: 20),
        card,
        if (isLast) const SizedBox(width: 20),
      ],
    );
  }

  buildAssetExample() {
    Config config = ConfigState.of(context).config;
    return AssetsListTile(
      leading: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: COLOR_LIGHT_GRAY2,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      name: AppLocalizations.of(context)!.homeScreen_assetsExampleTitle,
      account: '@orgs_account',
      tokensAmount: config.mode == Mode.Pro ? '-' : null,
      equity: '-',
    );
  }

  buildAsset(OrganizationMemberWithOtherMembers omm) {
    Config config = ConfigState.of(context).config;
    return FutureBuilder(
      future: config.mode == Mode.Pro
          ? omm.futureEquity
          : Future.value(MemberEquity()),
      builder: (_, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        String? tokensAmount;
        if (config.mode == Mode.Pro) {
          tokensAmount =
              trimZeros(snapshot.data!.lamportsEarned! / LAMPORTS_IN_SOL);
        }
        final equity = config.mode == Mode.Pro
            ? (snapshot.data!.equity! * 100).toStringAsFixed(1)
            : (omm.member!.equity!.amount!).toStringAsFixed(1);
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AssetScreen(memberWithEquity: omm),
              ),
            );
          },
          child: AssetsListTile(
            leading: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: COLOR_LIGHT_GRAY2,
                borderRadius: BorderRadius.circular(20),
              ),
              clipBehavior: Clip.antiAlias,
              child: FittedBox(
                fit: BoxFit.cover,
                child: NetworkImageAuth(
                  imageUrl: '${orgsApi.baseUrl}${omm.member!.org.logo}',
                ),
              ),
            ),
            name: omm.member!.org.name,
            account: '@${omm.member!.org.username}',
            tokensAmount: tokensAmount,
            equity: '$equity%',
          ),
        );
      },
    );
  }

  buildOrgsMembers(List<OrganizationMemberWithOtherMembers> members) {
    return members.isEmpty
        ? buildCallToCreateCard(context)
        : ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ...members
                  .asMap()
                  .map(
                    (i, member) => MapEntry(
                      i,
                      buildOrganizationCard(
                        context,
                        member.member!,
                        member.futureOtherMembers!,
                        i == 0,
                        i == members.length - 1,
                      ),
                    ),
                  )
                  .values
                  .toList()
            ],
          );
  }

  buildAssets(List<OrganizationMemberWithOtherMembers> members) {
    Config config = ConfigState.of(context).config;
    List<OrganizationMemberWithOtherMembers> assets = members;
    if (config.mode == Mode.Lite) {
      assets = members.where((m) => m.member!.equity != null).toList();
    }
    return Column(
      children: [
        ...assets.map((m) => buildAsset(m)).toList(),
      ],
    );
  }

  Future onRefresh() {
    setState(() {
      futureMembers = fetchMembers();
      futureBalance = fetchBalance();
    });
    return Future.wait([futureMembers, futureBalance]);
  }

  @override
  Widget build(BuildContext context) {
    Config config = ConfigState.of(context).config;
    return Scaffold(
      backgroundColor: APP_BODY_BG,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: FutureBuilder(
          future: futureUser,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            }
            final user = snapshot.data;

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: COLOR_GRAY,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: user?.avatar != null
                            ? FutureBuilder(
                                future: usersApi.getAvatar(user!.avatar!),
                                builder: (_, snapshot) {
                                  if (!snapshot.hasData) return Container();
                                  return Image.memory(snapshot.data!);
                                },
                              )
                            : const Icon(
                                Icons.person,
                                color: Color(0xFFBDBDBD),
                              ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(user?.nickname ?? ''),
                    IconButton(
                      onPressed: () {
                        showBottomSheetCustom(
                          context,
                          title: 'Accounts',
                          child: FutureBuilder(
                            future: futureUser,
                            builder: (builder, userSnapshot) {
                              if (!userSnapshot.hasData) return Container();
                              return FutureBuilder(
                                future: futureMembers,
                                builder: (builder, membersSnapshot) {
                                  if (!snapshot.hasData) {
                                    return Container();
                                  }
                                  return AccountsListWidget(
                                    currentUser: userSnapshot.data,
                                    orgs: membersSnapshot.data,
                                  );
                                },
                              );
                            },
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.keyboard_arrow_down_outlined,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
        centerTitle: false,
        titleTextStyle: const TextStyle(
          fontFamily: 'SF Pro Display',
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: COLOR_ALMOST_BLACK,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const SettingsSreen();
                  },
                ),
              );
            },
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: futureMembers,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                CupertinoSliverRefreshControl(
                  onRefresh: onRefresh,
                ),
                SliverList(
                  delegate: SliverChildListDelegate.fixed(
                    [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: AppPadding(
                          child: FutureBuilder(
                            future: futureBalance,
                            builder: (_, snapshot) {
                              if (!snapshot.hasData) {
                                return const CircularProgressIndicator
                                    .adaptive();
                              }
                              final balance = '\$${trimZeros(snapshot.data!)}';
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const AccountDetailsScreen(),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      balance,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                    ),
                                    const SizedBox(width: 10),
                                    const Icon(
                                      Icons.keyboard_arrow_down_outlined,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 45),
                      AppPadding(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              config.mode == Mode.Lite
                                  ? 'Orgs & Projects'
                                  : AppLocalizations.of(context)!
                                      .homeScreen_organizationsTitle,
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                            if (members.isNotEmpty)
                              InkWell(
                                borderRadius: BorderRadius.circular(30),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const CreateOrgScreen(),
                                    ),
                                  );
                                },
                                child: SvgPicture.asset(
                                  'assets/icons/add_circle.svg',
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 290,
                        child: buildOrgsMembers(snapshot.data!),
                      ),
                      const SizedBox(height: 45),
                      AppPadding(
                        child: Text(
                          AppLocalizations.of(context)!.homeScreen_assetsTitle,
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                      ),
                      const SizedBox(height: 15),
                      AppPadding(
                        child: snapshot.data!.isEmpty
                            ? buildAssetExample()
                            : buildAssets(snapshot.data!),
                      ),
                      if (snapshot.data!.isEmpty)
                        AppPadding(
                          child: Column(
                            children: [
                              const SizedBox(height: 15),
                              SvgPicture.asset(
                                'assets/icons/arrow_up_big.svg',
                              ),
                              const SizedBox(height: 15),
                              Text(
                                config.mode == Mode.Pro
                                    ? AppLocalizations.of(context)!
                                        .homeScreen_assetsExampleDesc
                                    : 'Your Assets will appear here when you create or join Organization or Project',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
