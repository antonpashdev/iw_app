import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iw_app/api/orgs_api.dart';
import 'package:iw_app/l10n/generated/app_localizations.dart';
import 'package:iw_app/models/config_model.dart';
import 'package:iw_app/models/sale_offer_model.dart';
import 'package:iw_app/screens/home_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/components/url_qr_code.dart';
import 'package:iw_app/widgets/list/keyboard_dismissable_list.dart';
import 'package:iw_app/widgets/media/network_image_auth.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';
import 'package:iw_app/widgets/state/config.dart';

const LAMPORTS_IN_SOL = 1000000000;

class SaleOfferPreviewScreen extends StatelessWidget {
  final SaleOffer saleOffer;

  const SaleOfferPreviewScreen({Key? key, required this.saleOffer})
      : super(key: key);

  String get offerUrl => 'app.equitywallet.org/saleoffer?i=${saleOffer.id}';

  buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: COLOR_GRAY,
            borderRadius: BorderRadius.circular(20),
          ),
          clipBehavior: Clip.antiAlias,
          child: FittedBox(
            fit: BoxFit.cover,
            child: NetworkImageAuth(
              imageUrl: '${orgsApi.baseUrl}${saleOffer.org.logo!}',
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${saleOffer.org.name}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '@${saleOffer.org.username}',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: COLOR_GRAY,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  buildDetails(BuildContext context) {
    Config config = ConfigState.of(context).config;
    final equity = ((saleOffer.tokensAmount! * LAMPORTS_IN_SOL) /
            saleOffer.org.lamportsMinted *
            100)
        .toStringAsFixed(1);
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: COLOR_LIGHT_GRAY,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          buildHeader(context),
          const SizedBox(height: 15),
          const Divider(
            color: COLOR_LIGHT_GRAY2,
            height: 1,
          ),
          const SizedBox(height: 20),
          if (config.mode == Mode.Pro)
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Number of Impact Shares'),
                    Text(
                      '${saleOffer.tokensAmount}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
              ],
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(config.mode == Mode.Pro ? 'Equity to Date' : 'Equity'),
              Text(
                '$equity%',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: COLOR_GREEN,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(
            color: COLOR_LIGHT_GRAY2,
            height: 1,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Price',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              Text(
                '\$${saleOffer.price}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ],
      ),
    );
  }

  callSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 70,
          left: 20,
          right: 20,
        ),
        content: Text(
          AppLocalizations.of(context)!.common_link_copied,
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

  handleCopyPressed(BuildContext context) async {
    Clipboard.setData(
      ClipboardData(
        text: offerUrl,
      ),
    );
    callSnackBar(context);

    await Future.delayed(const Duration(seconds: 2));

    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      title: 'Offer to Buy',
      child: KeyboardDismissableListView(
        children: [
          const SizedBox(height: 20),
          buildDetails(context),
          const SizedBox(height: 30),
          Column(
            children: [
              const SizedBox(height: 30),
              const Text(
                'This Offer is available by the link below. Send it to a person you want to sell iShares',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: COLOR_CORAL,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                offerUrl,
                textAlign: TextAlign.center,
                style: const TextStyle(color: COLOR_GRAY),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: 290,
                child: ElevatedButton(
                  onPressed: () => handleCopyPressed(context),
                  child: const Text('Copy Link to this Offer'),
                ),
              ),
              const SizedBox(height: 25),
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
                      url: offerUrl,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
            ],
          ),
        ],
      ),
    );
  }
}
