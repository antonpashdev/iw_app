import 'package:flutter/material.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

class WithdrawScreen extends StatelessWidget {
  const WithdrawScreen({super.key});

  showComingSoonDialog(BuildContext context) {
    _callSnackBar(context);
  }

  _callSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 80,
          left: 20,
          right: 20,
        ),
        content: const Text(
          'Coming soon...',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.black.withOpacity(0.6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

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
              showComingSoonDialog(context);
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
              showComingSoonDialog(context);
            },
            icon: Image.asset('assets/icons/money_gram_icon.png'),
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
          )
        ],
      ),
    );
  }
}
