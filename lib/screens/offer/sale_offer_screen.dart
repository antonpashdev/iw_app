import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iw_app/api/auth_api.dart';
import 'package:iw_app/api/offers_api.dart';
import 'package:iw_app/api/orgs_api.dart';
import 'package:iw_app/api/users_api.dart';
import 'package:iw_app/app_home.dart';
import 'package:iw_app/app_storage.dart';
import 'package:iw_app/l10n/generated/app_localizations.dart';
import 'package:iw_app/models/account_model.dart';
import 'package:iw_app/models/config_model.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/models/payment_model.dart';
import 'package:iw_app/models/sale_offer_model.dart';
import 'package:iw_app/screens/organization/org_details/org_details_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/buttons/secondary_button.dart';
import 'package:iw_app/widgets/components/bottom_sheet_info.dart';
import 'package:iw_app/widgets/list/keyboard_dismissable_list.dart';
import 'package:iw_app/widgets/media/network_image_auth.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';
import 'package:iw_app/widgets/state/config.dart';
import 'package:url_launcher/url_launcher.dart';

const LAMPORTS_IN_SOL = 1000000000;

class SaleOfferScreen extends StatefulWidget {
  static String routeName = '/saleoffer';

  final String offerId;
  final bool? isBonusOnboarding;

  const SaleOfferScreen({
    Key? key,
    required this.offerId,
    this.isBonusOnboarding,
  }) : super(key: key);

  @override
  State<SaleOfferScreen> createState() => _SaleOfferScreenState();
}

class _SaleOfferScreenState extends State<SaleOfferScreen> {
  late Future<SaleOffer?> futureSaleOffer;
  late Future<Account?> futureAccount;
  late Future<Map<String, double?>> futureBalance;
  bool isLoading = false;
  Payment? payment;

  @override
  void initState() {
    futureSaleOffer = fetchSaleOffer();
    futureAccount = fetchAccount();
    futureBalance = fetchBalance();
    super.initState();
  }

  Future<Account?> fetchAccount() async {
    try {
      final response = await authApi.getMe();
      return Account.fromJson(response.data);
    } catch (err) {
      print(err);
    }
    return null;
  }

  Future<Map<String, double?>> fetchBalance() async {
    final response = await usersApi.getBalance();
    final balance =
        TokenAmount.fromJson(response.data['balance']['balance']).uiAmount;
    final bonusBalance = TokenAmount.fromJson(
          response.data['balance']['bonusBalance'],
        ).uiAmount ??
        0;

    return {
      'balance': balance,
      'bonusBalance': bonusBalance,
    };
  }

  Future<SaleOffer?> fetchSaleOffer() async {
    try {
      final response = await offersApi.getSaleOffer(widget.offerId);
      return SaleOffer.fromJson(response.data);
    } on DioError catch (err) {
      if (err.response?.statusCode == 401) {
        await appStorage.write(
          'redirect_to',
          '/saleoffer?i=${widget.offerId}',
        );
        if (mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppHome.routeName,
            (route) => false,
          );
        }
      }
      rethrow;
    } catch (e) {
      print(e);
    }

