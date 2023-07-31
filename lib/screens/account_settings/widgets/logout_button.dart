import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iw_app/app_storage.dart';
import 'package:iw_app/theme/app_theme.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  navigateToLogin(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  removeToken() async {
    await appStorage.deleteValue('jwt_token');
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: const ButtonStyle(
        overlayColor: MaterialStatePropertyAll(Colors.transparent),
        iconColor: MaterialStatePropertyAll(COLOR_RED),
      ),
      onPressed: () {
        removeToken();
        navigateToLogin(context);
      },
      icon: SvgPicture.asset('assets/icons/logout_icon.svg'),
      label: const Text(
        'Log Out',
        style: TextStyle(
          color: COLOR_RED,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
