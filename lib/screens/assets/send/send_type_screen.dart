import 'package:flutter/material.dart';
import 'package:iw_app/constants/send_asset_type.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/screens/assets/send/receiver_screen.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

class SendTypeScreen extends StatelessWidget {
  final Organization organization;
  final OrganizationMember member;

  const SendTypeScreen({
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
      title: 'Send Impact Shares',
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
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: Image.asset('assets/app_icon.png'),
                        ),
                      ),
                    ),
                  ),
                  const Expanded(flex: 2, child: Text('To Impact Wallet User')),
                ],
              ),
            ),
            const SizedBox(height: 40),
            TextButton(
              onPressed: () {
                onTypeSelect(context, SendAssetType.ToAddress);
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
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: Image.asset('assets/images/solana.png'),
                        ),
                      ),
                    ),
                  ),
                  const Expanded(
                    flex: 2,
                    child: Text('To Solana Wallet Address'),
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
