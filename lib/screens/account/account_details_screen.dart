import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iw_app/api/auth_api.dart';
import 'package:iw_app/api/models/send_money_data_model.dart';
import 'package:iw_app/api/users_api.dart';
import 'package:iw_app/models/txn_history_item_model.dart';
import 'package:iw_app/models/user_model.dart';
import 'package:iw_app/screens/send_money/send_money_recipient_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/utils/datetime.dart';
import 'package:iw_app/widgets/list/generic_list_tile.dart';
import 'package:iw_app/widgets/media/network_image_auth.dart';
import 'package:iw_app/widgets/utils/app_padding.dart';

const LAMPORTS_PER_USDC = 1000000;

class AccountDetailsScreen extends StatefulWidget {
  const AccountDetailsScreen({Key? key}) : super(key: key);

  @override
  State<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  late Future<User?> futureUser;
  late Future<double> futureBalance;
  late Future<List<TxnHistoryItem>> futureHistory;

  @override
  void initState() {
    futureUser = fetchUser();
    futureBalance = fetchBalance();
    futureHistory = fetchHistory();
    super.initState();
  }

  Future<User?> fetchUser() async {
    try {
      final response = await authApi.getMe();
      return User.fromJson(response.data);
    } catch (err) {
      print(err);
    }
    return null;
  }

  Future<double> fetchBalance() async {
    final response = await usersApi.getBalance();
    return response.data['balance'];
  }

  Future<List<TxnHistoryItem>> fetchHistory() async {
    final response = await usersApi.getUsdcHistory();
    final List<TxnHistoryItem> history = [];
    for (final item in response.data) {
      history.add(TxnHistoryItem.fromJson(item));
    }
    return history;
  }

  buildTitleShimmer() {
    return [
      Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: COLOR_LIGHT_GRAY,
        ),
      ),
      const SizedBox(width: 5),
      Container(
        width: 60,
        height: 10,
        decoration: const BoxDecoration(
          color: COLOR_LIGHT_GRAY,
        ),
      ),
    ];
  }

  buildTitle(User user) {
    return [
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
          child: user.avatar != null
              ? FutureBuilder(
                  future: usersApi.getAvatar(user.avatar!),
                  builder: (_, snapshot) {
                    if (!snapshot.hasData) return Container();
                    return Image.memory(snapshot.data!);
                  })
              : const Icon(
                  Icons.person,
                  color: Color(0xFFBDBDBD),
                ),
        ),
      ),
      const SizedBox(width: 10),
      Text(
        user.nickname!,
        style: const TextStyle(fontWeight: FontWeight.normal),
      ),
    ];
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

  buildWalletSection(BuildContext context, User user) {
    return Column(
      children: [
        Center(
          child: TextButton.icon(
            onPressed: () => handleCopyPressed(user.wallet!),
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
                      user.wallet!.replaceRange(8, 36, '...'),
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
        const SizedBox(height: 20),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 330),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => SendMoneyRecipientScreen(
                          senderWallet: user.wallet!,
                          onSendMoney: (SendMoneyData data) =>
                              usersApi.sendMoney(data),
                          originScreenFactory: () =>
                              const AccountDetailsScreen(),
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
              ),
              const SizedBox(width: 5),
              Expanded(
                child: ElevatedButton.icon(
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
              ),
            ],
          ),
        ),
      ],
    );
  }

  buildIWCard() {
    return AppPadding(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 330),
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 125,
                      height: 85,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: Image.asset(
                          'assets/images/iw_card.png',
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        FutureBuilder(
                          future: futureBalance,
                          builder: (_, snapshot) {
                            double amount = 0;
                            if (snapshot.hasData) {
                              amount = snapshot.data!;
                            }
                            return Text(
                              '\$${amount.toStringAsFixed(2)}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            );
                          },
                        ),
                        Text(
                          'Impact Wallet Card',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(color: COLOR_GRAY),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: COLOR_LIGHT_GRAY.withAlpha(150),
                  ),
                ),
              ),
              Positioned(
                bottom: 25,
                left: 155,
                child: Text(
                  'Coming Soon...',
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: COLOR_BLUE, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildHistoryItem(
      BuildContext context, TxnHistoryItem item, TxnHistoryItem? prevItem) {
    final sign = item.amount != null && item.amount! < 0 ? '-' : '+';
    final color = item.amount != null && item.amount! < 0
        ? COLOR_ALMOST_BLACK
        : COLOR_GREEN;
    final amount = item.amount != null
        ? '$sign \$${(item.amount!.abs() / LAMPORTS_PER_USDC).toStringAsFixed(2)} USDC'
        : '-';
    final title = item.addressOrUsername!.length == 44
        ? item.addressOrUsername!.replaceRange(4, 40, '...')
        : item.addressOrUsername!;
    final icon = Icon(
      item.amount != null && item.amount! < 0
          ? Icons.arrow_outward_rounded
          : Icons.arrow_downward_rounded,
      size: 12,
      color: COLOR_WHITE,
    );
    final primaryColor = item.amount != null && item.amount! < 0
        ? COLOR_ALMOST_BLACK
        : COLOR_BLUE;
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
            trailing: Text(
              amount,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color,
                  ),
            ),
            icon: icon,
            primaryColor: primaryColor,
          ),
        ],
      ),
    );
  }

  Future onRefresh() {
    setState(() {
      futureUser = fetchUser();
      futureBalance = fetchBalance();
      futureHistory = fetchHistory();
    });
    return Future.wait([futureUser, futureBalance, futureHistory]);
  }

  buildHeader(User user, double? balance) {
    return SliverPersistentHeader(
      key: Key(balance != null ? balance.toString() : 'na'),
      pinned: true,
      delegate: _HeaderDelegate(
        child: Container(
          color: COLOR_WHITE,
          child: Column(
            children: [
              const SizedBox(height: 10),
              Center(
                child: balance == null
                    ? const CircularProgressIndicator.adaptive()
                    : Text(
                        '\$${balance.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
              ),
              const SizedBox(height: 10),
              AppPadding(
                child: buildWalletSection(
                  context,
                  user,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureUser,
      builder: (_, snapshot) {
        return Scaffold(
          backgroundColor: APP_BODY_BG,
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            centerTitle: true,
            title: FutureBuilder(
              future: futureUser,
              builder: (context, snapshot) {
                final user = snapshot.data;
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        if (!snapshot.hasData) ...buildTitleShimmer(),
                        if (snapshot.hasData) ...buildTitle(user!)
                      ],
                    ),
                  ],
                );
              },
            ),
            titleTextStyle: const TextStyle(
              fontFamily: 'SF Pro Display',
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: COLOR_ALMOST_BLACK,
            ),
          ),
          body: FutureBuilder(
            future: futureUser,
            builder: (_, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final user = snapshot.data as User;
              return CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  CupertinoSliverRefreshControl(
                    onRefresh: onRefresh,
                  ),
                  FutureBuilder(
                    future: futureBalance,
                    builder: (_, snapshot) {
                      return buildHeader(user, snapshot.data);
                    },
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        buildIWCard(),
                        const SizedBox(height: 30),
                      ],
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
                                index > 0 ? snapshot.data![index - 1] : null,
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
              );
            },
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
  double get maxExtent => 200;

  @override
  double get minExtent => 200;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
