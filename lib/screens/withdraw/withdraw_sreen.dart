import 'package:flutter/material.dart';
import 'package:iw_app/api/models/send_money_data_model.dart';
import 'package:iw_app/api/users_api.dart';
import 'package:iw_app/screens/withdraw/withdraw_token_recipient_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/utils/url.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

class WithdrawScreen extends StatelessWidget {
  const WithdrawScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      title: 'Withdraw digital dollars',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 35),
          TextButton.icon(
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all<Color>(
                Colors.transparent,
              ),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.all(10),
              ),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => WithdrawTokenRecipientScreen(
                    token: SendMoneyToken.DPLN,
                    onWithdrawPressed: (SendMoneyData data) =>
                        usersApi.withdrawCredits(data),
                  ),
                ),
              );
            },
            icon: Image.asset(
              'assets/icons/deplan_token_circle.png',
              width: 25,
              height: 25,
            ),
            label: Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Withdraw as DPLN\n',
                      style: TextStyle(
                        color: COLOR_ALMOST_BLACK,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                          'Withdraw your money as DPLN to external Solana Wallet',
                      style: TextStyle(color: COLOR_GRAY, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextButton.icon(
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all<Color>(
                Colors.transparent,
              ),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.all(10),
              ),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => WithdrawTokenRecipientScreen(
                    token: SendMoneyToken.USDC,
                    onWithdrawPressed: (SendMoneyData data) =>
                        usersApi.withdrawCredits(data),
                  ),
                ),
              );
            },
            icon: Image.asset(
              'assets/icons/usdc-icon.png',
              width: 25,
              height: 25,
            ),
            label: Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Withdraw as USDC\n',
                      style: TextStyle(
                        color: COLOR_ALMOST_BLACK,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                          'Withdraw your money as USDC to external Solana Wallet',
                      style: TextStyle(color: COLOR_GRAY, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextButton.icon(
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all<Color>(
                Colors.transparent,
              ),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.all(10),
              ),
            ),
            onPressed: () {
              launchURL(
                Uri.parse(
                  'https://deplan.xyz/withdraw-bank-transfer',
                ),
              );
            },
            icon: const Icon(
              Icons.account_balance,
              color: COLOR_ALMOST_BLACK,
            ),
            label: Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Bank Transfer \n',
                      style: TextStyle(
                        color: COLOR_ALMOST_BLACK,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: 'Withdraw to your Bank account',
                      style: TextStyle(color: COLOR_GRAY, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextButton.icon(
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all<Color>(
                Colors.transparent,
              ),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.all(10),
              ),
            ),
            onPressed: () {
              launchURL(
                Uri.parse(
                  'https://deplan.xyz/withdraw-cash-with-moneygram',
                ),
              );
            },
            icon: Image.asset(
              'assets/icons/money_gram_icon.png',
              width: 25,
            ),
            label: Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Cashout with MoneyGram \n',
                      style: TextStyle(
                        color: COLOR_ALMOST_BLACK,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: 'Give digital dollars, get cash',
                      style: TextStyle(color: COLOR_GRAY, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
