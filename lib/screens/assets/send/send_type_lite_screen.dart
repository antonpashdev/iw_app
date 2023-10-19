import 'package:flutter/material.dart';
import 'package:iw_app/constants/send_asset_type.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/screens/assets/send/receiver_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

class SendTypeLiteScreen extends StatelessWidget {
  final Organization organization;
  final OrganizationMember member;

  const SendTypeLiteScreen({
    Key? key,
    required this.organization,
    required this.member,
  }) : super(key: key);

  onTypeSelect(BuildContext ctx, SendAssetType type) {
    Navigator.push(
      ctx,
      MaterialPageRoute(
        builder: (context) => ReceiverScreen(
          organization: organization,
          member: member,
          sendAssetType: type,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      title: 'Send equity',
      child: Padding(
        padding: const EdgeInsets.only(top: 35.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextButton(
              onPressed: () {
                onTypeSelect(context, SendAssetType.ToUser);
              },
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Container(
                        width: 50,
                        height: 50,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: COLOR_GRAY,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.person,
                          color: COLOR_WHITE,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                  const Expanded(flex: 2, child: Text('to Personal account')),
                ],
              ),
            ),
            const SizedBox(height: 40),
            TextButton(
              onPressed: () {
                onTypeSelect(context, SendAssetType.ToOrg);
              },
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Container(
                        width: 50,
                        height: 50,
                        clipBehavior: Clip.hardEdge,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: COLOR_GRAY,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Image.asset(
                          'assets/icons/organization.png',
                        ),
                      ),
                    ),
                  ),
                  const Expanded(
                    flex: 2,
                    child: Text('to Organization or Project'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
