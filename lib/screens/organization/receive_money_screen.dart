import 'package:flutter/material.dart';
import 'package:iw_app/l10n/generated/app_localizations.dart';
import 'package:iw_app/widgets/form/input_form.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';
import 'package:iw_app/utils/validation.dart';

class ReceiveMoneyScreen extends StatefulWidget {
  const ReceiveMoneyScreen({super.key});

  @override
  State<ReceiveMoneyScreen> createState() => _ReceiveMoneyScreenState();
}

class _ReceiveMoneyScreenState extends State<ReceiveMoneyScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _item = '';
  late String _price = '';

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
        title: 'Item and Price',
        child: InputForm(
          formKey: _formKey,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('Item'),
                const SizedBox(height: 5),
                AppTextFormFieldBordered(
                  autofocus: true,
                  onChanged: (value) {
                    setState(() {
                      _item = value;
                    });
                  },
                ),
                const SizedBox(height: 45),
                const Text('Price'),
                const SizedBox(height: 5),
                AppTextFormFieldBordered(
                    inputType: TextInputType.number,
                    prefix: const Text('\$'),
                    validator: multiValidate([
                      numberField('Price'),
                    ]),
                    onChanged: (value) {
                      setState(() {
                        _price = value;
                      });
                    }),
                Expanded(
                    flex: 1,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 330,
                          child: ElevatedButton(
                              onPressed: _item.isEmpty || _price.isEmpty
                                  ? null
                                  : () {
                                      if (_formKey.currentState!.validate()) {
                                        print('$_item, $_price');
                                      }
                                    },
                              child: const Text('Generate  Payment Link')),
                        )
                      ],
                    ))
              ]),
        ));
  }
}
