import 'package:flutter/material.dart';
import 'package:iw_app/api/users_api.dart';
import 'package:iw_app/models/user_model.dart';
import 'package:iw_app/screens/account/send_money_preview_screen.dart';
import 'package:iw_app/utils/validation.dart';
import 'package:iw_app/widgets/form/input_form.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

class SendMoneyScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final User user;
  final SendMoneyData data = SendMoneyData();

  SendMoneyScreen({Key? key, required this.user}) : super(key: key);

  handleNextPressed(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => SendMoneyPreviewScreen(
              sendMoneyData: data,
              user: user,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
        title: 'Recipient and Amount',
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
                            data.address = value;
                          },
                          validator: multiValidate([
                            requiredField('Recipient’s Solana Wallet'),
                            walletAddres(),
                          ]),
                          maxLines: 1,
                        ),
                        const SizedBox(height: 40),
                        const Text(
                          'Enter amount',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 10),
                        AppTextFormFieldBordered(
                          prefix: const Text('\$'),
                          suffix: const Text('USDC'),
                          onChanged: (value) {
                            data.amount = double.tryParse(value);
                          },
                          validator: multiValidate([
                            requiredField('Amount'),
                            numberField('Amount'),
                          ]),
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
