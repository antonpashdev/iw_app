import 'package:flutter/material.dart';
import 'package:iw_app/l10n/generated/app_localizations.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/screens/organization/receive_money_generate_link_screen.dart';
import 'package:iw_app/widgets/form/input_form.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';
import 'package:iw_app/utils/validation.dart';

class ReceiveMoneyScreen extends StatefulWidget {
  final Organization organization;

  const ReceiveMoneyScreen({super.key, required this.organization});

  @override
  State<ReceiveMoneyScreen> createState() => _ReceiveMoneyScreenState();
}

class _ReceiveMoneyScreenState extends State<ReceiveMoneyScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _item = '';
  late String _price = '';
  get organization => widget.organization;

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
        title: AppLocalizations.of(context)!.receiveMoneyScreen_title,
        child: InputForm(
          formKey: _formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                  Widget>[
            Text(AppLocalizations.of(context)!.receiveMoneyScreen_label_item),
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
            Text(AppLocalizations.of(context)!.receiveMoneyScreen_label_price),
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
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ReceiveMoneyGenerateLinkScreen(
                                                    organization:
                                                        organization)));
                                  }
                                },
                          child: Text(AppLocalizations.of(context)!
                              .receiveMoneyScreen_label_generate_link)),
                    )
                  ],
                ))
          ]),
        ));
  }
}
