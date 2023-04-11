import 'package:flutter/material.dart';
import 'package:iw_app/api/models/send_money_data_model.dart';
import 'package:iw_app/screens/send_money/send_money_amount_screen.dart';
import 'package:iw_app/utils/validation.dart';
import 'package:iw_app/widgets/form/input_form.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

class SendMoneyRecipientScreen<T extends Widget> extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final String senderWallet;
  final SendMoneyData data = SendMoneyData();
  final Future Function(SendMoneyData) onSendMoney;
  final T Function() originScreenFactory;

  SendMoneyRecipientScreen({
    Key? key,
    required this.senderWallet,
    required this.onSendMoney,
    required this.originScreenFactory,
  }) : super(key: key);

  handleNextPressed(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SendMoneyAmountScreen(
          senderWallet: senderWallet,
          sendMoneyData: data,
          onSendMoney: onSendMoney,
          originScreenFactory: originScreenFactory,
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
              child: ListView(
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
        ));
  }
}
