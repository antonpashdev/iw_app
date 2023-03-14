import 'package:flutter/material.dart';
import 'package:iw_app/l10n/generated/app_localizations.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/utils/validation.dart';
import 'package:iw_app/widgets/form/input_form.dart';
import 'package:iw_app/widgets/list/keyboard_dismissable_list.dart';

class CreateOrgNameScreen extends StatefulWidget {
  final Organization organization;

  const CreateOrgNameScreen({Key? key, required this.organization})
      : super(key: key);

  @override
  State<CreateOrgNameScreen> createState() => _CreateOrgNameScreenState();
}

class _CreateOrgNameScreenState extends State<CreateOrgNameScreen> {
  final formKey = GlobalKey<FormState>();

  handleNextPressed() {
    if (formKey.currentState!.validate()) {
      print(widget.organization);
    }
  }

  buildForm() {
    return InputForm(
      formKey: formKey,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: COLOR_LIGHT_GRAY,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: AppTextFormField(
                  labelText: AppLocalizations.of(context)!
                      .createOrgNameScreen_nameLabel,
                  textInputAction: TextInputAction.next,
                  validator: requiredField,
                  onChanged: (value) {
                    setState(() {
                      widget.organization.name = value;
                    });
                  },
                ),
              )
            ],
          ),
          const SizedBox(height: 30),
          AppTextFormField(
            labelText:
                AppLocalizations.of(context)!.createOrgNameScreen_linkLabel,
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              setState(() {
                widget.organization.link = value;
              });
            },
          ),
          const SizedBox(height: 30),
          AppTextFormField(
            labelText: AppLocalizations.of(context)!
                .createOrgNameScreen_descriptionLabel,
            textInputAction: TextInputAction.done,
            onChanged: (value) {
              setState(() {
                widget.organization.description = value;
              });
            },
            onFieldSubmitted: (value) {
              setState(() {
                widget.organization.description = value;
              });
              handleNextPressed();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isBtnDisabled =
        formKey.currentState == null || !formKey.currentState!.validate();

    return SafeArea(
      child: Scaffold(
        backgroundColor: COLOR_WHITE,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.createOrgNameScreen_title),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: KeyboardDismissableListView(
                padding: const EdgeInsets.all(30),
                children: [
                  buildForm(),
                ],
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
