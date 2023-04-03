import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iw_app/app_storage.dart';
import 'package:iw_app/screens/login_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

class SettingsSreen extends StatelessWidget {
  const SettingsSreen({super.key});

  navigateToLogin(BuildContext context) {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      return const LoginScreen();
    }), (route) => false);
  }

  removeToken() async {
    await appStorage.deleteValue('jwt_token');
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
        title: 'Settings',
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 40),
              TextButton.icon(
                  style: const ButtonStyle(
                      iconColor: MaterialStatePropertyAll(COLOR_RED)),
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
                        fontWeight: FontWeight.w600),
                  ))
            ]));
  }
}
