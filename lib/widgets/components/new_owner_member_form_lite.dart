import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iw_app/l10n/generated/app_localizations.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/utils/validation.dart';
import 'package:iw_app/widgets/components/bottom_sheet_info.dart';
import 'package:iw_app/widgets/components/new_member_form.dart';
import 'package:iw_app/widgets/form/input_form.dart';

class NewOwnerMemberFormLite extends NewMemberForm {
  const NewOwnerMemberFormLite({
    super.key,
    required super.formKey,
    required super.member,
    required super.title,
  });

  @override
  State<NewOwnerMemberFormLite> createState() => _NewMemberFormLiteState();
}

class _NewMemberFormLiteState extends State<NewOwnerMemberFormLite> {
  final compensationCtrl = TextEditingController();

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    'Equity',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () {
                      showBottomInfoSheet(
                        context,
                        title: 'Equity',
                        description:
                            'The first member is an owner of organization and get 100% of equity by default',
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
              const Text(
                '100%',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    'Paycheck per month',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
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
              CupertinoSwitch(
                value: widget.member.isMonthlyCompensated!,
                activeColor: COLOR_GREEN,
                onChanged: (bool? value) {
                  compensationCtrl.clear();
                  onIsMonthlyCompensatedChanged(value!);
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          AppTextFormFieldBordered(
            controller: compensationCtrl,
            enabled: widget.member.isMonthlyCompensated!,
            prefix: const Text('\$'),
            validator: widget.member.isMonthlyCompensated!
                ? multiValidate([
                    requiredField('Paycheck per month'),
                    numberField('Paycheck per month'),
                  ])
                : (_) => null,
            onChanged: onMonthlyCompensationChanged,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildForm(context);
  }
}
