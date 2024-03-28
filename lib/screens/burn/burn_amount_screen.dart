import 'package:flutter/material.dart';
import 'package:iw_app/screens/burn/burn_preview_screen.dart';
import 'package:iw_app/utils/validation.dart';
import 'package:iw_app/widgets/form/input_form.dart';
import 'package:iw_app/widgets/list/keyboard_dismissable_list.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

class BurnAmountScreen<T extends Widget> extends StatefulWidget {
  const BurnAmountScreen({Key? key}) : super(key: key);

  @override
  State<BurnAmountScreen<T>> createState() => _BurnAmountScreenState<T>();
}

class _BurnAmountScreenState<T extends Widget>
    extends State<BurnAmountScreen<T>> {
  final formKey = GlobalKey<FormState>();

  double? amount;

  handleNextPressed(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BurnPreviewScreen(amount: amount!),
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
                        'You Burn',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 10),
                      AppTextFormFieldBordered(
                        prefix: const Text('\$'),
                        suffix: const Text('Credit\$'),
                        onChanged: (value) {
                          amount = double.tryParse(value);
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
