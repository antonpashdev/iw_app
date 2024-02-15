import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iw_app/api/users_api.dart';
import 'package:iw_app/app_storage.dart';
import 'package:iw_app/screens/home_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/form/input_form.dart';
import 'package:iw_app/widgets/list/keyboard_dismissable_list.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

class RestoreAccountScreen extends StatefulWidget {
  const RestoreAccountScreen({Key? key}) : super(key: key);

  @override
  State<RestoreAccountScreen> createState() => _RestoreAccountScreenState();
}

class _RestoreAccountScreenState extends State<RestoreAccountScreen> {
  bool isLinkValid = false;
  String? _restoreLink;
  RegExp restoreUrlRegexp =
      RegExp(r'^https:\/\/app\.equitywallet\.org\/restore\/.*$');

  void validateSecretLink(String? value) {
    if (value != null && restoreUrlRegexp.hasMatch(value)) {
      setState(() {
        isLinkValid = true;
      });

      return;
    }

    setState(() {
      isLinkValid = false;
    });
  }

  getValidationStatusIcon() {
    if (isLinkValid == true) {
      return 'assets/icons/check_filled.svg';
    }
    return 'assets/icons/cross_red.svg';
  }

  getValidationStatusText() {
    if (isLinkValid == true) {
      return 'The link is valid';
    }
    return 'The link is invalid';
  }

  restoreAccount(String secretToken) async {
    try {
      final data = await usersApi.restoreAccount(secretToken);
      await appStorage.write('jwt_token', data.token);
      navigateToHomeScreen();
    } catch (e) {
      print(e);
    }
  }

  navigateToHomeScreen() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false,
    );
  }

  String? getSecretTokenFromSecretLink() {
    if (_restoreLink == null) return null;

    Uri uri = Uri.parse(_restoreLink!);
    String path = uri.path;

    String partAfterRestore = path.replaceFirst('/restore/', '');

    return partAfterRestore;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      title: 'Login to My Equity Wallet ',
      child: Column(
        children: <Widget>[
          Expanded(
            child: KeyboardDismissableListView(
              children: [
                const SizedBox(height: 35),
                const Text(
                  'Paste your secret link to access to your Equity Wallet',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: COLOR_ALMOST_BLACK,
                  ),
                ),
                const SizedBox(height: 15),
                AppTextFormFieldBordered(
                  maxLines: 6,
                  minLines: 6,
                  autofocus: true,
                  onChanged: (value) {
                    setState(() {
                      _restoreLink = value;
                    });
                    validateSecretLink(value);
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      getValidationStatusText(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: COLOR_ALMOST_BLACK,
                      ),
                    ),
                    const SizedBox(width: 5),
                    SvgPicture.asset(getValidationStatusIcon()),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 290,
                child: ElevatedButton(
                  onPressed: () {
                    String? code = getSecretTokenFromSecretLink();
                    if (code != null && isLinkValid) {
                      restoreAccount(code);
                    }
                  },
                  child: const Text('Login'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
