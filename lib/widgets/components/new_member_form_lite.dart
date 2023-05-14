import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iw_app/l10n/generated/app_localizations.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/screens/generic_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/utils/validation.dart';
import 'package:iw_app/widgets/components/app_select.dart';
import 'package:iw_app/widgets/components/bottom_sheet_info.dart';
import 'package:iw_app/widgets/form/input_form.dart';
import 'package:iw_app/widgets/form/modal_form_field.dart';

class NewMemberFormLite extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final OrganizationMember member;
  final String title;
  final timeframeOptions = const [
    {'value': '1', 'title': 'days'},
    {'value': '2', 'title': 'weeks'},
    {'value': '3', 'title': 'months'},
    {'value': '4', 'title': 'years'},
  ];

  const NewMemberFormLite({
    Key? key,
    required this.formKey,
    required this.member,
    required this.title,
  }) : super(key: key);

  @override
  State<NewMemberFormLite> createState() => _NewMemberFormLiteState();
}

class _NewMemberFormLiteState extends State<NewMemberFormLite> {
  int? equityType;
  int? compensationType;

  OrganizationMember get member => widget.member;
  String get title => widget.title;

  onOccupationChanged(String value) {
    setState(() {
      member.occupation = value;
    });
  }

  onMonthlyCompensationChanged(String value) {
    setState(() {
      member.monthlyCompensation = double.tryParse(value) ?? 0;
    });
  }

  onIsMonthlyCompensatedChanged(bool value) {
    setState(() {
      member.isMonthlyCompensated = value;
    });
  }

  onAutoContributionChanged(bool value) {
    setState(() {
      member.isAutoContributing = value;
    });
  }

