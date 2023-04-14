import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iw_app/api/models/org_offers_filter_model.dart';
import 'package:iw_app/api/orgs_api.dart';
import 'package:iw_app/models/offer_model.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/screens/offer/offer_investor_screen.dart';
import 'package:iw_app/screens/offer/offer_preview_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/buttons/gray_button.dart';
import 'package:iw_app/widgets/list/generic_list_tile.dart';
import 'package:iw_app/widgets/media/network_image_auth.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

class OrgSettingsScreen extends StatefulWidget {
  final Organization organization;

  const OrgSettingsScreen({
    Key? key,
    required this.organization,
  }) : super(key: key);

  @override
  State<OrgSettingsScreen> createState() => _OrgSettingsScreenState();
}

class _OrgSettingsScreenState extends State<OrgSettingsScreen> {
  late Future<List<Offer>> futureInvestOffers;

  @override
  initState() {
    super.initState();
    futureInvestOffers = fetchInvestOffers();
  }

  Future<List<Offer>> fetchInvestOffers() async {
    try {
      final filter = OrgOffersFilter(
        status: OfferStatus.Pending,
        role: MemberRole.Investor,
      );
      final response = await orgsApi.getOffers(
        widget.organization.id!,
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

  buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: COLOR_GRAY,
            borderRadius: BorderRadius.circular(20),
          ),
          clipBehavior: Clip.antiAlias,
          child: FittedBox(
            fit: BoxFit.cover,
            child: NetworkImageAuth(
              imageUrl: '${orgsApi.baseUrl}${widget.organization.logo!}',
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.organization.name}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 5),
              if (widget.organization.link != null)
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.link),
                  label: Text(widget.organization.link!),
                  style: TextButton.styleFrom(
                    iconColor: COLOR_BLUE,
                    foregroundColor: COLOR_BLUE,
                  ),
                )
            ],
          ),
        ),
      ],
    );
  }

  buildOffer(BuildContext context, Offer offer) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => OfferPreviewScreen(
              organization: widget.organization,
              member: offer.memberProspect!,
              offer: offer,
            ),
          ),
        );
      },
      child: GenericListTile(
        title: widget.organization.name,
        subtitle: 'Investment Proposal',
        image: NetworkImageAuth(
          imageUrl: '${orgsApi.baseUrl}${widget.organization.logo!}',
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

  buildPendingOffers(BuildContext context) {
    return FutureBuilder(
      future: futureInvestOffers,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Container();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
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
                    .map((offer) => buildOffer(context, offer))
                    .toList(),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      title: 'Organization Info',
      child: ListView(
        children: [
          buildHeader(context),
          const SizedBox(height: 20),
          if (widget.organization.description != null)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: COLOR_LIGHT_GRAY3,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                widget.organization.description!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          const SizedBox(height: 35),
          GrayButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => OfferInvestorScreen(
                    organization: widget.organization,
                  ),
                ),
              );
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Raise Money'),
                SvgPicture.asset('assets/icons/raise_money.svg'),
              ],
            ),
          ),
          buildPendingOffers(context),
        ],
      ),
    );
  }
}
