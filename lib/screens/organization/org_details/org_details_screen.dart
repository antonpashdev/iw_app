import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:iw_app/models/config_model.dart';
import 'package:iw_app/models/org_events_history_item_model.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/models/organization_model.dart';
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
import 'package:iw_app/widgets/components/app_bar_chart.dart';
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
  late Future<List<OrgEventsHistoryItem>> futureHistory;
  Future<String?>? futureBalance;
  Future<Map<String, dynamic>?>? futureRevenue;

  bool isLoading = false;
  String revenuePeriod = 'weekly';
  String chartPeriod = 'weekly';

  @override
  void initState() {
    super.initState();
    futureOrg = fetchOrg(widget.orgId);
    futureMembers = fetchMembers(widget.orgId);
    futureHistory = fetchHistory(widget.orgId);

    if (!widget.isPreviewMode) {
      futureBalance = fetchBalance(widget.orgId);
      futureRevenue = fetchRevenue(widget.orgId, revenuePeriod);
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
    final List<Future<Object?>> futures = [
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

  buildRevenuePeriodOption(String title, String period) {
    final btnStyle = TextButton.styleFrom(
      backgroundColor: COLOR_LIGHT_GRAY,
    );
    final textStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: COLOR_ALMOST_BLACK,
          fontWeight: FontWeight.bold,
        );
    return SizedBox(
      width: 38,
      height: 38,
      child: TextButton(
        style: btnStyle.copyWith(
          backgroundColor: MaterialStateProperty.all(
            revenuePeriod == period ? COLOR_ALMOST_BLACK : COLOR_LIGHT_GRAY,
          ),
        ),
        onPressed: () {
          setState(() {
            revenuePeriod = period;
            futureRevenue =
                fetchRevenue(widget.orgId, revenuePeriod).then((value) {
              chartPeriod = revenuePeriod;
              return value;
            });
          });
        },
        child: Text(
          title,
          style: textStyle.copyWith(
            color: revenuePeriod == period ? COLOR_WHITE : COLOR_ALMOST_BLACK,
          ),
        ),
      ),
    );
  }

  buildRevenuePeriodOptions() {
    return Row(
      children: [
        buildRevenuePeriodOption('H', 'hourly'),
        const SizedBox(width: 10),
        buildRevenuePeriodOption('D', 'daily'),
        const SizedBox(width: 10),
        buildRevenuePeriodOption('W', 'weekly'),
        const SizedBox(width: 10),
        buildRevenuePeriodOption('M', 'monthly'),
        const SizedBox(width: 10),
        buildRevenuePeriodOption('Q', 'quarterly'),
        const SizedBox(width: 10),
        buildRevenuePeriodOption('Y', 'yearly'),
      ],
    );
  }

  buildRevenue(Map<String, dynamic>? data) {
    if (data == null) {
      return const SizedBox();
    }
    final totalRevenue = data['total']['revenue'];
    if (totalRevenue == 0) {
      return const SizedBox();
    }
    final titleStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: COLOR_GRAY,
        );
    final valueStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.bold,
        );
    final formatter = NumberFormat('#,###.########');
    final List revenueForPeriod = data['period'];
    final last30DaysRevenue = data['last30Days']['revenue'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Total Revenue: ', style: titleStyle),
            Text('\$${formatter.format(totalRevenue)}', style: valueStyle),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Text('Revenue Last 30 Days: ', style: titleStyle),
            Text(
              '\$${formatter.format(last30DaysRevenue)}',
              style: valueStyle,
            ),
          ],
        ),
        const SizedBox(height: 20),
        buildRevenuePeriodOptions(),
        const SizedBox(height: 20),
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 500,
            maxHeight: 135,
          ),
          child: AppBarChart(
            items: revenueForPeriod.map((e) {
              String title;
              switch (chartPeriod) {
                case 'hourly':
                  final start = DateTime.parse(e['date']).toLocal();
                  final end = start.add(const Duration(hours: 1));
                  title =
                      '${DateFormat.H().format(start)}-${DateFormat.H().format(end)}';
                  break;
                case 'daily':
                  title = DateFormat('dd').format(
                    DateTime.parse(e['date']).toLocal(),
                  );
                  break;
                case 'weekly':
                  title = DateFormat('dd').format(
                    DateTime.parse(e['date']).toLocal(),
                  );
                  break;
                case 'quarterly':
                  title = DateFormat.QQQ().format(
                    DateTime.parse(e['date']).toLocal(),
                  );
                  break;
                case 'yearly':
                  title = DateFormat('yyyy').format(
                    DateTime.parse(e['date']).toLocal(),
                  );
                  break;
                case 'monthly':
                default:
                  title = DateFormat('MMM').format(
                    DateTime.parse(e['date']).toLocal(),
                  );
              }
              return AppBarChartItem(
                title: title,
                data: e['revenue'],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: Future.wait([
        futureOrg,
        futureMembers,
        futureRevenue ?? Future.value(null),
      ]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            backgroundColor: APP_BODY_BG,
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final revenueData = snapshot.data?[2];
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
                                        context,
                                        snapshot.data?[0],
                                      ),
                                      const SizedBox(height: 10),
                                      AppPadding(
                                        child: buildHeader(
                                          context,
                                          snapshot.data?[0],
                                          widget.member,
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
                            if (revenueData != null)
                              SliverToBoxAdapter(
                                child: AppPadding(
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 30),
                                      buildRevenue(revenueData),
                                    ],
                                  ),
                                ),
                              ),
                            SliverToBoxAdapter(
                              child: Column(
                                children: [
                                  const SizedBox(height: 45),
                                  buildMembers(
                                    context,
                                    snapshot.data?[0],
                                    snapshot.data?[1],
                                    widget.member,
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
