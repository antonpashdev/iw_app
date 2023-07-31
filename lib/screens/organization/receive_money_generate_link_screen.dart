import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iw_app/l10n/generated/app_localizations.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/models/payment_model.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/components/url_qr_code.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';
import 'package:url_launcher/url_launcher.dart';

class ReceiveMoneyGenerateLinkScreen extends StatelessWidget {
  final Organization organization;
  final Payment payment;

  const ReceiveMoneyGenerateLinkScreen({
    super.key,
    required this.organization,
    required this.payment,
  });

  callSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 70,
          left: 20,
          right: 20,
        ),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
        ),
        duration: const Duration(milliseconds: 300),
        backgroundColor: Colors.black.withOpacity(0.7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  handleCopyPressed(BuildContext context) {
    Clipboard.setData(ClipboardData(text: payment.cpPaymentUrl!));
    callSnackBar(
      context,
      AppLocalizations.of(context)!.common_link_copied,
    );
  }

  handleCopyWalletPressed(BuildContext context) {
    Clipboard.setData(ClipboardData(text: organization.wallet!));
    callSnackBar(
      context,
      'Wallet Address copied',
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      title: 'Link',
      child: Column(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                'Organization’s Solana Wallet',
                style: TextStyle(
                  color: COLOR_GRAY,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: TextButton.icon(
                      label: Text(
                        organization.wallet!,
                        overflow: TextOverflow.ellipsis,
                      ),
                      icon: const Icon(Icons.copy, size: 12),
                      onPressed: () => handleCopyWalletPressed(context),
                    ),
                  ),
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
                    ),
                  ),
                ],
              ),
            ],
          ),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 300),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          )
                        ],
                      ),
                      child: QRCodeWidget(
                        url: payment.cpPaymentUrl!,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  'Show QR-code or send link below to let \npay for your products and services',
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: TextStyle(color: COLOR_GRAY),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () async {
                    final url = Uri.parse(payment.cpPaymentUrl!);
                    if (!(await launchUrl(url))) {
                      throw Exception('Could not launch $url');
                    }
                  },
                  icon: const Icon(Icons.link),
                  label: Text(
                    payment.cpPaymentUrl!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  style: TextButton.styleFrom(
                    iconColor: COLOR_BLUE,
                    foregroundColor: COLOR_BLUE,
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: 290,
                    child: ElevatedButton(
                      onPressed: () => handleCopyPressed(context),
                      child: const Text('Copy Payment Link'),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
