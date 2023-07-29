import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iw_app/api/models/user_to_update.dart';
import 'package:iw_app/api/users_api.dart';
import 'package:iw_app/models/user_model.dart';
import 'package:iw_app/screens/home_screen.dart';
import 'package:iw_app/screens/user/edit/builders/header.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/form/input_form.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

class EditUserScreen extends StatefulWidget {
  final User? user;

  const EditUserScreen({super.key, required this.user});

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  String? name = '';

  bool saving = false;
  bool isDirty = false;
  final nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    name = widget.user?.name;

    nameController.value = TextEditingValue(text: widget.user?.name ?? '');
  }

  onNameChanged(String? value) {
    setState(() {
      name = value!.trim();
    });
  }

  onAvatarChanged(Uint8List avatar) async {
    widget.user?.avatarToSet = avatar;
    setState(() {
      isDirty = true;
    });
  }

  bool isFormDirty() {
    return name != widget.user?.name || isDirty;
  }

  updateUser() async {
    final avatarResponse =
        await usersApi.uploadAvatar(widget.user?.avatarToSet);
    final avatar = avatarResponse.data;
    return usersApi.updateUser(UserToUpdate(name: name, avatar: avatar));
  }

  removePreviousAvatarIfExist() async {
    if (widget.user?.avatar != null) {
      await usersApi.removeLogos([widget.user!.avatar!]);
    }
  }

  goToHomeScreen() {
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    }
  }

  onSave() async {
    setState(() {
      saving = true;
    });

    try {
      final response = await updateUser();
      final user = User.fromJson(response.data);
      removePreviousAvatarIfExist();

      widget.user?.name = name;
      widget.user?.avatar = user.avatar;

      goToHomeScreen();
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        saving = false;
      });
      widget.user?.avatarToSet = null;
    }
  }

  onCancel() {
    goToHomeScreen();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      title: 'Profile',
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
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildHeader(
              context,
              widget.user,
              nameController,
              onNameChanged,
              onAvatarChanged,
            )
          ],
        ),
      ),
    );
  }
}
