import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iw_app/api/orgs_api.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/screens/offer/offer_investor_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/buttons/gray_button.dart';
import 'package:iw_app/widgets/media/network_image_auth.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

class OrgSettingsScreen extends StatelessWidget {
  final Organization organization;

  const OrgSettingsScreen({
    Key? key,
    required this.organization,
  }) : super(key: key);

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
              imageUrl: '${orgsApi.baseUrl}${organization.logo!}',
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${organization.name}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 5),
              if (organization.link != null)
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.link),
                  label: Text(organization.link!),
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

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      title: 'Organization Info',
      child: ListView(
        children: [
          buildHeader(context),
          const SizedBox(height: 20),
          if (organization.description != null)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: COLOR_LIGHT_GRAY3,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                organization.description!,
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
                    organization: organization,
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
        ],
      ),
    );
  }
}
