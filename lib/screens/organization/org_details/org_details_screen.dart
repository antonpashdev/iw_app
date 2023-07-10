import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iw_app/api/orgs_api.dart';
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
import 'package:iw_app/screens/organization/org_details/builders/details.dart';
import 'package:iw_app/screens/organization/org_details/builders/header.dart';
import 'package:iw_app/screens/organization/org_details/builders/members.dart';
import 'package:iw_app/screens/organization/org_details/builders/pulse_item.dart';
import 'package:iw_app/screens/organization/org_details/builders/wallet_section.dart';
import 'package:iw_app/screens/organization/org_details/fetchers.dart';
import 'package:iw_app/screens/organization/org_settings/org_settings_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/state/config.dart';
import 'package:iw_app/widgets/utils/app_padding.dart';

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
    futureOrg = fetchOrg(widget.orgId);
    futureMembers = fetchMembers(widget.orgId);
    futureHistory = fetchHistory(widget.orgId);

    if (!widget.isPreviewMode) {
      futureBalance = fetchBalance(widget.orgId);
    }
  }

  Future onRefresh() {
    setState(() {
      futureOrg = fetchOrg(widget.orgId);
      futureMembers = fetchMembers(widget.orgId);
      if (!widget.isPreviewMode) {
        futureBalance = fetchBalance(widget.orgId);
      }
      futureHistory = fetchHistory(widget.orgId);
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
                              member: widget.member!,
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
                                      buildWalletSection(
                                          context, snapshot.data?[0]),
                                      const SizedBox(height: 10),
                                      AppPadding(
                                        child: buildHeader(
                                          context,
                                          snapshot.data?[0],
                                          widget.member!,
                                          widget.isPreviewMode,
                                          futureBalance,
                                        ),
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
                                      context,
                                      snapshot.data?[0],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: Column(
                                children: [
                                  const SizedBox(height: 60),
                                  buildMembers(
                                    context,
                                    snapshot.data?[0],
                                    snapshot.data?[1],
                                    widget.member!,
                                    widget.isPreviewMode,
                                    onViewDetailsPressed,
                                    onAddMemberPressed,
                                  ),
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
                                            fontWeight: FontWeight.bold,
                                          ),
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
                                          CircularProgressIndicator.adaptive(),
                                    )
                                  : Text(
                                      config.mode == Mode.Pro
                                          ? 'Start Contributing'
                                          : 'Tell what you\'ve done',
                                    ),
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
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
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
