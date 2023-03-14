import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iw_app/l10n/generated/app_localizations.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/screens/organization/create_org_name_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/utils/validation.dart';
import 'package:iw_app/widgets/form/input_form.dart';
import 'package:iw_app/widgets/list/keyboard_dismissable_list.dart';

class CreateOrgScreen extends StatefulWidget {
  const CreateOrgScreen({Key? key}) : super(key: key);

  @override
  State<CreateOrgScreen> createState() => _CreateOrgScreenState();
}

class _CreateOrgScreenState extends State<CreateOrgScreen> {
  final formKey = GlobalKey<FormState>();

  Organization organization = Organization();

  buildForm() {
    return InputForm(
      formKey: formKey,
      child: AppTextFormField(
        labelText: 'organization_username',
        prefix: '@',
        suffix: SvgPicture.asset(
          'assets/icons/check_filled.svg',
          width: 20,
        ),
        onChanged: (value) {
          setState(() {
            organization.username = value;
          });
        },
        validator: requiredField,
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (value) {
          setState(() {
            organization.username = value;
          });
          handleNextPressed();
        },
        helperText:
            AppLocalizations.of(context)!.createOrgScreen_usernameHelperText,
      ),
    );
  }

  handleNextPressed() {
    if (formKey.currentState!.validate()) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => CreateOrgNameScreen(
            organization: organization,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBtnDisabled =
        formKey.currentState == null || !formKey.currentState!.validate();

    return SafeArea(
      child: Scaffold(
        backgroundColor: COLOR_WHITE,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.createOrgScreen_title),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: KeyboardDismissableListView(
                padding: const EdgeInsets.all(30),
                children: [buildForm()],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: ElevatedButton(
                onPressed: isBtnDisabled ? null : handleNextPressed,
                child: Text(AppLocalizations.of(context)!.next),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
