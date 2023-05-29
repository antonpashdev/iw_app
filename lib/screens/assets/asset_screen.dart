import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iw_app/api/orgs_api.dart';
import 'package:iw_app/api/users_api.dart';
import 'package:iw_app/constants/send_asset_type.dart';
import 'package:iw_app/models/config_model.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/models/txn_history_item_model.dart';
import 'package:iw_app/screens/assets/sell_asset_screen.dart';
import 'package:iw_app/screens/assets/send/send_type_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/utils/datetime.dart';
import 'package:iw_app/widgets/list/generic_list_tile.dart';
import 'package:iw_app/widgets/media/network_image_auth.dart';
import 'package:iw_app/widgets/state/config.dart';
import 'package:iw_app/widgets/utils/app_padding.dart';

import 'send/receiver_screen.dart';

const LAMPORTS_IN_SOL = 1000000000;
RegExp trimZeroesRegExp = RegExp(r'([.]*0+)(?!.*\d)');

class AssetScreen extends StatefulWidget {
  final OrganizationMemberWithEquity memberWithEquity;

  const AssetScreen({super.key, required this.memberWithEquity});

  @override
  State<AssetScreen> createState() => _AssetScreenState();
}

class _AssetScreenState extends State<AssetScreen> {
  late Future<MemberEquity?> futureEquity;
  late Future<List<TxnHistoryItem>> futureHistory;

  Config get config => ConfigState.of(context).config;

  @override
  initState() {
    super.initState();
    futureEquity = Future.value(widget.memberWithEquity.equity!);
    futureHistory = fetchHistory();
  }

  Future<MemberEquity?> fetchEquity() async {
    if (config.mode == Mode.Lite) {
      return Future.value(
        MemberEquity(
          lamportsEarned: 0,
          equity: widget.memberWithEquity.member!.equity?.amount ?? 0,
        ),
      );
    }
    try {
      final response = await orgsApi.getMemberEquity(
        widget.memberWithEquity.member!.org.id,
        widget.memberWithEquity.member!.id!,
      );
      return MemberEquity.fromJson(response.data);
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<List<TxnHistoryItem>> fetchHistory() async {
    final response =
        await usersApi.getAssetHistory(widget.memberWithEquity.member!.org.id);
    final List<TxnHistoryItem> history = [];
    for (final item in response.data) {
      history.add(TxnHistoryItem.fromJson(item));
    }
    return history;
  }

  Future onRefresh() {
    setState(() {
      futureEquity = fetchEquity();
      futureHistory = fetchHistory();
    });
    return Future.wait([futureEquity, futureHistory]);
  }

  buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: COLOR_GRAY,
            borderRadius: BorderRadius.circular(20),
          ),
          clipBehavior: Clip.antiAlias,
          child: FittedBox(
            fit: BoxFit.cover,
            child: NetworkImageAuth(
              imageUrl:
                  '${orgsApi.baseUrl}${widget.memberWithEquity.member!.org.logo!}',
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.memberWithEquity.member!.org.name}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '@${widget.memberWithEquity.member!.org.username}',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: COLOR_GRAY,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  buildAmount(
    BuildContext context,
    String title,
    String amount,
    Color color,
    Color bgColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            amount,
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }

  buildAmounts(BuildContext context, MemberEquity? memberEquity) {
    if (memberEquity == null) {
      return Container();
    }
    final tokensAmount = (memberEquity.lamportsEarned! / LAMPORTS_IN_SOL)
        .toStringAsFixed(4)
        .replaceAll(trimZeroesRegExp, '');
    String equityStr;
    if (config.mode == Mode.Lite) {
      equityStr = memberEquity.equity!.toStringAsFixed(1);
    } else {
      equityStr = (memberEquity.equity! * 100).toStringAsFixed(1);
    }
    return Row(
      children: [
        if (config.mode == Mode.Pro)
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: buildAmount(
                    context,
                    'Impact Shares',
                    tokensAmount,
                    COLOR_BLUE,
                    COLOR_LIGHT_GRAY,
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
        Expanded(
          child: buildAmount(
            context,
            'Equity',
            '$equityStr%',
            COLOR_GREEN,
            const Color(0xffb2e789).withAlpha(100),
          ),
        ),
      ],
    );
  }

  buildHistoryItem(
      BuildContext context, TxnHistoryItem item, TxnHistoryItem? prevItem) {
    final sign = item.amount != null && item.amount! < 0 ? '-' : '+';
    final unit = config.mode == Mode.Pro ? ' iS' : '%';
    final amount = item.amount != null
        ? '$sign ${(item.amount!.abs() / LAMPORTS_IN_SOL).toStringAsFixed(3)}$unit'
        : '-';
    final title = item.addressOrUsername!.length == 44
        ? item.addressOrUsername!.replaceRange(4, 40, '...')
        : item.addressOrUsername!;
    final isEarned = item.description != null &&
        item.description!.contains(RegExp('(Earned)|(Received for.*%)'));
    final icon = Icon(
      item.amount != null && item.amount! < 0
          ? Icons.arrow_outward_rounded
          : isEarned
              ? Icons.handyman_rounded
              : Icons.arrow_downward_rounded,
      size: 12,
      color: COLOR_WHITE,
    );
    final primaryColor = item.amount != null && item.amount! < 0
        ? COLOR_ALMOST_BLACK
        : isEarned
            ? COLOR_PURPLE
            : COLOR_GREEN;
    final processedAt = item.processedAt != null
        ? DateTime.fromMillisecondsSinceEpoch(item.processedAt!)
        : DateTime.now();
    final processedAtStr = getFormattedDate(processedAt);
    bool shouldDisplayDate = true;
    if (prevItem != null) {
      final prevProcessedAt = prevItem.processedAt != null
          ? DateTime.fromMillisecondsSinceEpoch(prevItem.processedAt!)
          : DateTime.now();
      final prevProcessedAtStr = getFormattedDate(prevProcessedAt);
      shouldDisplayDate = prevProcessedAtStr != processedAtStr;
    }
    return AppPadding(
      child: Column(
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
            subtitle: item.description,
            image: item.img != null
                ? NetworkImageAuth(imageUrl: '${usersApi.baseUrl}${item.img}')
                : Image.asset('assets/images/avatar_placeholder.png'),
            trailingText: Text(
              amount,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: COLOR_WHITE,
                  ),
            ),
            icon: icon,
            primaryColor: primaryColor,
          ),
        ],
      ),
    );
  }

