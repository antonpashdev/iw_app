import 'package:flutter/material.dart';
import 'package:iw_app/api/orgs_api.dart';
import 'package:iw_app/models/offer_model.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/screens/offer/offer_preview_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/list/generic_list_tile.dart';
import 'package:iw_app/widgets/media/network_image_auth.dart';

buildPendingOffers(
  BuildContext context,
  Future<List<Offer>> futureInvestOffers,
  Organization organization,
) {
  return FutureBuilder(
    future: futureInvestOffers,
    builder: (context, snapshot) {
      if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return Container();
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          Text(
            'Pending Investment Proposals',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 15),
          Column(
            children: [
              ...snapshot.data!
                  .map((offer) => _buildOffer(context, offer, organization))
                  .toList(),
            ],
          ),
        ],
      );
    },
  );
}

_buildOffer(BuildContext context, Offer offer, Organization organization) {
  return InkWell(
    onTap: () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => OfferPreviewScreen(
            organization: organization,
            member: offer.memberProspects!.firstOrNull,
            offer: offer,
          ),
        ),
      );
    },
    child: GenericListTile(
      title: organization.name,
      subtitle: 'Investment Proposal',
      image: NetworkImageAuth(
        imageUrl: '${orgsApi.baseUrl}${organization.logo!}',
      ),
      primaryColor: COLOR_ORANGE,
      icon: Text(
        '!',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: COLOR_WHITE,
              fontWeight: FontWeight.bold,
            ),
      ),
      trailingText: const Text(
        'View',
        style: TextStyle(color: COLOR_WHITE),
      ),
    ),
  );
}
