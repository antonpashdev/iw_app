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
  final formKey = GlobalKey<FormState>();

  late String? name;
  late String? description;
  late String? link;

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
  }

  updateOrg() async {
    await orgsApi.updateOrg(
      widget.organization.id!,
      OrgToUpdate(
        name: name,
        description: description,
        link: link,
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

  onSave() async {
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
        link != widget.organization.link;
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
