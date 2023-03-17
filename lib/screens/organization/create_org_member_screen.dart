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
          Text(
            AppLocalizations.of(context)!
                .createOrgMemberScreen_impactRatioLabel,
            style: const TextStyle(fontWeight: FontWeight.bold),
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
              Text(
                AppLocalizations.of(context)!
                    .createOrgMemberScreen_monthlyCompensationLabel,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              CupertinoSwitch(
                value: member.isMonthlyCompensated,
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
            validator: member.isMonthlyCompensated
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
              Text(
                AppLocalizations.of(context)!
                    .createOrgMemberScreen_autoContributionLabel,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              CupertinoSwitch(
                value: member.autoContribution,
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

  handleNextPressed() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        final response = await orgsApi.createOrg(widget.organization);
        final orgId = response.data['_id'];
        member.userId = await authApi.userId;
        await orgsApi.addMemberToOrg(orgId, member);

        if (context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
            (route) => false,
          );
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
