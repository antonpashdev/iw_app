import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iw_app/api/orgs_api.dart';
import 'package:iw_app/l10n/generated/app_localizations.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/screens/organization/create_org_name_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/utils/rx.dart';
import 'package:iw_app/utils/validation.dart';
import 'package:iw_app/widgets/form/input_form.dart';
import 'package:iw_app/widgets/list/keyboard_dismissable_list.dart';
import 'package:rxdart/rxdart.dart';

class CreateOrgScreen extends StatefulWidget {
  const CreateOrgScreen({Key? key}) : super(key: key);

  @override
  State<CreateOrgScreen> createState() => _CreateOrgScreenState();
}

class _CreateOrgScreenState extends State<CreateOrgScreen> {
  final formKey = GlobalKey<FormState>();
  final searchSubject = PublishSubject<String>();

  Organization organization = Organization();
  StreamSubscription? searchSubscription;
  bool? orgExists;
  bool isLoading = false;

  _CreateOrgScreenState() {
    setupSearchListener();
  }

  @override
  dispose() {
    searchSubject.close();
    searchSubscription?.cancel();
    super.dispose();
  }

  setupSearchListener() {
    final stream = searchSubject.map((value) {
      orgExists = null;
      if (value.isEmpty) {
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = true;
        });
      }
      return value;
    });

    searchSubscription = RxUtils.searchWrapper<bool?>(
      stream,
      checkIfOrgExists,
    ).listen((exists) {
      setState(() {
        orgExists = exists;
      });
    });
  }

  buildSuffix() {
    const loader = SizedBox(
      width: 15,
      height: 15,
      child: CircularProgressIndicator(
        color: COLOR_GRAY,
        strokeWidth: 2,
      ),
    );
    return isLoading
        ? loader
        : orgExists == null || orgExists!
            ? null
            : SvgPicture.asset(
                'assets/icons/check_filled.svg',
                width: 20,
              );
  }

  buildForm() {
    return InputForm(
      formKey: formKey,
      child: AppTextFormField(
        labelText: 'organization_username',
        prefix: '@',
        suffix: buildSuffix(),
        onChanged: (value) {
          searchSubject.add(value);
        },
        validator: multiValidate([
          requiredField('organization_username'),
          (_) => orgExists != null && orgExists!
              ? 'Organization with this username already exists'
              : null,
        ]),
        helperText:
            AppLocalizations.of(context)!.createOrgScreen_usernameHelperText,
      ),
    );
  }

  handleNextPressed() {
    if (formKey.currentState!.validate()) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => CreateOrgNameScreen(
            organization: organization,
          ),
        ),
      );
    }
  }

  Future<bool?> checkIfOrgExists(String username) async {
    if (username.isEmpty) {
      return null;
    }
    try {
      await orgsApi.getOrgByUsername(username);
    } catch (err) {
      if ((err as DioError).response?.statusCode == 404) {
        return false;
      }
      print(err);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final isBtnDisabled = formKey.currentState == null ||
        !formKey.currentState!.validate() ||
        isLoading;

    return SafeArea(
      child: Scaffold(
        backgroundColor: COLOR_WHITE,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.createOrgScreen_title),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: KeyboardDismissableListView(
                padding: const EdgeInsets.all(30),
                children: [buildForm()],
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
