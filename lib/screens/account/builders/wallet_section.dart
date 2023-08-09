import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iw_app/api/models/send_money_data_model.dart';
import 'package:iw_app/api/users_api.dart';
import 'package:iw_app/models/account_model.dart';
import 'package:iw_app/screens/account/account_details_screen.dart';
import 'package:iw_app/screens/send_money/send_money_recipient_screen.dart';
import 'package:iw_app/screens/withdraw/withdraw_sreen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/utils/url.dart';
import 'package:iw_app/widgets/buttons/Icon_button_with_text.dart';

buildWalletSection(BuildContext context, Account account) {
  callSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 70,
          left: 20,
          right: 20,
        ),
        content: const Text(
          'Copied to clipboard',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
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

  return Column(
    children: [
      Center(
        child: TextButton.icon(
          onPressed: () => handleCopyPressed(account.wallet!),
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
                    account.wallet!.replaceRange(8, 36, '...'),
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
      TextButton(
        onPressed: () {
          launchURL(
            Uri.parse(
              'https://explorer.solana.com/address/${account.wallet}/tokens',
            ),
          );
        },
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(Colors.transparent),
        ),
        child: const Text(
          'View your wallet on blockchain »',
          style: TextStyle(
            color: COLOR_GRAY,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
      const SizedBox(height: 10),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButtonWithText(
            image: SvgPicture.asset('assets/icons/arrow_up_box.svg'),
            text: 'Send',
            backgroundColor: COLOR_BLACK,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => SendMoneyRecipientScreen(
                    senderWallet: account.wallet!,
                    onSendMoney: (SendMoneyData data) =>
                        usersApi.sendMoney(data),
                    originScreenFactory: () => const AccountDetailsScreen(),
                  ),
                ),
              );
            },
          ),
          IconButtonWithText(
            image: SvgPicture.asset('assets/icons/arrow_down_box.svg'),
            text: 'Receive',
            backgroundColor: COLOR_BLUE,
            onPressed: () {},
          ),
          IconButtonWithText(
            image: SvgPicture.asset('assets/icons/arrow_right_box.svg'),
            text: 'Withdraw',
            backgroundColor: COLOR_GREEN,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const WithdrawScreen(),
                ),
              );
            },
          ),
        ],
      ),
    ],
  );
}
