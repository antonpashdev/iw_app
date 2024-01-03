import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/screens/organization/org_edit/builders/logo_editor.dart';
import 'package:iw_app/theme/app_theme.dart';

buildHeader(
  BuildContext context,
  Organization organization,
  TextEditingController nameController,
  TextEditingController linkController,
  void Function(String)? onNameChanged,
  void Function(String)? onLinkChanged,
  void Function(Uint8List) onLogoChanged,
) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(255, 255, 255, 0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        clipBehavior: Clip.antiAlias,
        child: FittedBox(
          fit: BoxFit.cover,
          child: LogoEditor(
            onLogoChanged: onLogoChanged,
            organization: organization,
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
            ),
            const SizedBox(height: 5),
            TextButton.icon(
              onPressed: null,
              icon: const Icon(Icons.link),
              label: EditableText(
                controller: linkController,
                focusNode: FocusNode(),
                style: const TextStyle(
                  color: COLOR_BLUE,
                  decoration: TextDecoration.underline,
                ),
                cursorColor: COLOR_BLUE,
                backgroundCursorColor: COLOR_ALMOST_BLACK,
                onChanged: onLinkChanged,
              ),
              style: TextButton.styleFrom(
                iconColor: COLOR_BLUE,
                foregroundColor: COLOR_BLUE,
              ),
            )
          ],
        ),
      ),
    ],
  );
}
