import 'package:flutter/material.dart';
import 'package:iw_app/models/account_model.dart';
import 'package:iw_app/screens/account_settings/notifications_screen.dart';
import 'package:iw_app/screens/account_settings/widgets/logout_button.dart';
import 'package:iw_app/screens/account_settings/widgets/settings_item.dart';
import 'package:iw_app/screens/user/edit/edit_user_screen.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

class SettingsScreen extends StatelessWidget {
  final Account? account;

  const SettingsScreen({super.key, required this.account});

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
          SettingsItem(
            visible: isUserAccount,
            icon: Icons.notifications,
            title: 'Notifications',
            navigateTo: const NotificationsScreen(),
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
