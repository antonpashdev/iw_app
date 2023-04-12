import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:iw_app/api/auth_api.dart';
import 'package:iw_app/api/orgs_api.dart';
import 'package:iw_app/l10n/generated/app_localizations.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/screens/home_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/components/new_member_form.dart';
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
    return NewMemberForm(
      formKey: formKey,
      member: member,
      title: AppLocalizations.of(context)!.createOrgMemberScreen_description,
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
          children: [
            Expanded(
              child: KeyboardDismissableListView(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                children: [buildForm()],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 290,
              child: ElevatedButton(
                onPressed: isLoading ? null : handleNextPressed,
                child: isLoading
                    ? const CircularProgressIndicator.adaptive()
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
