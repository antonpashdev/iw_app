import 'package:flutter/material.dart';
import 'package:iw_app/api/models/send_money_data_model.dart';
import 'package:iw_app/screens/withdraw/withdraw_preview_screen.dart';
import 'package:iw_app/utils/validation.dart';
import 'package:iw_app/widgets/form/input_form.dart';
import 'package:iw_app/widgets/list/keyboard_dismissable_list.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

class WithdrawAmountScreen<T extends Widget> extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final SendMoneyData sendMoneyData;
  final Future Function(SendMoneyData) onWithdrawPressed;

  WithdrawAmountScreen({
    Key? key,
    required this.sendMoneyData,
    required this.onWithdrawPressed,
  }) : super(key: key);

  handleNextPressed(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WithdrawPreviewScreen(
          sendMoneyData: sendMoneyData,
          onWithdrawPressed: onWithdrawPressed,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      title: 'Enter Amount',
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
                      const Text(
                        'You Withdraw',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 10),
                      AppTextFormFieldBordered(
                        suffix: const Text('DPLN'),
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
      ),
    );
  }
}
