import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iw_app/api/config_api.dart';
import 'package:iw_app/l10n/generated/app_localizations.dart';
import 'package:iw_app/models/config_model.dart';
import 'package:iw_app/screens/nickname_screen.dart';
import 'package:iw_app/screens/restore_account.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/state/config.dart';
import 'package:iw_app/widgets/utils/app_padding.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  onLogoPressed(Config config, BuildContext context) async {
    if (config.mode == Mode.Lite) {
      config.mode = Mode.Pro;
    } else {
      config.mode = Mode.Lite;
    }
    try {
      await configApi.updateConfig(config);
      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    Config config = ConfigState.of(context).config;
    String slogan = config.mode == Mode.Lite
        ? 'Add your product to be able to provide Pay-as-you-go model for your users'
        : AppLocalizations.of(context)!.loginScreen_slogan;
    return Scaffold(
      backgroundColor: const Color(0xff11243E),
      appBar: AppBar(
        toolbarHeight: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SafeArea(
        child: AppPadding(
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: SizedBox(
                        width: 210,
                        child: Image.asset(
                          'assets/images/logo_with_text.png',
                          width: MediaQuery.of(context).size.width * 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: 310,
                      child: Text(
                        slogan,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Gilroy',
                          fontSize: 22,
                          color: COLOR_WHITE,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.3,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 300),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'For developers!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                fontSize: 18,
                                color: COLOR_WHITE,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.3,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 15),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: const Color(0xff11243E),
                                backgroundColor: COLOR_WHITE,
                              ),
                              child: Text(
                                AppLocalizations.of(context)!
                                    .loginScreen_primaryBtnTitle,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const NicknameScreen(),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: const Color(0xff11243E),
                                backgroundColor: const Color(0xff84C1EC),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const RestoreAccountScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                AppLocalizations.of(context)!
                                    .loginScreen_secondaryBtnTitle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
