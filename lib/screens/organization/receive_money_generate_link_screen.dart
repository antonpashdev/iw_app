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

  handleCopyWalletPressed(BuildContext context) {
    Clipboard.setData(ClipboardData(text: organization.wallet!));
    callSnackBar(context);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
        title: 'Link',
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('Organization’s Solana Wallet',
                  style: TextStyle(color: COLOR_GRAY)),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      child: TextButton.icon(
                    label: Text(organization.wallet!,
                        overflow: TextOverflow.ellipsis),
                    icon: const Icon(Icons.copy, size: 12),
                    onPressed: () => handleCopyWalletPressed(context),
                  )),
                  Container(
                      padding: const EdgeInsets.only(left: 20.0),
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
                                    orgLogo:
                                        '${orgsApi.baseUrl}${organization.logo!}',
                                  )),
                            ),
                            const SizedBox(height: 25),
                            const Text(
                                'Show QR-code or send link below to let \npay for your products and services',
                                textAlign: TextAlign.center,
                                softWrap: true,
                                style: TextStyle(color: COLOR_GRAY)),
                          ],
                        )),
                    Row(children: <Widget>[
                      Flexible(
                        child: Text(
                          payment.cpPaymentUrl!,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      TextButton.icon(
                        label: const Text('Copy'),
                        icon: const Icon(Icons.copy, size: 12),
                        onPressed: () => handleCopyPressed(context),
                      )
                    ]),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: SizedBox(
                            width: 290,
                            child: ElevatedButton(
                                onPressed: () => handleCopyPressed(context),
                                child: const Text('Copy Payment Link'))),
                      ),
                    )
                  ],
                ),
              )
            ]));
  }
}
