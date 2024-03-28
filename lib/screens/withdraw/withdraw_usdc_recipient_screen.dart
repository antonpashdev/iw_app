import 'package:flutter/material.dart';
import 'package:iw_app/api/models/send_money_data_model.dart';
import 'package:iw_app/screens/withdraw/withdraw_amount_screen.dart';
import 'package:iw_app/utils/validation.dart';
import 'package:iw_app/widgets/form/input_form.dart';
import 'package:iw_app/widgets/list/keyboard_dismissable_list.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

class WithdrawUSDCRecipientScreen<T extends Widget> extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final SendMoneyData data = SendMoneyData();
  final Future Function(SendMoneyData) onWithdrawPressed;

  WithdrawUSDCRecipientScreen({
    Key? key,
    required this.onWithdrawPressed,
  }) : super(key: key);

  handleNextPressed(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WithdrawAmountScreen(
          sendMoneyData: data,
          onWithdrawPressed: onWithdrawPressed,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      title: 'Recipient',
      child: Column(
        children: [
          Expanded(
            child: KeyboardDismissableListView(
              children: [
                const SizedBox(height: 40),
                InputForm(
                  formKey: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextFormField(
                        labelText: 'Enter Recipient’s Solana Wallet',
                        helperText:
                            'Please enter an address of wallet on the Solana blockchain you are goning to send money to.',
                        onChanged: (value) {
                          data.recipient = value;
                        },
                        validator: multiValidate([
                          requiredField('Recipient’s Solana Wallet'),
                          walletAddres(),
                        ]),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 290,
            child: ElevatedButton(
              onPressed: () => handleNextPressed(context),
              child: const Text('Next'),
            ),
          ),
        ],
      ),
    );
  }
}
