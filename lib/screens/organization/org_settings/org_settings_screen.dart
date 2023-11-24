import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iw_app/models/config_model.dart';
import 'package:iw_app/models/offer_model.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/screens/offer/offer_investor_screen.dart';
import 'package:iw_app/screens/offer/offer_new_member_screen.dart';
import 'package:iw_app/screens/organization/change_treasury_screen.dart';
import 'package:iw_app/screens/organization/org_edit/org_edit_screen.dart';
import 'package:iw_app/screens/organization/org_settings/api.dart';
import 'package:iw_app/screens/organization/org_settings/builders/header.dart';
import 'package:iw_app/screens/organization/org_settings/builders/pending_offers_list.dart';
import 'package:iw_app/screens/organization/receive_money_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/buttons/gray_button.dart';
import 'package:iw_app/widgets/components/round_border_container.dart';
import 'package:iw_app/widgets/list/keyboard_dismissable_list.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';
import 'package:iw_app/widgets/state/config.dart';

class OrgSettingsScreen extends StatefulWidget {
  final Organization organization;
  final OrganizationMember member;

  const OrgSettingsScreen({
    Key? key,
    required this.organization,
    required this.member,
  }) : super(key: key);

  @override
  State<OrgSettingsScreen> createState() => _OrgSettingsScreenState();
}

class _OrgSettingsScreenState extends State<OrgSettingsScreen> {
  late Future<List<Offer>> futureInvestOffers;

  Config get config {
    return ConfigState.of(context).config;
  }

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

  onChangeTrasuryPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChangeTreasuryScreen(
          organization: widget.organization,
        ),
      ),
    );
  }

  onInviteMemberPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OfferNewMemberScreen(
          organization: widget.organization,
        ),
      ),
    );
  }

  onReceivePressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReceiveMoneyScreen(
          organization: widget.organization,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      title: 'Organization Info',
      actions: widget.member.permissions!.canEditOrg
          ? [
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => OrgEditScreen(
                        organization: widget.organization,
                      ),
                    ),
                  );
                },
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                child: const Text(
                  'Edit',
                  style: TextStyle(color: COLOR_BLUE),
                ),
              ),
            ]
          : [],
      child: KeyboardDismissableListView(
        children: [
          buildHeader(context, widget.organization),
          const SizedBox(height: 20),
          if (widget.organization.description != null)
            RoundBorderContainer(
              child: Text(
                widget.organization.description!,
                style: const TextStyle(fontSize: 18),
                softWrap: true,
              ),
            ),
          const SizedBox(height: 30),
          GrayButton(
            onPressed: onReceivePressed,
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Receive'),
                Icon(Icons.arrow_downward),
              ],
            ),
          ),
          const SizedBox(height: 10),
          GrayButton(
            onPressed: widget.member.permissions!.canRaiseMoney
                ? onRiseMoneyPressed
                : null,
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Raise Money'),
                Icon(CupertinoIcons.money_dollar_circle),
              ],
            ),
          ),
          const SizedBox(height: 10),
          if (config.mode == Mode.Pro)
            Column(
              children: [
                GrayButton(
                  onPressed: widget.member.permissions!.canChangeTreasury
                      ? onChangeTrasuryPressed
                      : null,
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Change Treasury'),
                      Icon(Icons.percent_rounded),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          GrayButton(
            onPressed: widget.member.permissions!.canInviteMembers
                ? onInviteMemberPressed
                : null,
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Invite member'),
                Icon(CupertinoIcons.person_badge_plus),
              ],
            ),
          ),
          buildPendingOffers(
            context,
            futureInvestOffers,
            widget.organization,
            canEdit: widget.member.permissions!.canEditOrg,
            onRevoke: () {
              setState(() {
                futureInvestOffers = fetchInvestOffers(widget.organization);
              });
            },
          ),
        ],
      ),
    );
  }
}
