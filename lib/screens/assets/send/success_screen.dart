import 'package:flutter/material.dart';
import 'package:iw_app/screens/home_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

class SuccessScreen extends StatelessWidget {
  final double sharesSent;
  final String orgName;
  final String receiverNickName;

  const SuccessScreen(
      {super.key,
      required this.sharesSent,
      required this.orgName,
      required this.receiverNickName});

  handleDone(BuildContext context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
        title: '',
        child: Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(
                  Icons.check_circle_outline_rounded,
                  size: 150,
                  color: COLOR_GREEN,
                ),
                const SizedBox(height: 30),
                Text('$sharesSent Impact Shares Sent',
                    style: const TextStyle(
                        color: COLOR_ALMOST_BLACK,
                        fontWeight: FontWeight.w600,
                        fontSize: 24)),
                const SizedBox(height: 20),
                Text(
                    'Impact Shares of $orgName have been successfully sent to @$receiverNickName',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: COLOR_GRAY,
                        fontWeight: FontWeight.w500,
                        fontSize: 18)),
                const SizedBox(height: 100),
                SizedBox(
                  width: 290,
                  child: ElevatedButton(
                      onPressed: () => handleDone(context),
                      child: const Text('Done')),
                )
              ]),
        ));
  }
}
