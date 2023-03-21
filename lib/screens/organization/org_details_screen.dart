import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iw_app/api/orgs_api.dart';
import 'package:iw_app/models/contribution_model.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/screens/contribution/contribution_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/utils/app_padding.dart';

class OrgDetailsScreen extends StatefulWidget {
  final String orgId;
  final String memberId;

  const OrgDetailsScreen({
    Key? key,
    required this.orgId,
    required this.memberId,
  }) : super(key: key);

  @override
  State<OrgDetailsScreen> createState() => _OrgDetailsScreenState();
}

class _OrgDetailsScreenState extends State<OrgDetailsScreen> {
  late Future<Organization> futureOrg;
  late Future<List<OrganizationMember>> futureMembers;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    futureOrg = fetchOrg();
    futureMembers = fetchMembers();
  }

  Future<Organization> fetchOrg() async {
    final response = await orgsApi.getOrgById(widget.orgId);
    return Organization.fromJson(response.data);
  }

  Future<List<OrganizationMember>> fetchMembers() async {
    final response = await orgsApi.getOrgMembers(widget.orgId);
    return (response.data as List)
        .map((member) => OrganizationMember.fromJson(member))
        .toList();
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
            child: Image.memory(org.logo!),
          ),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '\$0.00',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
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
                  onPressed: () {},
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
                onPressed: () {},
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

  buildMember(OrganizationMember member) {
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
                child: Image.memory(member.user.image),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              member.user.nickname,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Positioned(
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
              '0%',
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: COLOR_WHITE),
            ),
          ),
        ),
      ],
    );
  }

  buildMembers(
    BuildContext context,
    Organization org,
    List<OrganizationMember> members,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${members.length} Members',
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        Row(
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
                  child: const InkWell(
                    child: Icon(
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
                        ],
                      ));
                })
                .values
                .toList(),
          ],
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
          await orgsApi.startContribution(widget.orgId, widget.memberId);
      final contribution = Contribution.fromJson(response.data);
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (_) => ContributionScreen(contribution: contribution)),
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
              ),
              body: AppPadding(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          const SizedBox(height: 20),
                          buildHeader(context, snapshot.data?[0]),
                          const SizedBox(height: 25),
                          buildDetails(context, snapshot.data?[0]),
                          const SizedBox(height: 60),
                          buildMembers(
                              context, snapshot.data?[0], snapshot.data?[1]),
                          const SizedBox(height: 50),
                          buildPulse(context, snapshot.data?[0]),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed:
                          isLoading ? null : handleStartContributingPressed,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (isLoading)
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator.adaptive(),
                            ),
                          const Text('Start Contributing'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
