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
  final timeframeOptions = PeriodType.values
      .map((e) => ({'value': e, 'title': e.name.toLowerCase()}))
      .toList();

  NewMemberFormLite({
    Key? key,
    required this.formKey,
    required this.member,
    required this.title,
  }) : super(key: key);

  @override
  State<NewMemberFormLite> createState() => _NewMemberFormLiteState();
}

class _NewMemberFormLiteState extends State<NewMemberFormLite> {
  final equityPeriodController = TextEditingController();
  final compensationPeriodController = TextEditingController();

  bool isWithEquity = false;
  bool isMonthlyCompensated = false;

  OrganizationMember get member => widget.member;
  String get title => widget.title;

  onOccupationChanged(String value) {
    setState(() {
      member.occupation = value;
    });
  }

  onMonthlyCompensationChanged(String value) {
    setState(() {
      member.compensation?.amount = double.tryParse(value) ?? 0;
    });
  }

  onEquityChanged(String value) {
    setState(() {
      member.equity?.amount = double.tryParse(value) ?? 0;
    });
  }

  onEquityPeriodChanged(String value) {
    setState(() {
      member.equity?.period?.value = double.tryParse(value) ?? 0;
    });
  }

  onCompensationPeriodChanged(String value) {
    setState(() {
      member.compensation?.period?.value = double.tryParse(value) ?? 0;
    });
  }

  onEquityTimeframeChanged(Map? value) {
    setState(() {
      member.equity?.period?.timeframe = value?['value'];
    });
  }

  onCompensationTimeframeChanged(Map? value) {
    setState(() {
      member.compensation?.period?.timeframe = value?['value'];
    });
  }

  onIsMonthlyCompensatedChanged(bool value) {
    setState(() {
      isMonthlyCompensated = value;
      if (value) {
        member.compensation = Compensation(type: CompensationType.PerMonth);
      } else {
        member.compensation = null;
      }
    });
  }

  onAutoContributionChanged(bool value) {
    setState(() {
      member.isAutoContributing = value;
    });
  }

  onIsWithEquityChanged(bool value) {
    setState(() {
      isWithEquity = value;
      if (value) {
        member.equity = Equity(type: EquityType.Immediately);
      } else {
        member.equity = null;
      }
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
              value: isWithEquity,
              activeColor: COLOR_GREEN,
              onChanged: (bool? value) {
                onIsWithEquityChanged(value!);
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
            value: EquityType.Immediately,
            groupValue: member.equity?.type,
            onChanged: isWithEquity
                ? (EquityType? type) {
                    setState(() {
                      equityPeriodController.text = '';
                      member.equity?.type = type;
                      member.equity?.period = null;
                    });
                  }
                : null,
          ),
        ),
        AppTextFormFieldBordered(
          enabled:
              isWithEquity && member.equity?.type == EquityType.Immediately,
          prefix: const Text('%'),
          inputType: const TextInputType.numberWithOptions(decimal: true),
          validator:
              isWithEquity && member.equity?.type == EquityType.Immediately
                  ? multiValidate([
                      requiredField('Equity'),
                      numberField('Equity'),
                      max(100),
                      min(0),
                    ])
                  : (_) => null,
          onChanged: onEquityChanged,
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
            value: EquityType.DuringPeriod,
            groupValue: member.equity?.type,
            onChanged: isWithEquity
                ? (EquityType? type) {
                    setState(() {
                      equityPeriodController.text = '';
                      member.equity?.type = type;
                      member.equity?.period =
                          Period(timeframe: PeriodType.Months);
                    });
                  }
                : null,
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AppTextFormFieldBordered(
                enabled: isWithEquity &&
                    member.equity?.type == EquityType.DuringPeriod,
                prefix: const Text('%'),
                inputType: const TextInputType.numberWithOptions(decimal: true),
                validator: isWithEquity &&
                        member.equity?.type == EquityType.DuringPeriod
                    ? multiValidate([
                        requiredField('Equity'),
                        numberField('Equity'),
                        max(100),
                        min(0),
                      ])
                    : (_) => null,
                onChanged: onEquityChanged,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: AppTextFormFieldBordered(
                controller: equityPeriodController,
                enabled: isWithEquity &&
                    member.equity?.type == EquityType.DuringPeriod,
                labelText: 'period',
                validator: isWithEquity &&
                        member.equity?.type == EquityType.DuringPeriod
                    ? multiValidate([
                        requiredField('Period'),
                        numberField('Period'),
                      ])
                    : (_) => null,
                onChanged: onEquityPeriodChanged,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ModalFormField<Map>(
                enabled: isWithEquity &&
                    member.equity?.type == EquityType.DuringPeriod,
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
                onChanged: onEquityTimeframeChanged,
                initialValue: member.equity?.period != null
                    ? {
                        'title': member.equity?.period?.timeframe?.name
                            .toLowerCase(),
                        'value': member.equity?.period?.timeframe,
                      }
                    : null,
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
              value: isMonthlyCompensated,
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
            value: CompensationType.PerMonth,
            groupValue: member.compensation?.type,
            onChanged: isMonthlyCompensated
                ? (CompensationType? type) {
                    setState(() {
                      compensationPeriodController.text = '';
                      member.compensation?.type = type;
                      member.compensation?.period = null;
                    });
                  }
                : null,
          ),
        ),
        AppTextFormFieldBordered(
          enabled: isMonthlyCompensated &&
              member.compensation?.type == CompensationType.PerMonth,
          prefix: const Text('\$'),
          inputType: const TextInputType.numberWithOptions(decimal: true),
          validator: isMonthlyCompensated &&
                  member.compensation?.type == CompensationType.PerMonth
              ? multiValidate([
                  requiredField('Compensation'),
                  numberField('Compensation'),
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
            value: CompensationType.OneTime,
            groupValue: member.compensation?.type,
            onChanged: isMonthlyCompensated
                ? (CompensationType? type) {
                    setState(() {
                      compensationPeriodController.text = '';
                      member.compensation?.type = type;
                      member.compensation?.period = Period(
                        timeframe: PeriodType.Months,
                      );
                    });
                  }
                : null,
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AppTextFormFieldBordered(
                enabled: isMonthlyCompensated &&
                    member.compensation?.type == CompensationType.OneTime,
                prefix: const Text('\$'),
                inputType: const TextInputType.numberWithOptions(decimal: true),
                validator: isMonthlyCompensated &&
                        member.compensation?.type == CompensationType.OneTime
                    ? multiValidate([
                        requiredField('Compensation'),
                        numberField('Compensation'),
                      ])
                    : (_) => null,
                onChanged: onMonthlyCompensationChanged,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: AppTextFormFieldBordered(
                controller: compensationPeriodController,
                enabled: isMonthlyCompensated &&
                    member.compensation?.type == CompensationType.OneTime,
                labelText: 'period',
                validator: isMonthlyCompensated &&
                        member.compensation?.type == CompensationType.OneTime
                    ? multiValidate([
                        requiredField('Period'),
                        numberField('Period'),
                      ])
                    : (_) => null,
                onChanged: onCompensationPeriodChanged,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ModalFormField<Map>(
                enabled: isMonthlyCompensated &&
                    member.compensation?.type == CompensationType.OneTime,
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
                initialValue: member.compensation?.period != null
                    ? {
                        'title': member.compensation?.period?.timeframe?.name
                            .toLowerCase(),
                        'value': member.compensation?.period?.timeframe,
                      }
                    : null,
                onChanged: onCompensationTimeframeChanged,
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
