import 'package:flutter/material.dart';
import 'package:iw_app/models/user_model.dart';
import 'package:iw_app/screens/profile_name_screen.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';
import 'package:iw_app/l10n/generated/app_localizations.dart';

class NicknameScreen extends StatefulWidget {
  const NicknameScreen({super.key});

  @override
  State<NicknameScreen> createState() => _NicknameScreen();
}

class _NicknameScreen extends State<NicknameScreen> {
  User user = User();
  bool isButtonDisabled = true;

  // TODO: fetch from backend if user already exists and change state
  bool userAlreadyExists = false;

  final formGlobalKey = GlobalKey<FormState>();

  String? validateFormField(String? value) {
    final trimmedValue = value!.trim();
    final startsWithAt = trimmedValue.startsWith(RegExp(r'^@'));
    final containsAtOnly = trimmedValue == '@';
    final isNotEmpty = trimmedValue.isNotEmpty;

    if (isNotEmpty && containsAtOnly) {
      return AppLocalizations.of(context)?.nickname_error_empty;
    }

    if (isNotEmpty && !startsWithAt) {
      return AppLocalizations.of(context)?.nickname_error_should_starts_with_at;
    }

    if (userAlreadyExists) {
      return AppLocalizations.of(context)?.nickname_error_already_exists;
    }
    return null;
  }

  onNickNameChanged(value) {
    setState(() {
      user.nickname = value;
      isButtonDisabled = value.isEmpty;
    });
  }

  handleNext() {
    if (formGlobalKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CreateProfile(user: user)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String? inputDescription =
        AppLocalizations.of(context)!.nicknameScreen_input_description;
    String? labelText =
        AppLocalizations.of(context)!.nicknameScreen_input_label;

    return ScreenScaffold(
        title: AppLocalizations.of(context)!.nicknameScreen_title,
        child: Column(children: <Widget>[
          Form(
              key: formGlobalKey,
              child: TextFormField(
                validator: validateFormField,
                decoration: InputDecoration(
                  border: const UnderlineInputBorder(),
                  labelText: labelText,
                ),
                onChanged: onNickNameChanged,
              )),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Flexible(
                            child: Text(
                          inputDescription,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            color: Color(0xff87899B),
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                          softWrap: true,
                        ))
                      ]))),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: isButtonDisabled ? null : handleNext,
                  child: Text(AppLocalizations.of(context)!.common_next),
                ),
              ],
            ),
          ),
        ]));
  }
}
