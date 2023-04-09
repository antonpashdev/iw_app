import 'package:flutter/material.dart';
import 'package:iw_app/api/users_api.dart';
import 'package:iw_app/models/user_model.dart';
import 'package:iw_app/screens/account/send_money_success_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

class SendMoneyPreviewScreen extends StatefulWidget {
  final User user;
  final SendMoneyData sendMoneyData;

  const SendMoneyPreviewScreen({
    Key? key,
    required this.sendMoneyData,
    required this.user,
  }) : super(key: key);

  @override
  State<SendMoneyPreviewScreen> createState() => _SendMoneyPreviewScreenState();
}

class _SendMoneyPreviewScreenState extends State<SendMoneyPreviewScreen> {
  bool isLoading = false;

  handleNextPressed(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      isLoading = false;
    });
    if (context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => SendMoneySuccessScreen(
            sendMoneyData: widget.sendMoneyData,
          ),
        ),
      );
    }
  }

  buildAmount(BuildContext context) {
    return Column(
      children: [
        const Text(
          'You Send',
          style: TextStyle(color: COLOR_GRAY),
        ),
        const SizedBox(height: 10),
        Text(
          '\$${widget.sendMoneyData.amount!.toStringAsFixed(2)} USDC',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ],
    );
  }

  buildAddressInfo(String title, String address) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: COLOR_LIGHT_GRAY3,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: COLOR_GRAY),
          ),
          const SizedBox(height: 5),
          Text(
            address.replaceRange(4, 40, '...'),
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
        title: 'Preview',
        child: Stack(
          children: [
            Positioned.fill(
              child: ListView(
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: buildAmount(context),
                  ),
                  const SizedBox(height: 50),
                  buildAddressInfo('From your wallet', widget.user.wallet!),
                  const SizedBox(height: 10),
                  buildAddressInfo('To', widget.sendMoneyData.address!),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: 290,
                  child: ElevatedButton(
                    onPressed:
                        isLoading ? null : () => handleNextPressed(context),
                    child: isLoading
                        ? const Center(
                            child: CircularProgressIndicator.adaptive(),
                          )
                        : const Text('Send'),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
