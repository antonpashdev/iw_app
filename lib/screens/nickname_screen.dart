import 'package:flutter/material.dart';
import 'package:iw_app/api/users_api.dart';
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
  bool isLoading = false;
  bool userAlreadyExists = false;

  final formGlobalKey = GlobalKey<FormState>();

  String? validateFormField(String? value) {
    final trimmedValue = value!.trim();
    final isNotEmpty = trimmedValue.isNotEmpty;

    if (!isNotEmpty) {
      return AppLocalizations.of(context)?.nickname_error_empty;
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

  handleNext() async {
    setState(() {
      isLoading = true;
    });
    try {
      bool isNickNameExists = await usersApi.isUserExists(user.nickname!);

      setState(() {
        userAlreadyExists = isNickNameExists;
      });

      navigateTo(formGlobalKey.currentState!.validate() && !isNickNameExists);
    } catch (err) {
      print(err);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  navigateTo(bool isNavigationAllowed) {
    if (isNavigationAllowed) {
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
      child: Column(
        children: <Widget>[
          Form(
              key: formGlobalKey,
              child: TextFormField(
                validator: validateFormField,
                decoration: InputDecoration(
                  prefix: const Text('@'),
                  border: const UnderlineInputBorder(),
                  labelText: labelText,
                ),
                onChanged: onNickNameChanged,
              ),),
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
                        ),),
                      ],),),),
          SizedBox(
            width: 290,
            child: ElevatedButton(
              onPressed: isButtonDisabled || isLoading ? null : handleNext,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isLoading) const CircularProgressIndicator.adaptive(),
                  if (!isLoading)
                    Text(AppLocalizations.of(context)!.common_next),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
