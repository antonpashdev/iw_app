import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iw_app/models/account_model.dart';
import 'package:iw_app/screens/account_settings/widgets/logout_button.dart';
import 'package:iw_app/screens/account_settings/widgets/settings_item.dart';
import 'package:iw_app/screens/user/edit/edit_user_screen.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

class SettingsSreen extends StatelessWidget {
  final Account? account;

  const SettingsSreen({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    final isUserAccount = account?.isUser == true;

    return ScreenScaffold(
      title: 'Settings',
      child: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: [
          SettingsItem(
            visible: isUserAccount,
            image: Image.asset('assets/icons/edit_account.png'),
            title: 'Edit Profile',
            navigateTo: EditUserScreen(user: account?.user),
          ),
          const SizedBox(height: 40),
          Container(
            alignment: Alignment.centerLeft,
            child: const LogoutButton(),
          ),
        ],
      ),
    );
  }
}
