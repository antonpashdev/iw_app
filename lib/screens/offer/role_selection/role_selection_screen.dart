import 'package:flutter/material.dart';
import 'package:iw_app/l10n/generated/app_localizations.dart';
import 'package:iw_app/models/offer_model.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/screens/offer/offer_preview_screen.dart';
import 'package:iw_app/screens/offer/role_selection/builders.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

class RoleSelectionScreen extends StatefulWidget {
  final OrganizationMember member;
  final Organization organization;

  const RoleSelectionScreen({
    Key? key,
    required this.member,
    required this.organization,
  }) : super(key: key);

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionState();
}

class _RoleSelectionState extends State<RoleSelectionScreen> {
  OrganizationMember get member => widget.member;
  Organization get organization => widget.organization;
  late MemberRole _role;

  @override
  void initState() {
    super.initState();
    _role = member.role!;
  }

  handleNext() {
    member.role = _role;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OfferPreviewScreen(
          organization: organization,
          member: member,
          offer: Offer(type: OfferType.Regular),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      title: 'Choose Role',
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: [
                const SizedBox(height: 10),
                const Text(
                  'Roles below provide different levels of rights of governing organization',
                  style: TextStyle(color: COLOR_GRAY),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Role',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Member'),
                  leading: Radio(
                    activeColor: Colors.black,
                    value: MemberRole.Member,
                    groupValue: _role,
                    onChanged: (MemberRole? role) {
                      setState(() {
                        _role = role!;
                      });
                    },
                  ),
                ),
                buildMemberDescription(context, _role == MemberRole.Member),
                const SizedBox(height: 30),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Admin'),
                  leading: Radio(
                    activeColor: Colors.black,
                    value: MemberRole.Admin,
                    groupValue: _role,
                    onChanged: (MemberRole? role) {
                      setState(() {
                        _role = role!;
                      });
                    },
                  ),
                ),
                buildAdminDescription(context, _role == MemberRole.Admin),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 290,
            child: ElevatedButton(
              onPressed: handleNext,
              child: Text(AppLocalizations.of(context)!.common_next),
            ),
          ),
        ],
      ),
    );
  }
}
