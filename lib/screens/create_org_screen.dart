import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/form/input_form.dart';
import 'package:iw_app/widgets/list/keyboard_dismissable_list.dart';

class CreateOrgScreen extends StatefulWidget {
  const CreateOrgScreen({Key? key}) : super(key: key);

  @override
  State<CreateOrgScreen> createState() => _CreateOrgScreenState();
}

class _CreateOrgScreenState extends State<CreateOrgScreen> {
  Organization organization = Organization();

  @override
  Widget build(BuildContext context) {
    final isBtnDisabled =
        organization.username != null && organization.username!.trim().isEmpty;

    return SafeArea(
      child: Scaffold(
        backgroundColor: COLOR_WHITE,
        appBar: AppBar(
          title: const Text('Organization Account'),
        ),
        body: Stack(
          children: [
            KeyboardDismissableListView(
              padding: const EdgeInsets.all(30),
              children: [
                InputForm(
                  labelText: 'organization_username',
                  prefix: '@',
                  suffix: SvgPicture.asset(
                    'assets/icons/check_filled.svg',
                    width: 20,
                  ),
                  onChanged: (value) {
                    setState(() {
                      organization.username = value;
                    });
                  },
                  helperText:
                      'This username is ID of your organization. It can’t be changed. Make sure to create appropriate username to use it forever.',
                ),
              ],
            ),
            Positioned(
              bottom: 15,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: ElevatedButton(
                  onPressed: isBtnDisabled
                      ? null
                      : () {
                          print(organization);
                        },
                  child: const Text('Next'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
