import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iw_app/models/offer_model.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/screens/offer/offer_investor_screen.dart';
import 'package:iw_app/screens/organization/org_settings/api.dart';
import 'package:iw_app/screens/organization/org_settings/builders/header.dart';
import 'package:iw_app/screens/organization/org_settings/builders/pending_offers_list.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/buttons/gray_button.dart';
import 'package:iw_app/widgets/components/round_border_container.dart';
import 'package:iw_app/widgets/list/keyboard_dismissable_list.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

class OrgSettingsScreen extends StatefulWidget {
  final Organization organization;
  final List<OrganizationMemberWithEquity> membersWithEquity;

  const OrgSettingsScreen({
    Key? key,
    required this.organization,
    required this.membersWithEquity,
  }) : super(key: key);

  @override
  State<OrgSettingsScreen> createState() => _OrgSettingsScreenState();
}

class _OrgSettingsScreenState extends State<OrgSettingsScreen> {
  late Future<List<Offer>> futureInvestOffers;

  @override
  initState() {
    super.initState();
    futureInvestOffers = fetchInvestOffers(widget.organization);
  }

  onRiseMoneyPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => OfferInvestorScreen(
          organization: widget.organization,
        ),
      ),
    );
  }

  onChangeTrasuryPressed() {}

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      title: 'Organization Info',
      child: KeyboardDismissableListView(
        children: [
          buildHeader(context, widget.organization),
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
          const SizedBox(height: 10),
          const RoundBorderContainer(
            child: Text(
              'Our first collaboration via Equity Wallet',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            ),
          ),
          const SizedBox(height: 30),
          GrayButton(
            onPressed: onRiseMoneyPressed,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Raise Money'),
                SvgPicture.asset('assets/icons/raise_money.svg'),
              ],
            ),
          ),
          const SizedBox(height: 10),
          GrayButton(
            onPressed: onChangeTrasuryPressed,
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Change Treasury'),
                Icon(Icons.percent_rounded),
              ],
            ),
          ),
          buildPendingOffers(context, futureInvestOffers, widget.organization),
        ],
      ),
    );
  }
}