  handleSendAssetPressed() {
    if (config.mode == Mode.Pro) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SendTypeScreen(
            organization: widget.memberWithEquity.member!.org,
            member: widget.memberWithEquity.member!,
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ReceiverScreen(
            organization: widget.memberWithEquity.member!.org,
            member: widget.memberWithEquity.member!,
            sendAssetType: SendAssetType.ToUser,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: APP_BODY_BG,
      appBar: AppBar(title: const Text('Asset')),
      body: SafeArea(
        child: FutureBuilder(
            future: futureEquity,
            builder: (context, snapshot) {
              return Column(
                children: [
                  Expanded(
                    child: CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        CupertinoSliverRefreshControl(
                          onRefresh: onRefresh,
                        ),
                        SliverPersistentHeader(
                          pinned: true,
                          delegate: _HeaderDelegate(
                            equity: snapshot.data,
                            child: Container(
                              color: COLOR_WHITE,
                              child: AppPadding(
                                child: Column(
                                  children: [
                                    const SizedBox(height: 10),
                                    buildHeader(context),
                                    const SizedBox(height: 20),
                                    buildAmounts(context, snapshot.data),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: AppPadding(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Activity',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                                const SizedBox(height: 30),
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
                                  child: CircularProgressIndicator.adaptive(),
                                ),
                              );
                            }
                            return SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) => Column(
                                  children: [
                                    buildHistoryItem(
                                      context,
                                      snapshot.data![index],
                                      index > 0
                                          ? snapshot.data![index - 1]
                                          : null,
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                                childCount: snapshot.data!.length,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  AppPadding(
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: snapshot.data!.equity == 0
                                ? null
                                : handleSendAssetPressed,
                            child: const Text('Send Asset'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: snapshot.data!.equity == 0
                                ? null
                                : () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (_) => SellAssetScreen(
                                                  organization: widget
                                                      .memberWithEquity
                                                      .member!
                                                      .org,
                                                  member: widget
                                                      .memberWithEquity.member!,
                                                )));
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: COLOR_BLUE,
                            ),
                            child: const Text('Sell Asset'),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            }),
      ),
    );
  }
}

class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  final MemberEquity? equity;
  final Widget child;

  _HeaderDelegate({required this.equity, required this.child});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  double get maxExtent => 190;

  @override
  double get minExtent => 190;

  @override
  bool shouldRebuild(_HeaderDelegate oldDelegate) {
    return oldDelegate.equity != equity;
  }
}
