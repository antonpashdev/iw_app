import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iw_app/api/auth_api.dart';
import 'package:iw_app/api/users_api.dart';
import 'package:iw_app/models/user_model.dart';
import 'package:iw_app/screens/account/send_money_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/utils/app_padding.dart';

class AccountDetailsScreen extends StatefulWidget {
  const AccountDetailsScreen({Key? key}) : super(key: key);

  @override
  State<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  late Future<User?> futureUser;
  late Future<double> futureBalance;

  @override
  void initState() {
    futureUser = fetchUser();
    futureBalance = fetchBalance();
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
        user.nickname,
        style: const TextStyle(fontWeight: FontWeight.normal),
      ),
    ];
  }

  buildBalance() {
    return FutureBuilder(
      future: futureBalance,
      builder: (_, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator.adaptive();
        }
        return Text(
          '\$${snapshot.data!.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.headlineLarge,
        );
      },
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
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => SendMoneyScreen(user: user)));
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
        const SizedBox(height: 15),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 330),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Image.asset('assets/images/iw_card.png', width: 50),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FutureBuilder(
                            future: futureBalance,
                            builder: (_, snapshot) {
                              double amount = 0;
                              if (snapshot.hasData) {
                                amount = snapshot.data!;
                              }
                              return Text(
                                '\$${amount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
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
                  bottom: 20,
                  right: 20,
                  child: Text(
                    'Coming Soon...',
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: COLOR_BLUE, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureUser,
      builder: (_, snapshot) {
        return Scaffold(
          backgroundColor: COLOR_WHITE,
          appBar: AppBar(
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
          ),
          body: FutureBuilder(
            future: futureUser,
            builder: (_, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              return Column(
                children: [
                  const SizedBox(height: 10),
                  Center(child: buildBalance()),
                  const SizedBox(height: 10),
                  AppPadding(
                    child: buildWalletSection(context, snapshot.data!),
                  )
                ],
              );
            },
          ),
        );
      },
    );
  }
}
