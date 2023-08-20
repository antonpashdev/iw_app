import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:iw_app/api/auth_api.dart';
import 'package:iw_app/api/payment_api.dart';
import 'package:iw_app/api/users_api.dart';
import 'package:iw_app/app_home.dart';
import 'package:iw_app/app_storage.dart';
import 'package:iw_app/models/account_model.dart';
import 'package:iw_app/models/config_model.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/models/payment_model.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/buttons/secondary_button.dart';
import 'package:iw_app/widgets/components/bottom_sheet_info.dart';
import 'package:iw_app/widgets/list/keyboard_dismissable_list.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';
import 'package:iw_app/widgets/state/config.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:universal_html/html.dart';
import 'package:url_launcher/url_launcher.dart' show launchUrl;

class CheckoutScreen extends StatefulWidget {
  static const routeName = '/checkout';

  final String paymentId;

  const CheckoutScreen({
    super.key,
    required this.paymentId,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool isLoading = false;
  bool isPaymentSuccess = false;
  late Future<Payment?> futurePayment;
  late Future<Account?> futureAccount;
  late Future<Map<String, double?>> futureBalance;

  @override
  void initState() {
    super.initState();
    futurePayment = fetchPayment();
    futureAccount = fetchAccount();
    futureBalance = fetchBalance();
  }

  Config get config {
    return ConfigState.of(context).config;
  }

  Future<Account?> fetchAccount() async {
    try {
      final response = await authApi.getMe();
      return Account.fromJson(response.data);
    } on DioError catch (err) {
      if (err.response?.statusCode == 401) {
        await appStorage.write('redirect_to', '/checkout/${widget.paymentId}');
        if (mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppHome.routeName,
            (route) => false,
          );
        }
      }
      rethrow;
    } catch (err) {
      print(err);
    }
    return null;
  }

  Future<Payment?> fetchPayment() async {
    try {
      final response = await paymentApi.getPayment(widget.paymentId);
      return Payment.fromJson(response.data);
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

  buildItem(PaymentItem item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (item.image != null)
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: COLOR_GRAY,
              borderRadius: BorderRadius.circular(15),
            ),
            clipBehavior: Clip.antiAlias,
            child: FittedBox(
              fit: BoxFit.cover,
              child: FadeInImage(
                fadeInDuration: const Duration(milliseconds: 300),
                placeholder: MemoryImage(kTransparentImage),
                image: NetworkImage(
                  item.image!,
                ),
              ),
            ),
          ),
        const SizedBox(width: 15),
        Expanded(
          child: Text(item.name!),
        ),
      ],
    );
  }

  buildItems(BuildContext context, List<PaymentItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: COLOR_LIGHT_GRAY,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ...items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Column(
                children: [
                  buildItem(item),
                  if (index < items.length - 1) const SizedBox(height: 15),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  buildOrgInfo(Organization? org) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (org?.logo != null)
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
              child: FadeInImage(
                fadeInDuration: const Duration(milliseconds: 300),
                placeholder: MemoryImage(kTransparentImage),
                image: NetworkImage(
                  '${paymentApi.baseUrl}${org?.logo}',
                ),
              ),
            ),
          ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                org?.name ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '@${org?.username}',
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

  buildTotalInfo(BuildContext context, Payment? payment) {
    return Container(
      decoration: BoxDecoration(
        color: COLOR_LIGHT_GRAY,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildOrgInfo(payment?.org),
            const SizedBox(height: 15),
            const Divider(),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Price'),
                Text(
                  '\$${payment?.amount}',
                  style: const TextStyle(
                    color: COLOR_GREEN,
                    fontWeight: FontWeight.w700,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  launch(String? url) async {
    if (url == null || url.isEmpty) {
      return;
    }
    if (kIsWeb) {
      window.location.href = url;
    } else {
      if (!await launchUrl(Uri.parse(url))) {
        throw Exception('Could not launch $url');
      }
    }
  }

  handleError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: COLOR_RED,
        duration: const Duration(days: 365),
        showCloseIcon: true,
        closeIconColor: COLOR_WHITE,
      ),
    );
  }

  performPayment(Payment payment) async {
    Navigator.of(context).pop();
    setState(() {
      isLoading = true;
    });
    try {
      await paymentApi.performPayment(payment.id!);
      await launch(payment.org.settings?.successUrl);
      setState(() {
        isPaymentSuccess = true;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment successful!'),
            backgroundColor: COLOR_GREEN,
          ),
        );
      }
    } on DioError catch (err) {
      handleError(err.response?.data['message'] ?? err.message);
    } catch (err) {
      handleError(err.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  handlePayPressed(Account? account, Payment? payment) {
    final itemsStr = payment?.items?.map((item) => item.name).join(', ');
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
            'From @${account?.username} to @${payment?.org.username} for $itemsStr.',
            style: const TextStyle(
              fontFamily: 'Gilroy',
            ),
          ),
          const SizedBox(height: 25),
          const Text(
            'This transaction will be recorded on blockchain.',
            style: TextStyle(
              fontFamily: 'Gilroy',
            ),
          ),
          const SizedBox(height: 35),
          SecondaryButton(
            onPressed: () {
              Navigator.of(context).pop();
              launch(payment?.org.settings?.cancelUrl);
            },
            child: const Text('Cancel'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              performPayment(payment!);
            },
            child: Text(
              'Pay \$${payment?.amount}',
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      title: 'Checkout',
      child: FutureBuilder(
        future: Future.wait([futureAccount, futurePayment, futureBalance]),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final account = snapshot.data![0] as Account?;
            final payment = snapshot.data![1] as Payment?;
            final balanceData = snapshot.data![2] as Map<String, double?>;
            final balance = balanceData['balance'];
            final bonusBalance = balanceData['bonusBalance'];

            return Stack(
              children: [
                Positioned.fill(
                  child: KeyboardDismissableListView(
                    children: <Widget>[
                      buildItems(context, payment?.items ?? []),
                      const SizedBox(height: 5),
                      buildTotalInfo(context, payment),
                    ],
                  ),
                ),
                if (!isPaymentSuccess)
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
                          style: const TextStyle(
                            color: COLOR_GRAY,
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
                        Center(
                          child: SizedBox(
                            width: 290,
                            child: ElevatedButton(
                              onPressed: !isLoading &&
                                          (payment?.amount ?? 0) <=
                                              (bonusBalance ?? 0) ||
                                      (payment?.amount ?? 0) <= (balance ?? 0)
                                  ? () => handlePayPressed(account, payment)
                                  : null,
                              child: isLoading
                                  ? const CircularProgressIndicator.adaptive()
                                  : Text('Pay \$${payment?.amount}'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (isPaymentSuccess)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: SizedBox(
                        width: 290,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              AppHome.routeName,
                              (route) => false,
                            );
                          },
                          child: const Text('Done'),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
