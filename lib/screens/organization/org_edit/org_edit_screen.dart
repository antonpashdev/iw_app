import 'package:flutter/material.dart';
import 'package:iw_app/api/models/org_to_update.model.dart';
import 'package:iw_app/api/orgs_api.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/screens/home_screen.dart';
import 'package:iw_app/utils/validation.dart';
import 'package:iw_app/widgets/list/keyboard_dismissable_list.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

import '../../../widgets/buttons/secondary_button.dart';
import '../../../widgets/form/boarded_textfield_with_title.dart';
import '../../../widgets/form/input_form.dart';

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

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final websiteLinkController = TextEditingController();

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
      child: InputForm(
        formKey: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: KeyboardDismissableListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      BoardedTextFieldWithTitle(
                        title: 'Organization name',
                        onChanged: onNameChanged,
                        validator: multiValidate([
                          requiredField('Organization name'),
                        ]),
                        onSuffixTap: null,
                        prefix: '',
                        suffix: '',
                        focus: true,
                        textFieldController: nameController,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      BoardedTextFieldWithTitle(
                        title: 'Organization description',
                        onChanged: onDescriptionChanged,
                        validator: multiValidate([
                          requiredField('Organization description'),
                        ]),
                        onSuffixTap: null,
                        prefix: '',
                        suffix: '',
                        focus: true,
                        textFieldController: descriptionController,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      BoardedTextFieldWithTitle(
                        title: 'Organization website',
                        onChanged: onWebsiteLinkChanged,
                        validator: multiValidate([
                          requiredField('Organization website'),
                        ]),
                        onSuffixTap: null,
                        prefix: '',
                        suffix: '',
                        focus: true,
                        textFieldController: websiteLinkController,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  )
                ],
              ),
            ),
            Column(
              children: [
                SizedBox(
                  width: 290,
                  child: ElevatedButton(
                    onPressed: saving || !isFormDirty() ? null : onSave,
                    child: const Text('Save'),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 290,
                  child: SecondaryButton(
                    onPressed: saving || !isFormDirty() ? null : onCancel,
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
