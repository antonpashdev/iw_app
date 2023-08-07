import 'package:flutter/material.dart';
import 'package:iw_app/models/account_model.dart';
import 'package:iw_app/screens/account/builders/wallet_section.dart';
import 'package:iw_app/utils/numbers.dart';
import 'package:iw_app/widgets/utils/app_padding.dart';

buildHeader(Account account, double? balance, BuildContext context) {
  return Column(
    children: [
      SizedBox(
        height: 50,
        child: Center(
          child: balance == null
              ? const CircularProgressIndicator.adaptive()
              : Text(
                  '\$${trimZeros(balance)}',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
        ),
      ),
      AppPadding(
        child: buildWalletSection(
          context,
          account,
        ),
      ),
    ],
  );
}
