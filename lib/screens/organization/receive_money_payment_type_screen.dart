import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iw_app/constants/payment_type.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/screens/organization/receive_money_screen.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

class ReceiveMoneyPaymentTypeScreen extends StatelessWidget {
  final Organization organization;

  const ReceiveMoneyPaymentTypeScreen({super.key, required this.organization});

  onTypeSelect(BuildContext ctx, PaymentType type) {
    Navigator.push(
      ctx,
      MaterialPageRoute(
        builder: (context) => ReceiveMoneyScreen(
          organization: organization,
          paymentType: type,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      title: 'Type of Payment',
      child: Padding(
        padding: const EdgeInsets.only(top: 35.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextButton.icon(
              onPressed: () {
                onTypeSelect(context, PaymentType.InStore);
              },
              icon: SvgPicture.asset('assets/icons/in-store-icon.svg'),
              label: const Text('In-Store Payment'),
            ),
            const SizedBox(height: 40),
            TextButton.icon(
              onPressed: () {
                onTypeSelect(context, PaymentType.Online);
              },
              icon: SvgPicture.asset('assets/icons/online-payment.svg'),
              label: const Text('On-Line Payment'),
            )
          ],
        ),
      ),
    );
  }
}
