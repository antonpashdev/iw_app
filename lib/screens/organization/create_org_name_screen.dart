import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iw_app/l10n/generated/app_localizations.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/screens/organization/org_creation_progress_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/utils/validation.dart';
import 'package:iw_app/widgets/form/input_form.dart';
import 'package:iw_app/widgets/list/keyboard_dismissable_list.dart';

class CreateOrgNameScreen extends StatefulWidget {
  final Organization organization;

  const CreateOrgNameScreen({Key? key, required this.organization})
      : super(key: key);

  @override
  State<CreateOrgNameScreen> createState() => _CreateOrgNameScreenState();
}

class _CreateOrgNameScreenState extends State<CreateOrgNameScreen> {
  final formKey = GlobalKey<FormState>();

  handleNextPressed() {
    if (!formKey.currentState!.validate()) {
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => OrgCreationProgressScreen(
          organization: widget.organization,
          member: OrganizationMember(
            occupation: 'Founder',
            role: MemberRole.Admin,
          ),
        ),
      ),
    );
  }

  selectLogo() async {
    var pickedImage = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: false);

    if (pickedImage != null) {
      setState(() {
        widget.organization.logoToSet = pickedImage.files.first.bytes!;
      });
    }
  }

  String? requiredLogoValidator(String? value) {
    if (widget.organization.logoToSet == null) {
      return '${AppLocalizations.of(context)!.createOrgNameScreen_logoLabel} ${AppLocalizations.of(context)!.required}';
    }
    return null;
  }

  buildForm() {
    return InputForm(
      formKey: formKey,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E2E8),
                  borderRadius: BorderRadius.circular(20),
                ),
                width: 70,
                height: 70,
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: selectLogo,
                  borderRadius: BorderRadius.circular(20),
                  child: widget.organization.logoToSet == null
                      ? const Center(
                          child: Image(
                            image: AssetImage('assets/icons/add_image.png'),
                          ),
                        )
                      : FittedBox(
                          clipBehavior: Clip.hardEdge,
                          fit: BoxFit.cover,
                          child: Image.memory(widget.organization.logoToSet!),
                        ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: AppTextFormField(
                  labelText: AppLocalizations.of(context)!
                      .createOrgNameScreen_nameLabel,
                  textInputAction: TextInputAction.next,
                  validator: multiValidate([
                    requiredField(
                      AppLocalizations.of(context)!
                          .createOrgNameScreen_nameLabel,
                    ),
                    requiredLogoValidator,
                  ]),
                  onChanged: (value) {
                    setState(() {
                      widget.organization.name = value;
                    });
                  },
                ),
              )
            ],
          ),
          const SizedBox(height: 30),
          AppTextFormField(
            labelText:
                AppLocalizations.of(context)!.createOrgNameScreen_linkLabel,
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              setState(() {
                widget.organization.link = value;
              });
            },
          ),
          const SizedBox(height: 30),
          AppTextFormField(
            labelText: AppLocalizations.of(context)!
                .createOrgNameScreen_descriptionLabel,
            textInputAction: TextInputAction.done,
            onChanged: (value) {
              setState(() {
                widget.organization.description = value;
              });
            },
            onFieldSubmitted: (value) {
              setState(() {
                widget.organization.description = value;
              });
              handleNextPressed();
            },
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
                value: widget.organization.settings?.isApp ?? false,
                activeColor: COLOR_GREEN,
                onChanged: (widget.organization.settings?.isContent ?? false)
                    ? null
                    : (bool? value) {
                        setState(() {
                          widget.organization.settings?.isApp = value;
                          widget.organization.settings?.isContent = false;
                        });
                      },
              ),
            ],
          ),
          if (widget.organization.settings?.isApp ?? false)
            Column(
              children: [
                const SizedBox(height: 20),
                AppTextFormField(
                  labelText: 'Price per month',
                  textInputAction: TextInputAction.done,
                  inputType: TextInputType.number,
                  prefix: '\$',
                  suffix: const Text('/ mo'),
                  validator: (widget.organization.settings?.isApp ?? false)
                      ? multiValidate([
                          requiredField('Price per month'),
                          numberField('Price per month'),
                        ])
                      : (_) => null,
                  onChanged: (value) {
                    setState(() {
                      widget.organization.settings?.pricePerMonth =
                          double.tryParse(value);
                    });
                  },
                ),
              ],
            ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Content',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              CupertinoSwitch(
                value: widget.organization.settings?.isContent ?? false,
                activeColor: COLOR_GREEN,
                onChanged: (widget.organization.settings?.isApp ?? false)
                    ? null
                    : (bool? value) {
                        setState(() {
                          widget.organization.settings?.isContent = value;
                          widget.organization.settings?.isApp = false;
                        });
                      },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: APP_BODY_BG,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          title: Text(AppLocalizations.of(context)!.createOrgNameScreen_title),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: KeyboardDismissableListView(
                padding: const EdgeInsets.all(30),
                children: [
                  buildForm(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: ElevatedButton(
                onPressed: handleNextPressed,
                child: Text(AppLocalizations.of(context)!.next),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
