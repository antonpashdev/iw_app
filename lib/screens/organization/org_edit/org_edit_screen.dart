import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iw_app/api/models/org_to_update.model.dart';
import 'package:iw_app/api/orgs_api.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/screens/home_screen.dart';
import 'package:iw_app/screens/organization/org_edit/builders/header.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/utils/validation.dart';
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
  late Organization organization;
  bool saving = false;
  bool isDirty = false;
  List<String> images = [];
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController(text: '');
  final descriptionController = TextEditingController(text: '');
  final websiteLinkController = TextEditingController(text: '');

  @override
  initState() {
    super.initState();
    organization = Organization.fromOrg(widget.organization);
    nameController.value = TextEditingValue(text: organization.name ?? '');
    descriptionController.value =
        TextEditingValue(text: organization.description ?? '');
    websiteLinkController.value =
        TextEditingValue(text: organization.link ?? '');
  }

  updateOrg() async {
    await orgsApi.updateOrg(
      organization.id!,
      OrgToUpdate.fromOrg(organization),
    );
  }

  onNameChanged(String? value) {
    setState(() {
      organization.name = value!.trim();
    });
  }

  onDescriptionChanged(String? value) {
    setState(() {
      organization.description = value!.trim();
    });
  }

  onWebsiteLinkChanged(String? value) {
    setState(() {
      organization.link = value!.trim();
    });
  }

  getCurrentImageName() {
    String logoUrl = organization.logo!;
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

  onLogoChanged(Uint8List pickedLogo) async {
    final response = await orgsApi.uploadLogo(pickedLogo);
    final logo = response.data;

    setState(() {
      images.add(organization.logo!);
    });
    organization.logo = logo;
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

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      title: 'Edit Organization info',
      actions: [
        TextButton(
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(Colors.transparent),
          ),
          onPressed: saving ? null : onSave,
          child: Text(
            'Save',
            style: TextStyle(
              color: saving ? COLOR_GRAY2 : COLOR_BLUE,
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
              organization,
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
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'App',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                CupertinoSwitch(
                  value: organization.settings?.isApp ?? false,
                  activeColor: COLOR_GREEN,
                  onChanged: (organization.settings?.isContent ?? false)
                      ? null
                      : (bool? value) {
                          setState(() {
                            organization.settings?.isApp = value;
                            organization.settings?.isContent = false;
                          });
                        },
                ),
              ],
            ),
            if (organization.settings?.isApp ?? false)
              Column(
                children: [
                  const SizedBox(height: 20),
                  AppTextFormField(
                    initialValue:
                        organization.settings?.pricePerMonth?.toString() ?? '',
                    labelText: 'Price per month',
                    textInputAction: TextInputAction.done,
                    inputType: TextInputType.number,
                    prefix: '\$',
                    suffix: const Text('/ mo'),
                    validator: (organization.settings?.isApp ?? false)
                        ? multiValidate([
                            requiredField('Price per month'),
                            numberField('Price per month'),
                          ])
                        : (_) => null,
                    onChanged: (value) {
                      setState(() {
                        organization.settings?.pricePerMonth =
                            double.tryParse(value);
                      });
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
