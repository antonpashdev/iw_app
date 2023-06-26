import 'package:flutter/material.dart';
import 'package:iw_app/models/offer_model.dart';
import 'package:iw_app/screens/offer/offer_investor_preview.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

import '../../utils/validation.dart';
import '../../widgets/form/boarded_textfield_with_title.dart';

class OfferInvestorInvestAmount extends StatefulWidget {
  final double maxEquity;
  final double maxInvestment;
  final Offer offer;

  const OfferInvestorInvestAmount({
    Key? key,
    required this.maxEquity,
    required this.maxInvestment,
    required this.offer,
  }) : super(key: key);

  @override
  State<OfferInvestorInvestAmount> createState() =>
      _OfferInvestorInvestAmountState();
}

class _OfferInvestorInvestAmountState extends State<OfferInvestorInvestAmount> {
  final amountController = TextEditingController();
  final equityController = TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();

  _onMaxTapped() {
    equityController.text = widget.maxEquity.toString();
    amountController.text = widget.maxInvestment.toString();
  }

  onPreviewTap() {
    if (!formGlobalKey.currentState!.validate()) {
      return;
    }
    final amount = double.parse(amountController.text);
    final equity = double.parse(equityController.text);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OfferInvestorPreview(
          offer: widget.offer,
          amount: amount,
          equity: equity,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      title: 'Your Investment',
      child: Form(
        key: formGlobalKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 5),
            Text(
              'Enter Sum or Percentage (${widget.maxEquity}% max)',
              style: const TextStyle(color: COLOR_GRAY),
            ),
            const SizedBox(height: 25),
            BoardedTextFieldWithTitle(
              title: 'You Invest',
              textFieldController: amountController,
              onSuffixTap: _onMaxTapped,
              prefix: '\$',
              suffix: 'Max',
              focus: true,
              validator: multiValidate(
                [
                  requiredField('You Invest'),
                  numberField('You Invest'),
                  max(widget.maxInvestment),
                ],
              ),
              onChanged: (value) {
                final amount = double.tryParse(value);
                if (amount != null) {
                  final equity =
                      widget.maxEquity * (amount / widget.maxInvestment);
                  equityController.text = equity.toString();
                }
              },
            ),
            const SizedBox(height: 15),
            BoardedTextFieldWithTitle(
              title: 'Your Equity',
              textFieldController: equityController,
              onSuffixTap: _onMaxTapped,
              prefix: '%',
              suffix: 'Max',
              validator: multiValidate(
                [
                  requiredField('Your Equity'),
                  numberField('Your Equity'),
                  max(widget.maxEquity),
                ],
              ),
              onChanged: (value) {
                final equity = double.tryParse(value);
                if (equity != null) {
                  final amount =
                      widget.maxInvestment * (equity / widget.maxEquity);
                  amountController.text = amount.toString();
                }
              },
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 290,
                    child: ElevatedButton(
                      onPressed: onPreviewTap,
                      child: const Text('Preview'),
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
