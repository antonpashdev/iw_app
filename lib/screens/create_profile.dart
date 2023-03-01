import 'package:flutter/material.dart';
import 'package:iw_app/models/user_model.dart';
import 'package:iw_app/widgets/scaffold/create-user-scaffold.dart';

class CreateProfile extends StatelessWidget {
  final User user;

  const CreateProfile({Key? key, required this.user}) : super(key: key);

  createUser() {
    print('create user');
  }

  @override
  Widget build(BuildContext context) {
    return CreateUserScaffold(
        title: 'Profile',
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    print('add image');
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                      decoration: BoxDecoration(
                          color: const Color(0xFFE2E2E8),
                          borderRadius: BorderRadius.circular(20)),
                      width: 70,
                      height: 70,
                      child: const Center(
                          child: Image(
                              image:
                                  AssetImage('assets/icons/add_image.png')))),
                ),
                const SizedBox(width: 20),
                Expanded(
                    child: TextFormField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Your name',
                  ),
                  onChanged: (value) {},
                ))
              ],
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: user.name == '' ? null : createUser,
                  child: const Text('Create'),
                ),
              ],
            )),
          ],
        ));
  }
}
