import 'package:flutter/material.dart';
import 'package:iw_app/models/account_model.dart';
import 'package:iw_app/screens/account/builders/wallet_section.dart';
import 'package:iw_app/theme/app_theme.dart';

buildHeader(Account account, Map? balance, BuildContext context) {
  return Column(
    children: [
      Center(
        child: balance == null
            ? const CircularProgressIndicator.adaptive()
            : Column(
                children: [
                  Text(
                    '\$${balance["usdcBalance"]}',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  Text(
                    '${balance["balance"]} DPLN',
                    style: const TextStyle(color: COLOR_GRAY),
                  ),
                ],
              ),
      ),
      buildWalletSection(
        context,
        account,
      ),
    ],
  );
}
