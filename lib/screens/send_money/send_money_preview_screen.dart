import 'package:flutter/material.dart';
import 'package:iw_app/api/models/send_money_data_model.dart';
import 'package:iw_app/screens/send_money/send_money_success_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/list/keyboard_dismissable_list.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

class SendMoneyPreviewScreen<T extends Widget> extends StatefulWidget {
  final String senderWallet;
  final SendMoneyData sendMoneyData;
  final Future Function(SendMoneyData) onSendMoney;
  final T Function() originScreenFactory;

  const SendMoneyPreviewScreen({
    Key? key,
    required this.sendMoneyData,
    required this.senderWallet,
    required this.onSendMoney,
    required this.originScreenFactory,
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
    try {
      await widget.onSendMoney(widget.sendMoneyData);

      if (context.mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => SendMoneySuccessScreen(
              sendMoneyData: widget.sendMoneyData,
              originScreenFactory: widget.originScreenFactory,
            ),
          ),
        );
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
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
              child: KeyboardDismissableListView(
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: buildAmount(context),
                  ),
                  const SizedBox(height: 50),
                  buildAddressInfo('From your wallet', widget.senderWallet),
                  const SizedBox(height: 10),
                  buildAddressInfo('To', widget.sendMoneyData.recipient!),
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
        ),);
  }
}
