import 'package:flutter/material.dart';
import 'package:iw_app/l10n/generated/app_localizations.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/screens/organization/create_org_member_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/utils/validation.dart';
import 'package:iw_app/widgets/form/input_form.dart';

class CreateOrgSettingsScreen extends StatefulWidget {
  final Organization organization;

  const CreateOrgSettingsScreen({Key? key, required this.organization})
      : super(key: key);

  @override
  State<CreateOrgSettingsScreen> createState() =>
      _CreateOrgSettingsScreenState();
}

class _CreateOrgSettingsScreenState extends State<CreateOrgSettingsScreen> {
  final formKey = GlobalKey<FormState>();
  buildForm() {
    return InputForm(
      formKey: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            AppLocalizations.of(context)!.createOrgSettingsScreen_description,
            style: const TextStyle(color: COLOR_GRAY),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 3,
                child: Text(
                  AppLocalizations.of(context)!
                      .createOrgSettingsScreen_treasuryLabel,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Flexible(
                flex: 1,
                child: AppTextFormFieldBordered(
                  textAlign: TextAlign.center,
                  label: const Text('%'),
                  suffix: const Text('%'),
                  inputType: TextInputType.number,
                  validator: numberField('Treasury'),
                  errorStyle: const TextStyle(height: 0.01),
                  size: AppTextFormSize.small,
                  onChanged: (value) {
                    setState(() {
                      widget.organization.settings.treasury =
                          int.tryParse(value) ?? 0;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  handleNextPressed(BuildContext context) {
    if (formKey.currentState!.validate()) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => CreateOrgMemberScreen(
            organization: widget.organization,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBtnDisabled =
        formKey.currentState != null && !formKey.currentState!.validate();

    return SafeArea(
      child: Scaffold(
        backgroundColor: COLOR_WHITE,
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.createOrgSettingsScreen_title,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: buildForm(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed:
                      isBtnDisabled ? null : () => handleNextPressed(context),
                  child: Text(AppLocalizations.of(context)!.next),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
