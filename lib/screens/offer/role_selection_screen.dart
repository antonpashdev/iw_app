import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iw_app/l10n/generated/app_localizations.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/screens/offer/offer_preview_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

class RoleSelectionScreen extends StatefulWidget {
  final OrganizationMember member;
  final Organization organization;

  const RoleSelectionScreen(
      {Key? key, required this.member, required this.organization})
      : super(key: key);

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
        ),
      ),
    );
  }

  buildMemberDescription(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: COLOR_LIGHT_GRAY3,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(CupertinoIcons.doc_text),
        minLeadingWidth: 0,
        title: Text('Only can view all the information about Organization'),
      ),
    );
  }

  buildAdminDescription(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: COLOR_LIGHT_GRAY3,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: const [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.file_upload_outlined),
            minLeadingWidth: 0,
            title: Text(
                'Send limited amount of money from the Organization’s wallet set by owner'),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.person_add_alt),
            minLeadingWidth: 0,
            title: Text('Invite new members'),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.edit_note_sharp),
            minLeadingWidth: 0,
            title: Text('Edit Organization’s info'),
          ),
        ],
      ),
    );
  }

  buildCoOwnerDescription(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: COLOR_LIGHT_GRAY3,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.account_balance_wallet_rounded),
            minLeadingWidth: 0,
            title: Text('Send any sum of money from Organization’s wallet'),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: SvgPicture.asset(
              'assets/icons/raise_money.svg',
              colorFilter: const ColorFilter.mode(
                COLOR_GRAY,
                BlendMode.srcIn,
              ),
            ),
            minLeadingWidth: 0,
            title: const Text('Raise money'),
          ),
          const ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.person_remove_alt_1_outlined),
            minLeadingWidth: 0,
            title: Text('Remove members from Organization'),
          ),
          const ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.person_add_alt),
            minLeadingWidth: 0,
            title: Text('Invite new members'),
          ),
          const ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.edit_note_sharp),
            minLeadingWidth: 0,
            title: Text('Edit Organization’s info'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
        title: 'Choose Role',
        child: Stack(
          children: [
            Positioned.fill(
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
                  buildMemberDescription(context),
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
                  buildAdminDescription(context),
                  const SizedBox(height: 30),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Co-owner'),
                    leading: Radio(
                      activeColor: Colors.black,
                      value: MemberRole.CoOwner,
                      groupValue: _role,
                      onChanged: (MemberRole? role) {
                        setState(() {
                          _role = role!;
                        });
                      },
                    ),
                  ),
                  buildCoOwnerDescription(context),
                  const SizedBox(height: 100),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Center(
                child: SizedBox(
                  width: 290,
                  child: ElevatedButton(
                    onPressed: handleNext,
                    child: Text(AppLocalizations.of(context)!.common_next),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
