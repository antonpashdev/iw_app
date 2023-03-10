import 'package:flutter/material.dart';
import 'package:iw_app/models/user_model.dart';
import 'package:iw_app/screens/profile_name_screen.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

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
      return 'Nickname should not be empty';
    }

    if (isNotEmpty && !startsWithAt) {
      return 'Nickname should starts with @';
    }

    if (userAlreadyExists) {
      return 'A user with that nickname already exists';
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
    return ScreenScaffold(
        title: 'Create nickname',
        child: Column(children: <Widget>[
          Form(
              key: formGlobalKey,
              child: TextFormField(
                validator: validateFormField,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: '@nickname',
                ),
                onChanged: onNickNameChanged,
              )),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const <Widget>[
                        Flexible(
                            child: Text(
                          'Your nickname it???s your ID. It can???t be changed. Make sure to create appropriate nickname to use it forever.',
                          textAlign: TextAlign.left,
                          style: TextStyle(
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
                  child: const Text('Next'),
                ),
              ],
            ),
          ),
        ]));
  }
}
