import 'package:flutter/material.dart';
import 'package:iw_app/models/offer_model.dart';
import 'package:iw_app/widgets/components/bottom_sheet_info.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

import '../../api/orgs_api.dart';
import '../../theme/app_theme.dart';
import '../../widgets/buttons/secondary_button.dart';
import '../../widgets/media/network_image_auth.dart';

class OfferInvestorPreview extends StatelessWidget {
  final Offer offer;
  final double invested;
  final double equity;

  const OfferInvestorPreview(
      {Key? key,
      required this.offer,
      required this.invested,
      required this.equity})
      : super(key: key);

  acceptOffer() {}

  onInvestTap(BuildContext context) {
    showBottomInfoSheet(
      context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Confirm to send money.',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Gilroy',
            ),
          ),
          const SizedBox(height: 15),
          Text(
            'By signing this transaction You will get $equity% of equity of ${offer.org.name}.',
            style: const TextStyle(
              fontFamily: 'Gilroy',
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'This transaction will be recorded on blockchain.',
            style: TextStyle(
              fontFamily: 'Gilroy',
            ),
          ),
          const SizedBox(height: 35),
          SecondaryButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              acceptOffer();
            },
            child: Text(
              'Send \$${invested.toStringAsFixed(2)}',
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      title: 'Preview',
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: COLOR_GRAY,
                  borderRadius: BorderRadius.circular(30),
                ),
                clipBehavior: Clip.antiAlias,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: NetworkImageAuth(
                    imageUrl: '${orgsApi.baseUrl}${offer.org.logo!}',
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Invest to',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: COLOR_GRAY,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${offer.org.name}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      '@${offer.org.username}',
                      style: const TextStyle(color: COLOR_GRAY),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: COLOR_LIGHT_GRAY,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'You Invest',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '$invested USDC',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Your Equity',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '$equity%',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 290,
                  child: ElevatedButton(
                    onPressed: () {
                      onInvestTap(context);
                    },
                    child: const Text('Invest'),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