  buildEquitySection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Give Equity',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            CupertinoSwitch(
              value: widget.member.isMonthlyCompensated!,
              activeColor: COLOR_GREEN,
              onChanged: (bool? value) {
                onIsMonthlyCompensatedChanged(value!);
              },
            ),
          ],
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Row(
            children: [
              const Text('Immediately'),
              IconButton(
                onPressed: () {
                  showBottomInfoSheet(
                    context,
                    title: 'Give Equity Immediately',
                    description:
                        'A member will get allocated percent of equity right after signing an offer',
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
          minLeadingWidth: 0,
          leading: Radio(
            activeColor: Colors.black,
            value: 1,
            groupValue: equityType,
            onChanged: (int? type) {
              setState(() {
                equityType = type!;
              });
            },
          ),
        ),
        AppTextFormFieldBordered(
          enabled: widget.member.isMonthlyCompensated!,
          prefix: const Text('%'),
          inputType: const TextInputType.numberWithOptions(decimal: true),
          validator: widget.member.isMonthlyCompensated!
              ? multiValidate([
                  requiredField(
                    AppLocalizations.of(context)!
                        .createOrgMemberScreen_monthlyCompensationLabel,
                  ),
                  numberField(
                    AppLocalizations.of(context)!
                        .createOrgMemberScreen_monthlyCompensationLabel,
                  ),
                ])
              : (_) => null,
          onChanged: onMonthlyCompensationChanged,
        ),
        const SizedBox(height: 10),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Row(
            children: [
              const Text('During the period'),
              IconButton(
                onPressed: () {
                  showBottomInfoSheet(
                    context,
                    title: 'Give Equity During the Period',
                    description:
                        'Percent of equity will be broken down equally into amount of days. Every day during the period a member will get a part of allocated equity. For example: 10% during 100 days. It means that a member will get 0,1% every day during 100 days.',
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
          minLeadingWidth: 0,
          leading: Radio(
            activeColor: Colors.black,
            value: 2,
            groupValue: equityType,
            onChanged: (int? type) {
              setState(() {
                equityType = type!;
              });
            },
          ),
        ),
        Row(
          children: [
            Expanded(
              child: AppTextFormFieldBordered(
                enabled: widget.member.isMonthlyCompensated!,
                prefix: const Text('%'),
                inputType: const TextInputType.numberWithOptions(decimal: true),
                validator: widget.member.isMonthlyCompensated!
                    ? multiValidate([
                        requiredField(
                          AppLocalizations.of(context)!
                              .createOrgMemberScreen_monthlyCompensationLabel,
                        ),
                        numberField(
                          AppLocalizations.of(context)!
                              .createOrgMemberScreen_monthlyCompensationLabel,
                        ),
                      ])
                    : (_) => null,
                onChanged: onMonthlyCompensationChanged,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: AppTextFormFieldBordered(
                enabled: widget.member.isMonthlyCompensated!,
                labelText: 'period',
                validator: widget.member.isMonthlyCompensated!
                    ? multiValidate([
                        requiredField(
                          AppLocalizations.of(context)!
                              .createOrgMemberScreen_monthlyCompensationLabel,
                        ),
                        numberField(
                          AppLocalizations.of(context)!
                              .createOrgMemberScreen_monthlyCompensationLabel,
                        ),
                      ])
                    : (_) => null,
                onChanged: onMonthlyCompensationChanged,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ModalFormField<Map>(
                screenFactory: (value) => GenericScreen(
                  title: 'Select',
                  child: AppSelect(
                    value,
                    options: widget.timeframeOptions,
                    onChanged: (value) {
                      Navigator.of(context).pop(value);
                    },
                  ),
                ),
                valueToText: (value) => value?['title'],
                labelText: 'timeframe',
              ),
            ),
          ],
        ),
      ],
    );
  }

  buildCompensationSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Compensation',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            CupertinoSwitch(
              value: widget.member.isMonthlyCompensated!,
              activeColor: COLOR_GREEN,
              onChanged: (bool? value) {
                onIsMonthlyCompensatedChanged(value!);
              },
            ),
          ],
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Row(
            children: [
              const Text('Paycheck per month'),
              IconButton(
                onPressed: () {
                  showBottomInfoSheet(
                    context,
                    title: 'Paycheck per month',
                    description:
                        'The sum that will be sent to the member’s wallet from the organization’s wallet on the first of every month. (That is why Organization needs Treasury)',
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
          minLeadingWidth: 0,
          leading: Radio(
            activeColor: Colors.black,
            value: 1,
            groupValue: compensationType,
            onChanged: (int? type) {
              setState(() {
                compensationType = type!;
              });
            },
          ),
        ),
        AppTextFormFieldBordered(
          enabled: widget.member.isMonthlyCompensated!,
          prefix: const Text('\$'),
          inputType: const TextInputType.numberWithOptions(decimal: true),
          validator: widget.member.isMonthlyCompensated!
              ? multiValidate([
                  requiredField(
                    AppLocalizations.of(context)!
                        .createOrgMemberScreen_monthlyCompensationLabel,
                  ),
                  numberField(
                    AppLocalizations.of(context)!
                        .createOrgMemberScreen_monthlyCompensationLabel,
                  ),
                ])
              : (_) => null,
          onChanged: onMonthlyCompensationChanged,
        ),
        const SizedBox(height: 10),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Row(
            children: [
              const Text('One-time payment'),
              IconButton(
                onPressed: () {
                  showBottomInfoSheet(
                    context,
                    title: 'One-time payment',
                    description:
                        'This sum will be broken down equally into amount of days. Every day during the period a member will get a part of this sum. For example: \$100 during 100 days. It means that a member will get \$1 every day during 100 days.',
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
          minLeadingWidth: 0,
          leading: Radio(
            activeColor: Colors.black,
            value: 2,
            groupValue: compensationType,
            onChanged: (int? type) {
              setState(() {
                compensationType = type!;
              });
            },
          ),
        ),
        Row(
          children: [
            Expanded(
              child: AppTextFormFieldBordered(
                enabled: widget.member.isMonthlyCompensated!,
                prefix: const Text('\$'),
                inputType: const TextInputType.numberWithOptions(decimal: true),
                validator: widget.member.isMonthlyCompensated!
                    ? multiValidate([
                        requiredField(
                          AppLocalizations.of(context)!
                              .createOrgMemberScreen_monthlyCompensationLabel,
                        ),
                        numberField(
                          AppLocalizations.of(context)!
                              .createOrgMemberScreen_monthlyCompensationLabel,
                        ),
                      ])
                    : (_) => null,
                onChanged: onMonthlyCompensationChanged,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: AppTextFormFieldBordered(
                enabled: widget.member.isMonthlyCompensated!,
                labelText: 'period',
                validator: widget.member.isMonthlyCompensated!
                    ? multiValidate([
                        requiredField(
                          AppLocalizations.of(context)!
                              .createOrgMemberScreen_monthlyCompensationLabel,
                        ),
                        numberField(
                          AppLocalizations.of(context)!
                              .createOrgMemberScreen_monthlyCompensationLabel,
                        ),
                      ])
                    : (_) => null,
                onChanged: onMonthlyCompensationChanged,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ModalFormField<Map>(
                screenFactory: (value) => GenericScreen(
                  title: 'Select',
                  child: AppSelect(
                    value,
                    options: widget.timeframeOptions,
                    onChanged: (value) {
                      Navigator.of(context).pop(value);
                    },
                  ),
                ),
                valueToText: (value) => value?['title'],
                labelText: 'timeframe',
              ),
            ),
          ],
        ),
      ],
    );
  }

  buildForm(BuildContext context) {
    return InputForm(
      formKey: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(color: COLOR_GRAY),
          ),
          const SizedBox(height: 40),
          AppTextFormField(
            floatingLabelBehavior: FloatingLabelBehavior.never,
            labelText: AppLocalizations.of(context)!
                .createOrgMemberScreen_occupationLabel,
            validator: requiredField(
              AppLocalizations.of(context)!
                  .createOrgMemberScreen_occupationErrorLabel,
            ),
            onChanged: onOccupationChanged,
          ),
          const SizedBox(height: 30),
          buildEquitySection(),
          const SizedBox(height: 30),
          buildCompensationSection(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildForm(context);
  }
}
