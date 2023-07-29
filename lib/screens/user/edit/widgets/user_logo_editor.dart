import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iw_app/api/users_api.dart';
import 'package:iw_app/models/user_model.dart';
import 'package:iw_app/theme/app_theme.dart';

class UserAvatarEditor extends StatefulWidget {
  final Function(Uint8List) onLogoChanged;
  final User? user;

  const UserAvatarEditor({
    Key? key,
    required this.onLogoChanged,
    required this.user,
  }) : super(key: key);

  @override
  State<UserAvatarEditor> createState() => _UserAvatarEditorState();
}

class _UserAvatarEditorState extends State<UserAvatarEditor> {
  bool saving = false;

  selectLogo() async {
    setState(() {
      saving = true;
    });

    try {
      var pickedImage = await FilePicker.platform
          .pickFiles(type: FileType.image, allowMultiple: false);

      if (pickedImage != null) {
        await widget.onLogoChanged(pickedImage.files.first.bytes!);
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        saving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE2E2E8),
        borderRadius: BorderRadius.circular(20),
        backgroundBlendMode: BlendMode.darken,
        image: DecorationImage(
          image: widget.user?.avatarToSet != null
              ? Image.memory(widget.user!.avatarToSet!).image
              : widget.user?.avatar == null
                  ? Image.asset('assets/images/avatar_placeholder.png').image
                  : NetworkImage(
                      '${usersApi.baseUrl}${widget.user?.avatar}',
                    ),
          fit: BoxFit.cover,
        ),
      ),
      width: 70,
      height: 70,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: saving ? null : selectLogo,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: Colors.white.withOpacity(0.2),
          child: Center(
            child: saving
                ? const CupertinoActivityIndicator(radius: 10)
                : SvgPicture.asset(
                    'assets/icons/add_image_icon.svg',
                    theme: const SvgTheme(currentColor: COLOR_ALMOST_BLACK),
                  ),
          ),
        ),
      ),
    );
  }
}
