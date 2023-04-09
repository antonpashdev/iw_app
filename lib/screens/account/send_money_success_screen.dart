import 'package:flutter/material.dart';
import 'package:iw_app/api/users_api.dart';
import 'package:iw_app/screens/account/account_details_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/utils/app_padding.dart';

class SendMoneySuccessScreen extends StatelessWidget {
  final SendMoneyData sendMoneyData;

  const SendMoneySuccessScreen({Key? key, required this.sendMoneyData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_WHITE,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline_outlined,
              color: COLOR_GREEN,
              size: 200,
            ),
            const SizedBox(height: 30),
            Text(
              '\$${sendMoneyData.amount!.toStringAsFixed(2)} USDC Sent!',
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 30),
            AppPadding(
              child: Text(
                'Your money has been successfully sent to ${sendMoneyData.address!.replaceRange(4, 40, '...')}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontFamily: 'Gilroy',
                      color: COLOR_GRAY,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            const SizedBox(height: 100),
            SizedBox(
              width: 220,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => const AccountDetailsScreen(),
                    ),
                    ModalRoute.withName('/'),
                  );
                },
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
