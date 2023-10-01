import 'package:flutter/material.dart';
import 'package:iw_app/api/models/send_money_data_model.dart';
import 'package:iw_app/screens/withdraw/withdraw_success_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/list/keyboard_dismissable_list.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

class WithdrawPreviewScreen<T extends Widget> extends StatefulWidget {
  final SendMoneyData sendMoneyData;
  final Future Function(SendMoneyData) onWithdrawPressed;

  const WithdrawPreviewScreen({
    Key? key,
    required this.sendMoneyData,
    required this.onWithdrawPressed,
  }) : super(key: key);

  @override
  State<WithdrawPreviewScreen> createState() => _WithdrawPreviewScreenState();
}

class _WithdrawPreviewScreenState extends State<WithdrawPreviewScreen> {
  bool isLoading = false;

  handleNextPressed(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    try {
      await widget.onWithdrawPressed(widget.sendMoneyData);

      if (context.mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => WithdrawSuccessScreen(
              sendMoneyData: widget.sendMoneyData,
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
          'You Withdraw',
          style: TextStyle(color: COLOR_GRAY),
        ),
        const SizedBox(height: 10),
        Text(
          '\$${widget.sendMoneyData.amount!.toStringAsFixed(2)} Credit\$',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ],
    );
  }

  buildInfo(String title, String info, {bool shouldCut = true}) {
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
            shouldCut ? info.replaceRange(4, 40, '...') : info,
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
                buildInfo('Withdraw method', 'USDC', shouldCut: false),
                const SizedBox(height: 10),
                buildInfo('To', widget.sendMoneyData.recipient!),
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
      ),
    );
  }
}
