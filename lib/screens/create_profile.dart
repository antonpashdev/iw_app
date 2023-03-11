import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:iw_app/api/users_api.dart';
import 'package:iw_app/models/user_model.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';
import 'package:file_picker/file_picker.dart';

class CreateProfile extends StatefulWidget {
  final User user;

  const CreateProfile({Key? key, required this.user}) : super(key: key);

  @override
  State<CreateProfile> createState() => _CreateProfile();
}

class _CreateProfile extends State<CreateProfile> {
  User get user => widget.user;
  String name = '';

  var _isLoading = false;
  Uint8List? _imageBuffer;

  selectUserImage() async {
    var pickedImage = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: false);

    if (pickedImage != null) {
      user.image = pickedImage.files.first.bytes!;

      setState(() {
        _imageBuffer = pickedImage.files.first.bytes!;
      });
    }
  }

  createUser() async {
    setState(() {
      _isLoading = true;
    });

    try {
      var data =
          await usersApi.createUser(user.name, user.nickname, user.image);
      // TODO: store token somewhere on device
    } catch (e) {
      // TODO: handle error (show error message to user)
      print(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
        title: 'Profile',
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                InkWell(
                  onTap: selectUserImage,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                      decoration: BoxDecoration(
                          color: const Color(0xFFE2E2E8),
                          borderRadius: BorderRadius.circular(20)),
                      width: 70,
                      height: 70,
                      clipBehavior: Clip.antiAlias,
                      child: _imageBuffer == null
                          ? const Center(
                              child: Image(
                                  image:
                                      AssetImage('assets/icons/add_image.png')))
                          : FittedBox(
                              clipBehavior: Clip.hardEdge,
                              fit: BoxFit.cover,
                              child: Image.memory(
                                _imageBuffer!,
                              ),
                            )),
                ),
                const SizedBox(width: 20),
                Expanded(
                    child: TextFormField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Your name',
                  ),
                  onChanged: (value) {
                    user.name = value;
                    setState(() {
                      name = value;
                    });
                  },
                ))
              ],
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _isLoading
                    ? ElevatedButton.icon(
                        onPressed: name == '' || _isLoading ? null : createUser,
                        icon: Container(
                          width: 24,
                          height: 24,
                          padding: const EdgeInsets.all(2.0),
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        ),
                        label: const Text('Next'),
                      )
                    : ElevatedButton(
                        onPressed: name == '' ? null : createUser,
                        child: const Text('Next')),
              ],
            )),
          ],
        ));
  }
}
