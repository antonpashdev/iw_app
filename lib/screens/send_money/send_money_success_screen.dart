import 'package:flutter/material.dart';
import 'package:iw_app/api/models/send_money_data_model.dart';
import 'package:iw_app/app_home.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/utils/app_padding.dart';

class SendMoneySuccessScreen<T extends Widget> extends StatelessWidget {
  final SendMoneyData sendMoneyData;
  final T Function() originScreenFactory;

  const SendMoneySuccessScreen({
    Key? key,
    required this.sendMoneyData,
    required this.originScreenFactory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: APP_BODY_BG,
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
              '${sendMoneyData.amount!.toStringAsFixed(2)} DPLN Sent!',
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 30),
            AppPadding(
              child: Text(
                'Your money has been successfully sent to ${sendMoneyData.recipient!.replaceRange(4, 40, '...')}',
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
                      builder: (_) => originScreenFactory(),
                    ),
                    ModalRoute.withName(AppHome.routeName),
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
