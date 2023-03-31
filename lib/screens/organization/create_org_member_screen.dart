import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iw_app/api/auth_api.dart';
import 'package:iw_app/api/orgs_api.dart';
import 'package:iw_app/l10n/generated/app_localizations.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/screens/home_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/utils/validation.dart';
import 'package:iw_app/widgets/components/bottom_sheet_info.dart';
import 'package:iw_app/widgets/form/input_form.dart';
import 'package:iw_app/widgets/list/keyboard_dismissable_list.dart';

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
    role: MemberRole.CoOwner,
  );
  bool isLoading = false;

  buildForm() {
    return InputForm(
      formKey: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            AppLocalizations.of(context)!.createOrgMemberScreen_description,
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
            onChanged: (value) {
              setState(() {
                member.occupation = value;
              });
            },
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Text(
                AppLocalizations.of(context)!
                    .createOrgMemberScreen_impactRatioLabel,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () {
                  showBottomInfoSheet(context,
                      title: AppLocalizations.of(context)!
                          .createOrgMemberScreen_impactRatioLabel,
                      description: AppLocalizations.of(context)!
                          .impactRatio_description);
                },
                icon: const Icon(Icons.info_outline_rounded),
                iconSize: 16,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                color: COLOR_GRAY,
              ),
            ],
          ),
          const SizedBox(height: 15),
          AppTextFormFieldBordered(
            initialValue: member.impactRatio.toString(),
            prefix: const Text('x'),
            validator: multiValidate([
              requiredField(
                AppLocalizations.of(context)!
                    .createOrgMemberScreen_impactRatioLabel,
              ),
              numberField(
                AppLocalizations.of(context)!
                    .createOrgMemberScreen_impactRatioLabel,
              ),
            ]),
            onChanged: (value) {
              setState(() {
                member.impactRatio = double.tryParse(value) ?? 0;
              });
            },
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!
                        .createOrgMemberScreen_monthlyCompensationLabel,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () {
                      showBottomInfoSheet(context,
                          title: AppLocalizations.of(context)!
                              .createOrgMemberScreen_monthlyCompensationLabel,
                          description: AppLocalizations.of(context)!
                              .monthlyCompensation_description);
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
                value: member.isMonthlyCompensated!,
                activeColor: COLOR_GREEN,
                onChanged: (bool? value) {
                  compensationCtrl.clear();
                  setState(() {
                    member.isMonthlyCompensated = value!;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          AppTextFormFieldBordered(
            controller: compensationCtrl,
            enabled: member.isMonthlyCompensated,
            prefix: const Text('\$'),
            validator: member.isMonthlyCompensated!
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
            onChanged: (value) {
              setState(() {
                member.monthlyCompensation = double.tryParse(value) ?? 0;
              });
            },
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!
                        .createOrgMemberScreen_autoContributionLabel,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () {
                      showBottomInfoSheet(context,
                          title: AppLocalizations.of(context)!
                              .createOrgMemberScreen_autoContributionLabel,
                          description: AppLocalizations.of(context)!
                              .autoContribution_description);
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
                value: member.autoContribution!,
                activeColor: COLOR_GREEN,
                onChanged: (bool? value) {
                  setState(() {
                    member.autoContribution = value!;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  navigateToHome() {
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    }
  }

  handleNextPressed() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        member.user = await authApi.userId;
        await orgsApi.createOrg(widget.organization, member);

        navigateToHome();
      } on DioError catch (err) {
        print(err);
        if (err.response!.statusCode == HttpStatus.conflict) {
          navigateToHome();
        }
      } catch (err) {
        print(err);
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: COLOR_WHITE,
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.createOrgMemberScreen_title,
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: KeyboardDismissableListView(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                children: [
                  buildForm(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: ElevatedButton(
                onPressed: isLoading ? null : handleNextPressed,
                child: isLoading
                    ? const CircularProgressIndicator(color: COLOR_GRAY)
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
