import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iw_app/l10n/generated/app_localizations.dart';
import 'package:iw_app/models/config_model.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/screens/organization/org_creation_progress_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/components/new_member_form.dart';
import 'package:iw_app/widgets/components/new_owner_member_form_lite.dart';
import 'package:iw_app/widgets/list/keyboard_dismissable_list.dart';
import 'package:iw_app/widgets/state/config.dart';

class CreateOrgMemberScreen extends StatefulWidget {
  final Organization organization;

  const CreateOrgMemberScreen({Key? key, required this.organization})
      : super(key: key);

  @override
  State<CreateOrgMemberScreen> createState() => _CreateOrgMemberScreenState();
}

class _CreateOrgMemberScreenState extends State<CreateOrgMemberScreen> {
  final formKey = GlobalKey<FormState>();
  final compensationCtrl = TextEditingController();

  OrganizationMember member = OrganizationMember(
    occupation: 'Founder',
    role: MemberRole.Member,
  );
  bool isLoading = false;

  buildForm() {
    Config config = ConfigState.of(context).config;
    if (config.mode == Mode.Lite) {
      return NewOwnerMemberFormLite(
        formKey: formKey,
        member: member,
        title: AppLocalizations.of(context)!.createOrgMemberScreen_description,
      );
    }
    return NewMemberForm(
      formKey: formKey,
      member: member,
      title: AppLocalizations.of(context)!.createOrgMemberScreen_description,
    );
  }

  handleNextPressed() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => OrgCreationProgressScreen(
          organization: widget.organization,
          member: member,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: APP_BODY_BG,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: Text(
          AppLocalizations.of(context)!.createOrgMemberScreen_title,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: KeyboardDismissableListView(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                children: [buildForm()],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 290,
              child: ElevatedButton(
                onPressed: isLoading ? null : handleNextPressed,
                child: isLoading
                    ? const CircularProgressIndicator.adaptive()
                    : Text(AppLocalizations.of(context)!.next),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
