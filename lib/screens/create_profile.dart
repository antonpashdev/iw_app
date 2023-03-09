import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:iw_app/models/user_model.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';

class CreateProfile extends StatefulWidget {
  final User user;

  const CreateProfile({Key? key, required this.user}) : super(key: key);

  @override
  State<CreateProfile> createState() => _CreateProfile();
}

class _CreateProfile extends State<CreateProfile> {
  Uint8List? imageBuffer;
  String name = '';

  User get user => widget.user;

  createUser() {
    print('create user');
  }

  selectUserImage() async {
    var pickedImage = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: false);

    if (pickedImage != null) {
      String base64Image =
          base64Encode(pickedImage.files.first.bytes as List<int>);

      user.setImage = base64Image;

      setState(() {
        imageBuffer = pickedImage.files.first.bytes!;
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
                      child: imageBuffer == null
                          ? const Center(
                              child: Image(
                                  image:
                                      AssetImage('assets/icons/add_image.png')))
                          : FittedBox(
                              clipBehavior: Clip.hardEdge,
                              fit: BoxFit.cover,
                              child: Image.memory(
                                imageBuffer!,
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
                ElevatedButton(
                  onPressed: name == '' ? null : createUser,
                  child: const Text('Next'),
                ),
              ],
            )),
          ],
        ));
  }
}
