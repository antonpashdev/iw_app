import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iw_app/api/orgs_api.dart';
import 'package:iw_app/l10n/generated/app_localizations.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/models/payment_model.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/components/url_qr_code.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

class ReceiveMoneyGenerateLinkScreen extends StatelessWidget {
  final Organization organization;
  final Payment payment;

  const ReceiveMoneyGenerateLinkScreen({
    super.key,
    required this.organization,
    required this.payment,
  });

  callSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 70,
          left: 20,
          right: 20,
        ),
        content: Text(AppLocalizations.of(context)!.common_link_copied,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white)),
        duration: const Duration(milliseconds: 300),
        backgroundColor: Colors.black.withOpacity(0.7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  handleCopyPressed(BuildContext context) {
    Clipboard.setData(ClipboardData(text: payment.cpPaymentUrl));
    callSnackBar(context);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
        title: 'Link',
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('Organization’s Crypto Wallet',
                  style: TextStyle(color: COLOR_GRAY)),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: 250,
                      padding: const EdgeInsets.only(right: 13.0),
                      child: TextButton.icon(
                        label: Text(organization.wallet!,
                            overflow: TextOverflow.ellipsis),
                        icon: const Icon(Icons.copy, size: 12),
                        onPressed: () {},
                      )),
                  Container(
                      padding: const EdgeInsets.only(right: 13.0),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/icons/usdc-icon.png',
                            width: 25,
                            height: 25,
                          ),
                          const SizedBox(width: 10),
                          const Text('USDC'),
                        ],
                      )),
                ],
              ),
              const SizedBox(height: 40),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              'QR',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 40),
                            Center(
                              child: Container(
                                  alignment: Alignment.center,
                                  width: 300,
                                  height: 300,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 10,
                                            offset: const Offset(0, 5))
                                      ]),
                                  child: QRCodeWidget(
                                    url: payment.cpPaymentUrl!,
                                    orgLogo: '${orgsApi.baseUrl}${organization.logo!}',
                                  )),
                            ),
                            const SizedBox(height: 50),
                            const Text(
                                'Get payments in any supported method (USDC, card, bank wire, ACH future rails) will settle as USDC in your Circle Account.',
                                textAlign: TextAlign.start,
                                softWrap: true,
                                style: TextStyle(color: COLOR_GRAY)),
                          ],
                        )),
                    const SizedBox(height: 30),
                    const Divider(),
                    const SizedBox(height: 30),
                    const Text(
                        'Send this link to let someone pay to your organization’s wallet',
                        textAlign: TextAlign.start,
                        style: TextStyle(color: COLOR_GRAY)),
                    const SizedBox(height: 20),
                    Row(children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.only(right: 13.0),
                          child: Text(
                            payment.cpPaymentUrl!,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      TextButton.icon(
                        label: const Text('Copy'),
                        icon: const Icon(Icons.copy, size: 12),
                        onPressed: () => handleCopyPressed(context),
                      )
                    ]),
                  ],
                ),
              )
            ]));
  }
}
