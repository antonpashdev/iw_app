import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

class ReceiveMoneyGenerateLinkScreen extends StatelessWidget {
  final Organization organization;

  const ReceiveMoneyGenerateLinkScreen({super.key, required this.organization});

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
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
                    child: TextButton.icon(
                      label: const Text('USDC'),
                      icon: SvgPicture.asset('assets/icons/usdc-icon.svg'),
                      onPressed: () {},
                    )),
              ]),
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
                                const SizedBox(height: 20),
                                Container(
                                    alignment: Alignment.center,
                                    width: 250,
                                    height: 250,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              blurRadius: 10,
                                              offset: const Offset(0, 5))
                                        ]))
                              ],
                            )),
                        const SizedBox(height: 50),
                        const Text(
                            'Get payments in any supported method (USDC, card, bank wire, ACH future rails) will settle as USDC in your Circle Account.',
                            textAlign: TextAlign.start,
                            style: TextStyle(color: COLOR_GRAY)),
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
                              child: const Text(
                                  'https://iwallet.com/123456789ewoihfiuiwegfuiwegf8iweygfiweujyfgwiefywegfifyuwegif',
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ),
                          TextButton.icon(
                            label: const Text('Copy'),
                            icon: const Icon(Icons.copy, size: 12),
                            onPressed: () {},
                          )
                        ]),
                      ]))
            ]));
  }
}
