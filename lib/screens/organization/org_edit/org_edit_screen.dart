import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:iw_app/api/models/org_to_update.model.dart';
import 'package:iw_app/api/orgs_api.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/screens/home_screen.dart';
import 'package:iw_app/screens/organization/org_edit/builders/header.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/components/round_border_container.dart';
import 'package:iw_app/widgets/form/input_form.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

class OrgEditScreen extends StatefulWidget {
  final Organization organization;

  const OrgEditScreen({Key? key, required this.organization}) : super(key: key);

  @override
  State<OrgEditScreen> createState() => _OrgEditScreenState();
}

class _OrgEditScreenState extends State<OrgEditScreen> {
  bool saving = false;
  bool isDirty = false;
  List<String> images = [];
  final formKey = GlobalKey<FormState>();

  late String? name;
  late String? description;
  late String? link;
  late String? logoLink;

  final nameController = TextEditingController(text: '');
  final descriptionController = TextEditingController(text: '');
  final websiteLinkController = TextEditingController(text: '');

  @override
  initState() {
    super.initState();
    nameController.value =
        TextEditingValue(text: widget.organization.name ?? '');
    descriptionController.value =
        TextEditingValue(text: widget.organization.description ?? '');
    websiteLinkController.value =
        TextEditingValue(text: widget.organization.link ?? '');

    name = widget.organization.name;
    description = widget.organization.description;
    link = widget.organization.link;
    logoLink = widget.organization.logo;
  }

  updateOrg() async {
    await orgsApi.updateOrg(
      widget.organization.id!,
      OrgToUpdate(
        name: name,
        description: description,
        link: link,
        logo: logoLink,
      ),
    );
  }

  onNameChanged(String? value) {
    setState(() {
      name = value!.trim();
    });
  }

  onDescriptionChanged(String? value) {
    setState(() {
      description = value!.trim();
    });
  }

  onWebsiteLinkChanged(String? value) {
    setState(() {
      link = value!.trim();
    });
  }

  getCurrentImageName() {
    String logoUrl = widget.organization.logo!;
    String uuid =
        logoUrl.substring('/orgs/logo/'.length, logoUrl.indexOf('.jpg'));

    print(uuid); // Output: '18004f5d-0f2b-4635-9b22-60ac8d3f24e6'
  }

  removeImages() async {
    if (images.isEmpty) return;
    try {
      await orgsApi.removeLogos(images);
    } catch (e) {
      print(e);
    }
  }

  onLogoChanged(Uint8List logo) async {
    final response = await orgsApi.uploadLogo(logo);
    final _logo = response.data;

    print(_logo);

    setState(() {
      logoLink = _logo;
      images.add(widget.organization.logo!);
    });
    widget.organization.logo = _logo;
    setState(() {
      isDirty = true;
    });
  }

  onSave() async {
    await removeImages();
    setState(() {
      saving = true;
    });
    if (formKey.currentState!.validate()) {
      try {
        await updateOrg();
        widget.organization.name = name;
        widget.organization.description = description;
        widget.organization.link = link;

        if (context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false,
          );
        }
      } catch (e) {
        print(e);
      } finally {
        setState(() {
          saving = false;
          images = [];
        });
      }
    }
  }

  onCancel() {
    Navigator.of(context).pop();
  }

  bool isFormDirty() {
    return name != widget.organization.name ||
        description != widget.organization.description ||
        link != widget.organization.link ||
        isDirty;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      title: 'Edit Organization info',
      actions: [
        TextButton(
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(Colors.transparent),
          ),
          onPressed: saving || !isFormDirty() ? null : onSave,
          child: Text(
            'Save',
            style: TextStyle(
              color: saving || !isFormDirty() ? COLOR_GRAY2 : COLOR_BLUE,
            ),
          ),
        ),
      ],
      leading: TextButton(
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(Colors.transparent),
        ),
        onPressed: onCancel,
        child: const Text(
          'Cancel',
          style: TextStyle(
            color: COLOR_BLUE,
          ),
        ),
      ),
      child: InputForm(
        formKey: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildHeader(
              context,
              widget.organization,
              nameController,
              websiteLinkController,
              onNameChanged,
              onWebsiteLinkChanged,
              onLogoChanged,
            ),
            const SizedBox(height: 20),
            RoundBorderContainer(
              child: EditableText(
                controller: descriptionController,
                focusNode: FocusNode(),
                style: const TextStyle(
                  color: COLOR_ALMOST_BLACK,
                  fontSize: 16,
                  height: 1.5,
                ),
                cursorColor: COLOR_BLACK,
                backgroundCursorColor: COLOR_ALMOST_BLACK,
                onChanged: onDescriptionChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
