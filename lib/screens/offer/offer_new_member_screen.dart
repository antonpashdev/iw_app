import 'package:flutter/material.dart';
import 'package:iw_app/l10n/generated/app_localizations.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/widgets/components/new_member_form.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

class OfferNewMemberScreen extends StatefulWidget {
  const OfferNewMemberScreen({Key? key}) : super(key: key);

  @override
  State<OfferNewMemberScreen> createState() => _OfferNewMemberScreen();
}

class _OfferNewMemberScreen extends State<OfferNewMemberScreen> {
  final formKey = GlobalKey<FormState>();

  OrganizationMember member = OrganizationMember(
    role: MemberRole.CoOwner,
  );

  handleNext() {
    print(member.toJson());
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
        title: 'Offer to a New Member',
        child: Column(
          children: <Widget>[
            NewMemberForm(
              title:
                  'Set the terms upon which a new member is invited to join organization',
              formKey: formKey,
              member: member,
            ),
            const Spacer(),
            SizedBox(
              width: 290,
              child: ElevatedButton(
                onPressed: handleNext,
                child: Text(AppLocalizations.of(context)!.common_next),
              ),
            )
          ],
        ));
  }
}
