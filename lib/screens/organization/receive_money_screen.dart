import 'package:flutter/material.dart';
import 'package:iw_app/api/orgs_api.dart';
import 'package:iw_app/constants/payment_type.dart';
import 'package:iw_app/l10n/generated/app_localizations.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/models/payment_model.dart';
import 'package:iw_app/screens/organization/receive_money_generate_link_screen.dart';
import 'package:iw_app/widgets/form/input_form.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';
import 'package:iw_app/utils/validation.dart';

class ReceiveMoneyScreen extends StatefulWidget {
  final Organization organization;
  final PaymentType paymentType;

  const ReceiveMoneyScreen(
      {super.key, required this.organization, required this.paymentType});

  @override
  State<ReceiveMoneyScreen> createState() => _ReceiveMoneyScreenState();
}

class _ReceiveMoneyScreenState extends State<ReceiveMoneyScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _item = '';
  double? _price;
  bool isLoading = false;

  get organization => widget.organization;
  get paymentType => widget.paymentType;

  handleGeneratePressed() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      final response =
          await orgsApi.receivePayment(organization.id, _item, _price!);
      final paymentData = Payment.fromJson(response.data);
      final bool isInStorePaymentType = paymentType == PaymentType.InStore;

      if (isInStorePaymentType) {
        paymentData.cpPaymentUrl =
            paymentData.cpPaymentUrl!.replaceFirst('checkout', 'pos');
      }

      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReceiveMoneyGenerateLinkScreen(
              organization: organization,
              payment: paymentData,
            ),
          ),
        );
      }
    } catch (error) {
      print(error);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  getButtonTextByPaymentType(PaymentType type) {
    switch (type) {
      case PaymentType.Online:
        return Text(AppLocalizations.of(context)!
            .receiveMoneyScreen_label_generate_link);
      case PaymentType.InStore:
        return const Text('Generate Payment QR-Code');
      default:
        return const Text('Generate Payment Link');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      title: AppLocalizations.of(context)!.receiveMoneyScreen_title,
      child: InputForm(
        formKey: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
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
                    _price = double.tryParse(value);
                  });
                }),
            Expanded(
              flex: 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 290,
                    child: ElevatedButton(
                      onPressed: _item.isEmpty || _price == null || isLoading
                          ? null
                          : handleGeneratePressed,
                      child: isLoading
                          ? const CircularProgressIndicator.adaptive()
                          : getButtonTextByPaymentType(paymentType),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
