import 'package:flutter/material.dart';
import 'package:iw_app/api/account_api.dart';
import 'package:iw_app/utils/debounce.dart';
import 'package:iw_app/utils/validation.dart';
import 'package:iw_app/widgets/form/input_form.dart';
import 'package:iw_app/widgets/list/keyboard_dismissable_list.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';
import 'package:url_launcher/url_launcher.dart';

class DepositAmountScreen<T extends Widget> extends StatefulWidget {
  const DepositAmountScreen({Key? key}) : super(key: key);

  @override
  State<DepositAmountScreen<T>> createState() => _DepositAmountScreenState<T>();
}

class _DepositAmountScreenState<T extends Widget>
    extends State<DepositAmountScreen<T>> {
  final formKey = GlobalKey<FormState>();
  final debouncer = Debouncer(duration: const Duration(milliseconds: 1000));

  double? amount;
  String? paymentUrl;
  bool isLoading = false;

  handleCheckoutPressed(BuildContext context) async {
    if (!formKey.currentState!.validate() || paymentUrl == null) {
      return;
    }
    if (!(await launchUrl(Uri.parse(paymentUrl!)))) {
      throw Exception(
        'Could not launch $paymentUrl',
      );
    }
  }

  getPaymentLink() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    final response = await accountApi.depositCredits(amount!);
    setState(() {
      paymentUrl = response.data['url'];
      isLoading = false;
    });
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
                        'You Deposit',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 10),
                      AppTextFormFieldBordered(
                        prefix: const Text('\$'),
                        onChanged: (value) {
                          amount = double.tryParse(value);
                          if (amount == null) {
                            return;
                          }
                          setState(() {
                            isLoading = true;
                          });
                          debouncer.debounce(getPaymentLink);
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
              onPressed:
                  isLoading ? null : () => handleCheckoutPressed(context),
              child: isLoading
                  ? const CircularProgressIndicator.adaptive()
                  : const Text('Go to checkout'),
            ),
          ),
        ],
      ),
    );
  }
}
