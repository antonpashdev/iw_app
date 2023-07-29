import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:iw_app/models/user_model.dart';
import 'package:iw_app/screens/user/edit/widgets/user_logo_editor.dart';
import 'package:iw_app/theme/app_theme.dart';

buildHeader(
  BuildContext context,
  User? user,
  TextEditingController nameController,
  void Function(String)? onNameChanged,
  void Function(Uint8List) onLogoChanged,
) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        clipBehavior: Clip.antiAlias,
        child: FittedBox(
          fit: BoxFit.cover,
          child: UserAvatarEditor(
            onLogoChanged: onLogoChanged,
            user: user,
          ),
        ),
      ),
      const SizedBox(width: 15),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EditableText(
              controller: nameController,
              focusNode: FocusNode(),
              style: Theme.of(context).textTheme.headlineSmall!,
              cursorColor: COLOR_BLUE,
              backgroundCursorColor: COLOR_ALMOST_BLACK,
              onChanged: onNameChanged,
              autofocus: true,
            ),
            const Divider(
              color: COLOR_GRAY2,
              thickness: 1,
              height: 20,
            ),
          ],
        ),
      ),
    ],
  );
}
