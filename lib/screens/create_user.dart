import 'package:flutter/material.dart';
import 'package:iw_app/models/user_model.dart';
import 'package:iw_app/screens/create_profile.dart';
import 'package:iw_app/widgets/scaffold/create-user-scaffold.dart';

class CreateUser extends StatefulWidget {
  const CreateUser({super.key});

  @override
  State<CreateUser> createState() => _CreateUser();
}

class _CreateUser extends State<CreateUser> {
  User user = User('', '');
  bool isButtonDisabled = true;

  // fetch from backend if user already exists and change state
  bool userAlreadyExists = false;

  final formGlobalKey = GlobalKey<FormState>();

  String? validateFormField(String? value) {
    if (userAlreadyExists) {
      return 'A user with that nickname already exists';
    }
    return null;
  }

  onNickNameChanged(value) {
    setState(() {
      user.setNickname = value;
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
    return CreateUserScaffold(
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
                          'Your nickname it’s your ID. It can’t be changed. Make sure to create appropriate nickname to use it forever.',
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
