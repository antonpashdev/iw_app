import 'package:flutter/material.dart';
import 'package:iw_app/constants/send_asset_type.dart';
import 'package:iw_app/models/config_model.dart';
import 'package:iw_app/screens/home_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';
import 'package:iw_app/widgets/state/config.dart';

class SuccessScreen extends StatelessWidget {
  final double sharesSent;
  final String orgName;
  final String? receiverUsername;
  final String? receiverAddress;
  final SendAssetType sendAssetType;

  const SuccessScreen({
    super.key,
    required this.sharesSent,
    required this.orgName,
    required this.receiverUsername,
    required this.receiverAddress,
    required this.sendAssetType,
  });

  handleDone(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    Config config = ConfigState.of(context).config;
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
            Text(
              config.mode == Mode.Pro
                  ? '$sharesSent Impact Shares Sent'
                  : '$sharesSent% of equity sent!',
              style: const TextStyle(
                color: COLOR_ALMOST_BLACK,
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              config.mode == Mode.Pro
                  ? 'Impact Shares of $orgName have been successfully sent to ${sendAssetType == SendAssetType.ToAddress ? receiverAddress!.replaceRange(4, 40, '...') : '@$receiverUsername'}'
                  : 'Equity of $orgName has been successfully sent to ${sendAssetType == SendAssetType.ToAddress ? receiverAddress!.replaceRange(4, 40, '...') : '@$receiverUsername'}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: COLOR_GRAY,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 100),
            SizedBox(
              width: 290,
              child: ElevatedButton(
                onPressed: () => handleDone(context),
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
