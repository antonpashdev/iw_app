import 'package:flutter/material.dart';
import 'package:iw_app/l10n/generated/app_localizations.dart';
import 'package:iw_app/models/organization_model.dart';
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
        children: [
          const SizedBox(height: 10),
          const Text(
            'Set percentage of income that will be automatically reserved for organization needs.',
            style: TextStyle(color: COLOR_GRAY),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Flexible(
                flex: 4,
                child: Text(
                  'Treasury',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Flexible(
                flex: 1,
                child: AppTextFormFieldBorderedSm(
                  textAlign: TextAlign.center,
                  label: const Text('%'),
                  suffix: const Text('%'),
                  inputType: TextInputType.number,
                  validator: numberField('Treasury'),
                  errorStyle: const TextStyle(height: 0.01),
                  onChanged: (value) {
                    widget.organization.settings.treasury =
                        int.tryParse(value) ?? 0;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  handleNextPressed() {
    if (formKey.currentState!.validate()) {
      print(widget.organization);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBtnDisabled =
        formKey.currentState != null && formKey.currentState!.validate();

    return SafeArea(
      child: Scaffold(
        backgroundColor: COLOR_WHITE,
        appBar: AppBar(
          title: const Text('Treasury'),
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
      ),
    );
  }
}
