import 'package:flutter/material.dart';
import 'package:iw_app/api/users_api.dart';
import 'package:iw_app/models/user_model.dart';
import 'package:iw_app/screens/account/send_money_preview_screen.dart';
import 'package:iw_app/utils/validation.dart';
import 'package:iw_app/widgets/form/input_form.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

class SendMoneyAmountScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final User user;
  final SendMoneyData sendMoneyData;

  SendMoneyAmountScreen(
      {Key? key, required this.user, required this.sendMoneyData})
      : super(key: key);

  handleNextPressed(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => SendMoneyPreviewScreen(
              sendMoneyData: sendMoneyData,
              user: user,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
        title: 'Enter Amount',
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
                        const Text(
                          'You Send',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 10),
                        AppTextFormFieldBordered(
                          prefix: const Text('\$'),
                          suffix: const Text('USDC'),
                          onChanged: (value) {
                            sendMoneyData.amount = double.tryParse(value);
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