    return null;
  }

  buildHeader(BuildContext context, SaleOffer saleOffer) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OrgDetailsScreen(
              orgId: saleOffer.org.id,
              isPreviewMode: true,
            ),
          ),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            clipBehavior: Clip.antiAlias,
            child: FittedBox(
              fit: BoxFit.cover,
              child: NetworkImageAuth(
                imageUrl: '${orgsApi.baseUrl}${saleOffer.org.logo!}',
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${saleOffer.org.name}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '@${saleOffer.org.username}',
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: COLOR_GRAY,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: COLOR_ALMOST_BLACK,
          ),
        ],
      ),
    );
  }

  buildDetails(BuildContext context, SaleOffer? saleOffer) {
    if (saleOffer == null) {
      return Container();
    }
    Config config = ConfigState.of(context).config;
    final equity = ((saleOffer.tokensAmount! * LAMPORTS_IN_SOL) /
            saleOffer.org.lamportsMinted *
            100)
        .toStringAsFixed(1);
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: COLOR_LIGHT_GRAY,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          buildHeader(context, saleOffer),
          const SizedBox(height: 15),
          const Divider(
            color: COLOR_LIGHT_GRAY2,
            height: 1,
          ),
          const SizedBox(height: 20),
          if (config.mode == Mode.Pro)
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Number of Impact Shares'),
                    Text(
                      '${saleOffer.tokensAmount}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
              ],
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(config.mode == Mode.Pro ? 'Equity to Date' : 'Equity'),
              Text(
                '$equity%',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: COLOR_GREEN,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(
            color: COLOR_LIGHT_GRAY2,
            height: 1,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Price',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              Text(
                '\$${saleOffer.price}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ],
      ),
    );
  }

  buildFromDetails(BuildContext context, SaleOffer? saleOffer) {
    if (saleOffer == null) {
      return Container();
    }
    final imageUrl = saleOffer.seller!['avatar'] ?? saleOffer.seller!['logo'];
    final sellerUsername =
        saleOffer.seller!['nickname'] ?? saleOffer.seller!['username'];
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: COLOR_LIGHT_GRAY,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: COLOR_GRAY2,
                  borderRadius: BorderRadius.circular(15),
                ),
                clipBehavior: Clip.antiAlias,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: imageUrl != null
                      ? NetworkImageAuth(
                          imageUrl: '${usersApi.baseUrl}$imageUrl',
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      children: [
                        const TextSpan(
                          text: 'from',
                          style: TextStyle(color: COLOR_BLUE),
                        ),
                        TextSpan(
                          text: ' ${saleOffer.seller!['name']}',
                          style: const TextStyle(color: COLOR_ALMOST_BLACK),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '@$sellerUsername',
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color: COLOR_GRAY,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> openPaymentLink(String link) async {
    final url = Uri.parse(link);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  handleBuyPressed(SaleOffer? offer) {
    if (offer == null) {
      return;
    }
    Config config = ConfigState.of(context).config;
    showBottomInfoSheet(
      context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Confirm to send money.',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Gilroy',
            ),
          ),
          const SizedBox(height: 15),
          Text(
            config.mode == Mode.Lite
                ? 'By signing this transaction you will get ${offer.tokensAmount}% of equity of @${offer.org.username}.\n\nThis transaction will be recorded on blockchain.'
                : 'By signing this transaction you will get ${offer.tokensAmount} Impact Shares of ${offer.org.name}.\n\nThis transaction will be recorded on blockchain.',
            style: const TextStyle(
              fontFamily: 'Gilroy',
            ),
          ),
          const SizedBox(height: 35),
          SecondaryButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              acceptOffer(offer);
            },
            child: Text(
              'Send \$${offer.price}',
            ),
          ),
        ],
      ),
    );
  }

  acceptOffer(SaleOffer offer) async {
    setState(() {
      isLoading = true;
    });
    Config config = ConfigState.of(context).config;
    try {
      await offersApi.acceptDeclineSaleOffer(
        offer.id!,
        'accepted',
        config.mode == Mode.Lite,
      );
      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }
    } catch (err) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Operation failed'),
          content: Text(err.toString()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
        content: Text(
          AppLocalizations.of(context)!.common_link_copied,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
        ),
        duration: const Duration(milliseconds: 300),
        backgroundColor: Colors.black.withOpacity(0.7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  handleCopyPressed(BuildContext context) {
    Clipboard.setData(ClipboardData(text: payment!.cpPaymentUrl!));
    callSnackBar(context);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      title: 'Offer to Buy',
      child: FutureBuilder(
        future: Future.wait([futureSaleOffer, futureAccount, futureBalance]),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final saleOffer = snapshot.data![0] as SaleOffer?;
          final account = snapshot.data![1] as Account?;
          final balanceData = snapshot.data![2] as Map<String, double?>;
          final balance = balanceData['balance'];
          final bonusBalance = balanceData['bonusBalance'];
          final canPay = (saleOffer?.price ?? 0) <= (bonusBalance ?? 0) ||
              (saleOffer?.price ?? 0) <= (balance ?? 0);

          return Stack(
            children: [
              Positioned.fill(
                child: Column(
                  children: [
                    Expanded(
                      child: KeyboardDismissableListView(
                        children: [
                          const SizedBox(height: 20),
                          buildFromDetails(context, saleOffer),
                          const SizedBox(height: 5),
                          buildDetails(context, saleOffer),
                          const SizedBox(height: 20),
                          const SizedBox(height: 100),
                          if (payment != null)
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.only(right: 13.0),
                                    child: TextButton.icon(
                                      onPressed: () async {
                                        final url =
                                            Uri.parse(payment!.cpPaymentUrl!);
                                        if (!(await launchUrl(url))) {
                                          throw Exception(
                                            'Could not launch $url',
                                          );
                                        }
                                      },
                                      icon: const Icon(Icons.link),
                                      label: Text(
                                        payment!.cpPaymentUrl!,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      style: TextButton.styleFrom(
                                        iconColor: COLOR_BLUE,
                                        foregroundColor: COLOR_BLUE,
                                      ),
                                    ),
                                  ),
                                ),
                                TextButton.icon(
                                  label: const Text('Copy'),
                                  icon: const Icon(Icons.copy, size: 12),
                                  onPressed: () => handleCopyPressed(context),
                                )
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (payment == null)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Text(
                        account?.username != null
                            ? '@${account?.username}'
                            : '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: COLOR_GRAY,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Your Equity Wallet balance \$$balance',
                        style: TextStyle(
                          color: canPay ? COLOR_GRAY : COLOR_RED,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Visibility(
                        visible: (bonusBalance ?? 0) > 0,
                        child: Text(
                          'Your Equity Wallet bonus balance \$$bonusBalance',
                          style: const TextStyle(
                            color: COLOR_LIGHT_GREEN,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: 290,
                        child: ElevatedButton(
                          onPressed: !isLoading && canPay
                              ? () => handleBuyPressed(saleOffer)
                              : null,
                          child: isLoading
                              ? const CircularProgressIndicator.adaptive()
                              : Text('Buy for \$${saleOffer?.price}'),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
