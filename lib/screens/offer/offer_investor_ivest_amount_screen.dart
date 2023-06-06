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
  final yourInvestmentController = TextEditingController();
  final yourEquityController = TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();

  _onMaxTapped() {
    yourEquityController.text = widget.maxEquity.toString();
    yourInvestmentController.text = widget.maxInvestment.toString();
  }

  onPreviewTap() {
    if (!formGlobalKey.currentState!.validate()) {
      print('not validated');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OfferInvestorPreview(
          offer: widget.offer,
          invested: 1.0,
          equity: 1.0,
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
              textFieldController: yourInvestmentController,
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
            ),
            const SizedBox(height: 15),
            BoardedTextFieldWithTitle(
              title: 'Your Equity',
              textFieldController: yourEquityController,
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
