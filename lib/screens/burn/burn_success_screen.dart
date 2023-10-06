import 'package:flutter/material.dart';
import 'package:iw_app/app_home.dart';
import 'package:iw_app/screens/account/account_details_screen.dart';
import 'package:iw_app/theme/app_theme.dart';

class BurnSuccessScreen<T extends Widget> extends StatelessWidget {
  final double amount;

  const BurnSuccessScreen({
    Key? key,
    required this.amount,
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
              'Credit\$ successfully burnt',
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w500,
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
                    ModalRoute.withName(AppHome.routeName),
                  );
                },
                child: const Text('Go to your account'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
