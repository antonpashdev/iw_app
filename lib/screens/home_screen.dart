import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iw_app/api/auth_api.dart';
import 'package:iw_app/api/orgs_api.dart';
import 'package:iw_app/api/users_api.dart';
import 'package:iw_app/l10n/generated/app_localizations.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/models/user_model.dart';
import 'package:iw_app/screens/organization/create_org_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/components/org_member_card.dart';
import 'package:iw_app/widgets/list/assets_list_tile.dart';
import 'package:iw_app/widgets/utils/app_padding.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<int> assets = [];
  late Future<User> futureUser;
  late Future<List<OrganizationMemberWithOtherMembers>> futureMembers;
  List<OrganizationMemberWithOtherMembers> members = [];

  @override
  void initState() {
    super.initState();
    futureUser = fetchUser();
    futureMembers = fetchMembers();
  }

  Future<User> fetchUser() =>
      authApi.getMe().then((response) => User.fromJson(response.data));

  Future<List<OrganizationMemberWithOtherMembers>> fetchMembers() async {
    final userId = await authApi.userId;
    final response = await usersApi.getUserMemberships(userId!);
    final members = (response.data as List).map((member) {
      final m = OrganizationMember.fromJson(member);
      final futureOtherMembers = fetchOtherMembers(m.org.id);
      final memberWithOther = OrganizationMemberWithOtherMembers(
        member: m,
        futureOtherMembers: futureOtherMembers,
      );
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

  Widget buildCallToCreateCard(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 20),
        OrgMemberCard(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CreateOrgScreen()));
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
    return Row(
      children: [
        const SizedBox(width: 20),
        OrgMemberCard(
          member: member,
          futureOtherMembers: futureOtherMembers,
        ),
        if (isLast) const SizedBox(width: 20),
      ],
    );
  }

  buildAssetExample() {
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
      tokensAmount: '-',
      equity: '-',
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: COLOR_WHITE,
        appBar: AppBar(
          title: FutureBuilder(
            future: futureUser,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              }
              final user = snapshot.data;

              return Row(
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
                      child: Image.memory(
                        user!.image!,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(user.nickname),
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
        ),
        body: FutureBuilder(
            future: futureMembers,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView(
                padding: const EdgeInsets.symmetric(vertical: 10),
                children: [
                  AppPadding(
                    child: Text(
                      '\$0.00',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  const SizedBox(height: 45),
                  AppPadding(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!
                              .homeScreen_organizationsTitle,
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        if (members.isNotEmpty)
                          InkWell(
                            borderRadius: BorderRadius.circular(30),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => const CreateOrgScreen()));
                            },
                            child:
                                SvgPicture.asset('assets/icons/add_circle.svg'),
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
                    child: buildAssetExample(),
                  ),
                  if (assets.isEmpty)
                    AppPadding(
                      child: Column(
                        children: [
                          const SizedBox(height: 15),
                          SvgPicture.asset('assets/icons/arrow_up_big.svg'),
                          const SizedBox(height: 15),
                          Text(
                            AppLocalizations.of(context)!
                                .homeScreen_assetsExampleDesc,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            }),
      ),
    );
  }
}
