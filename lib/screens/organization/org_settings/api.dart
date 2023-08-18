import 'package:iw_app/api/models/org_offers_filter_model.dart';
import 'package:iw_app/api/orgs_api.dart';
import 'package:iw_app/models/offer_model.dart';
import 'package:iw_app/models/organization_model.dart';

Future<List<Offer>> fetchInvestOffers(Organization organization) async {
  try {
    final filter = OrgOffersFilter(
      status: OfferStatus.Pending,
      type: OfferType.Investor,
    );
    final response = await orgsApi.getOffers(
      organization.id!,
      filter,
    );
    final offers =
        (response.data as List).map((json) => Offer.fromJson(json)).toList();
    return offers;
  } catch (err) {
    print(err);
  }
  return [];
}
