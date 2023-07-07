import 'package:flutter/material.dart';
import 'package:iw_app/l10n/generated/app_localizations.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/utils/validation.dart';
import 'package:iw_app/widgets/buttons/secondary_button.dart';
import 'package:iw_app/widgets/components/bottom_sheet_info.dart';
import 'package:iw_app/widgets/form/input_form.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

class ChangeTreasuryScreen extends StatefulWidget {
  final Organization organization;

  const ChangeTreasuryScreen({
    Key? key,
    required this.organization,
  }) : super(key: key);

  @override
  State<ChangeTreasuryScreen> createState() => _ChangeTreasuryScreenState();
}

class _ChangeTreasuryScreenState extends State<ChangeTreasuryScreen> {
  late int treasury;
  final formKey = GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
    treasury = widget.organization.settings?.treasury ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      title: 'Change Treasury',
      child: InputForm(
        formKey: formKey,
        child: Column(
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    AppLocalizations.of(context)!
                        .createOrgSettingsScreen_description,
                    style: const TextStyle(color: COLOR_GRAY),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 3,
                        child: Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!
                                  .createOrgSettingsScreen_treasuryLabel,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              onPressed: () {
                                showBottomInfoSheet(
                                  context,
                                  title: AppLocalizations.of(context)!
                                      .createOrgSettingsScreen_treasuryLabel,
                                  description: AppLocalizations.of(context)!
                                      .treasury_description,
                                );
                              },
                              icon: const Icon(Icons.info_outline_rounded),
                              iconSize: 16,
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              color: COLOR_GRAY,
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: AppTextFormFieldBordered(
                          textAlign: TextAlign.center,
                          label: const Text('%'),
                          suffix: const Text('%'),
                          inputType: TextInputType.number,
                          validator: multiValidate([
                            numberField('Treasury'),
                            min(0),
                            max(100),
                          ]),
                          errorStyle: const TextStyle(height: 0.01),
                          size: AppTextFormSize.small,
                          initialValue: treasury.toString(),
                          onChanged: (value) {
                            setState(() {
                              setState(() {
                                treasury = int.tryParse(value) ?? 0;
                              });
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                SizedBox(
                  width: 290,
                  child: ElevatedButton(
                    onPressed: () {
                      print(treasury);
                    },
                    child: const Text('Save'),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 290,
                  child: SecondaryButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
